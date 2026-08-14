import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/network/check_internet.dart';
import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';
import 'package:untitled1/features/stores/data/repositories/stores_repository.dart';

abstract class ProductCompareRepository {
  Future<Either<Failure, List<CompareProductListItem>>> getProducts({
    String? category,
    Set<String> excludeProductIds = const {},
  });
}

class ProductCompareRepositoryImpl implements ProductCompareRepository {
  final StoresRepository storesRepository;
  final NetworkInfo networkInfo;

  ProductCompareRepositoryImpl({
    required this.storesRepository,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CompareProductListItem>>> getProducts({
    String? category,
    Set<String> excludeProductIds = const {},
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(OfflineFailure());
    }

    try {
      final storesResult = await storesRepository.getStores();
      return storesResult.fold(
        Left.new,
        (stores) async {
          final items = <CompareProductListItem>[];
          final normalizedCategory = category?.toLowerCase();

          for (final store in stores) {
            final productsResult = await storesRepository.getStoreProducts(store.id);
            productsResult.fold(
              (_) {},
              (products) {
                for (final product in products) {
                  if (normalizedCategory != null &&
                      product.category.toLowerCase() != normalizedCategory) {
                    continue;
                  }
                  if (product.category.isEmpty) continue;
                  if (!product.isAvailable) continue;
                  if (excludeProductIds.contains(product.id)) continue;

                  items.add(
                    CompareProductListItem(
                      businessId: store.id,
                      productId: product.id,
                      storeName: store.name,
                      name: product.name,
                      price: product.price,
                      imageUrl: product.imageUrl,
                      category: product.category,
                      imagePlaceholderColorValue:
                          product.imagePlaceholderColorValue,
                    ),
                  );
                }
              },
            );
          }

          items.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          return Right(items);
        },
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unexpected error'));
    }
  }
}
