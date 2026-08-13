import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/api/api_response_utils.dart';
import 'package:untitled1/features/services/data/models/workshop_detail_model.dart';
import 'package:untitled1/features/services/data/model/workshop_list_response_model.dart';
import 'package:untitled1/features/services/data/model/workshop_services_response_model.dart';
import 'package:untitled1/features/services/data/models/workshop_model.dart';
import 'package:untitled1/features/services/data/models/workshop_offering_model.dart';
import 'package:untitled1/features/services/data/models/workshop_service_model.dart';
import 'package:untitled1/features/stores/data/model/store_categories_response_model.dart';
import 'package:untitled1/features/stores/data/models/store_category_model.dart';

abstract class WorkshopsRemoteDataSource {
  Future<List<StoreCategoryModel>> getWorkshopCategories();
  Future<List<WorkshopModel>> getWorkshops({String? region});
  Future<WorkshopDetailModel> getWorkshop(String businessId);
  Future<List<WorkshopServiceModel>> getWorkshopServices(
    String businessId, {
    int? categoryId,
  });
  Future<List<WorkshopOfferingModel>> getOfferingsForCategory(int categoryId);
}

class WorkshopsRemoteDataSourceImpl implements WorkshopsRemoteDataSource {
  final ApiRequest apiRequest;

  WorkshopsRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<List<StoreCategoryModel>> getWorkshopCategories() async {
    try {
      final response = await apiRequest.get(
        EndPoints.storeCategories,
        query: const {'type': 'workshop'},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return StoreCategoriesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).toStoreCategoryModels();
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<WorkshopDetailModel> getWorkshop(String businessId) async {
    try {
      final response = await apiRequest.get(EndPoints.workshop(businessId));
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return WorkshopDetailModel.fromApi(
        WorkshopApiModel.fromJson(
          unwrapWorkshopPayload(response.data as Map<String, dynamic>),
        ),
      );
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<WorkshopModel>> getWorkshops({String? region}) async {
    try {
      final response = await apiRequest.get(
        EndPoints.workshops,
        query: region == null || region.isEmpty ? null : {'region': region},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return WorkshopListResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).toWorkshopModels();
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<WorkshopServiceModel>> getWorkshopServices(
    String businessId, {
    int? categoryId,
  }) async {
    try {
      final response = await apiRequest.get(
        EndPoints.workshopServices(businessId),
        query: categoryId == null ? null : {'category_id': categoryId},
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      }
      return WorkshopServicesResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      ).toWorkshopServiceModels();
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<List<WorkshopOfferingModel>> getOfferingsForCategory(
    int categoryId,
  ) async {
    final workshops = await getWorkshops();
    final offerings = <WorkshopOfferingModel>[];

    await Future.wait(
      workshops.map((workshop) async {
        try {
          final services = await getWorkshopServices(
            workshop.id,
            categoryId: categoryId,
          );
          for (final service in services) {
            if (!service.isAvailable) continue;
            offerings.add(
              WorkshopOfferingModel(
                workshopId: workshop.id,
                workshopName: workshop.name,
                location: workshop.location,
                logoUrl: workshop.logoUrl,
                coverImageUrl: workshop.coverImageUrl,
                iconColorValue: workshop.iconColorValue,
                serviceId: service.id,
                serviceName: service.name,
                serviceDescription: service.description.isNotEmpty
                    ? service.description
                    : null,
                price: service.price,
                estimatedDurationMinutes: service.estimatedDurationMinutes,
                imageUrl: service.imageUrl,
                isAvailable: service.isAvailable,
              ),
            );
          }
        } on ServerException {
          // Skip workshops that fail individually.
        }
      }),
    );

    offerings.sort((a, b) => a.price.compareTo(b.price));
    return offerings;
  }
}
