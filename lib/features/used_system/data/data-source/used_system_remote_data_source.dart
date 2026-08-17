import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';

import '../../../../core/constants/user-parameters.dart';

abstract class UsedSystemRemoteDataSource {
  Future<UsedProductModel> addUsedProduct(
      AddUsedProductParams params,
      );

  Future<List<UsedProductModel>> getUsedProducts(
      Map<String, dynamic> query,
      );

  Future<List<UsedProductModel>> getMyUsedProducts();

  Future<void> updateProductStatus(
      int id,
      String status,
      );

  Future<void> updateProduct(
      int id,
      AddUsedProductParams params,
      );

  Future<void> deleteProduct(int id);
}

class UsedSystemRemoteDataSourceImpl
    implements UsedSystemRemoteDataSource {
  final ApiRequest apiRequest;

  UsedSystemRemoteDataSourceImpl(this.apiRequest);

  // ==========================================================================
  // ADD USED PRODUCT
  // ==========================================================================

  @override
  Future<UsedProductModel> addUsedProduct(
      AddUsedProductParams params,
      ) async {
    try {
      // ----------------------------------------------------------------------
      // PAYLOAD
      // ----------------------------------------------------------------------

      final payload = jsonEncode({
        'name': params.name,
        'description': params.description,
        'category': params.category,
        'condition': params.condition,
        'price': params.price,
        'region': params.region,
      });

      // ----------------------------------------------------------------------
      // MULTIPART FORM
      //
      // Backend expects:
      //
      // payload
      // image1
      // image2
      // image3
      // image4
      // image5
      // ----------------------------------------------------------------------

      final formDataMap = <String, dynamic>{
        'payload': payload,
      };

      for (int i = 0; i < 5; i++) {
        final imagePath = params.images[i];

        final key = 'image${i + 1}';

        if (imagePath != null &&
            imagePath.isNotEmpty) {
          // New local image.
          formDataMap[key] =
          await MultipartFile.fromFile(
            imagePath,
          );
        } else {
          // Empty image slot.
          formDataMap[key] = '';
        }
      }

      final formData =
      FormData.fromMap(formDataMap);

      // ----------------------------------------------------------------------
      // REQUEST
      // ----------------------------------------------------------------------

      final response = await apiRequest.post(
        EndPoints.usedProducts,
        body: formData,
      );

      if (response.statusCode != 201) {
        throw ServerException(
          message: getErrorMessage(
            response.statusCode ?? 0,
          ),
        );
      }

      return UsedProductModel.fromJson(
        response.data,
      );
    } on DioException catch (e) {
      throw ServerException(
        message: mapDioError(e),
      );
    }
  }

  // ==========================================================================
  // GET USED PRODUCTS
  // ==========================================================================

  @override
  Future<List<UsedProductModel>> getUsedProducts(
      Map<String, dynamic> query,
      ) async {
    try {
      final response = await apiRequest.get(
        EndPoints.usedProducts,
        query: query,
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(
            response.statusCode ?? 0,
          ),
        );
      }

      return (response.data['products'] as List)
          .map(
            (item) => UsedProductModel.fromJson(item),
      )
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: mapDioError(e),
      );
    }
  }

  // ==========================================================================
  // GET MY USED PRODUCTS
  // ==========================================================================

  @override
  Future<List<UsedProductModel>>
  getMyUsedProducts() async {
    try {
      final response = await apiRequest.get(
        EndPoints.myUsedProducts,
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(
            response.statusCode ?? 0,
          ),
        );
      }

      return (response.data['products'] as List)
          .map(
            (item) => UsedProductModel.fromJson(item),
      )
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        message: mapDioError(e),
      );
    }
  }

  // ==========================================================================
  // UPDATE PRODUCT STATUS
  // ==========================================================================

  @override
  Future<void> updateProductStatus(
      int id,
      String status,
      ) async {
    try {
      final response =
      await apiRequest.patch(
        EndPoints.updateProductStatus(id),
        body: {
          'status': status,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(
            response.statusCode ?? 0,
          ),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: mapDioError(e),
      );
    }
  }

  // ==========================================================================
  // UPDATE PRODUCT
  // ==========================================================================

  @override
  Future<void> updateProduct(
      int id,
      AddUsedProductParams params,
      ) async {
    try {
      // ----------------------------------------------------------------------
      // PAYLOAD
      // ----------------------------------------------------------------------

      final payload = jsonEncode({
        'name': params.name,
        'description': params.description,
        'category': params.category,
        'condition': params.condition,
        'price': params.price,
        'region': params.region,
      });

      // ----------------------------------------------------------------------
      // FORM DATA
      //
      // IMPORTANT:
      //
      // We DON'T send all image1..image5 here.
      //
      // We send ONLY image slots that changed.
      //
      // This gives us three behaviors:
      //
      // 1. Existing image unchanged:
      //      Don't send imageX.
      //
      // 2. Existing image deleted:
      //      imageX = ''
      //
      // 3. New image:
      //      imageX = MultipartFile
      // ----------------------------------------------------------------------

      final formDataMap = <String, dynamic>{
        'payload': payload,
      };

      for (final index
      in params.changedImageIndexes) {
        if (index < 0 || index >= 5) {
          continue;
        }

        final key = 'image${index + 1}';

        final imageSource =
        params.images[index];

        // --------------------------------------------------------------------
        // IMAGE DELETED
        // --------------------------------------------------------------------

        if (imageSource == null ||
            imageSource.isEmpty) {
          formDataMap[key] = '';
          continue;
        }

        // --------------------------------------------------------------------
        // NEW IMAGE
        // --------------------------------------------------------------------

        final isRemoteImage =
            imageSource.startsWith('http://') ||
                imageSource.startsWith('https://');

        if (!isRemoteImage) {
          formDataMap[key] =
          await MultipartFile.fromFile(
            imageSource,
          );
        }

        // --------------------------------------------------------------------
        // EXISTING REMOTE IMAGE
        //
        // We intentionally DON'T send it.
        //
        // The backend should keep it because imageX was not included
        // in the PATCH request.
        // --------------------------------------------------------------------
      }

      final formData =
      FormData.fromMap(formDataMap);

      // ----------------------------------------------------------------------
      // PATCH REQUEST
      // ----------------------------------------------------------------------

      final response =
      await apiRequest.patch(
        EndPoints.updateProduct(id),
        body: formData,
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(
            response.statusCode ?? 0,
          ),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: mapDioError(e),
      );
    }
  }

  // ==========================================================================
  // DELETE PRODUCT
  // ==========================================================================

  @override
  Future<void> deleteProduct(int id) async {
    try {
      final response =
      await apiRequest.delete(
        EndPoints.deleteProduct(id),
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(
            response.statusCode ?? 0,
          ),
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: mapDioError(e),
      );
    }
  }
}