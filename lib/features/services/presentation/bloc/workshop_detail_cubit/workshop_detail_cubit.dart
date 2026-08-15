import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/features/catalog/data/models/discount_model.dart';
import 'package:untitled1/features/catalog/data/repositories/catalog_repository.dart';
import 'package:untitled1/features/services/data/models/workshop_detail_model.dart';
import 'package:untitled1/features/services/data/models/workshop_service_model.dart';
import 'package:untitled1/features/services/data/repositories/workshops_repository.dart';

part 'workshop_detail_state.dart';

class WorkshopDetailCubit extends Cubit<WorkshopDetailState> {
  final WorkshopsRepository repository;
  final CatalogRepository catalogRepository;

  WorkshopDetailCubit(this.repository, this.catalogRepository)
      : super(WorkshopDetailInitial());

  Future<void> loadWorkshop(
    String businessId, {
    int? categoryId,
  }) async {
    emit(WorkshopDetailLoading());

    final workshopResult = await repository.getWorkshop(businessId);
    await workshopResult.fold(
      (failure) async {
        emit(WorkshopDetailError(message: mapFailureToMessage(failure)));
      },
      (workshop) async {
        final servicesResult = await repository.getWorkshopServices(
          businessId,
          categoryId: categoryId,
        );
        final services = servicesResult.fold(
          (_) => <WorkshopServiceModel>[],
          (items) => items,
        );

        final parsedBusinessId = int.tryParse(businessId) ?? 0;
        final discounts = parsedBusinessId > 0
            ? (await catalogRepository.getWorkshopDiscounts(parsedBusinessId))
                .fold((_) => <DiscountModel>[], (items) => items)
            : <DiscountModel>[];

        emit(
          WorkshopDetailLoaded(
            workshop: workshop,
            services: services,
            discounts: discounts,
          ),
        );
      },
    );
  }
}
