import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/core/enums/product_status_enum.dart';
import 'package:untitled1/core/enums/region_enum.dart';
import 'package:untitled1/core/enums/product_category.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/features/used_system/data/repositories/used_system_repository.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/constants/user-parameters.dart';

part 'used_system_state.dart';

class UsedSystemCubit extends Cubit<UsedSystemState> {
  final UsedSystemRepository repository;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final GlobalKey<FormState> addProductKey =
  GlobalKey<FormState>();

  // ==========================================================================
  // FORM VALUES
  // ==========================================================================

  String selectedCategory =
      ProductCategoryEnum.solar_panel.category;

  String selectedCondition =
      ProductStatusEnum.newS.status;

  String selectedRegion =
      RegionEnum.damascus.region;

  // ==========================================================================
  // FILTERS
  // ==========================================================================

  String? filterCategory;
  String? filterCondition;
  String? filterRegion;

  // ==========================================================================
  // IMAGES
  //
  // Exactly 5 slots because the backend accepts:
  //
  // image1
  // image2
  // image3
  // image4
  // image5
  //
  // null = empty slot
  // local path = new image
  // http/https = existing server image
  // ==========================================================================

  List<String?> images = List<String?>.filled(5, null);

  /// Contains indexes of image slots that were changed by the user.
  ///
  /// Example:
  /// {1} => image2 changed
  /// {0, 3} => image1 and image4 changed
  ///
  /// This is especially important for PATCH because unchanged images
  /// should NOT be sent to the server.
   Set<int> changedImageIndexes = {};

  // ==========================================================================
  // PRODUCTS
  // ==========================================================================

  List<UsedProductModel> products = [];
  List<UsedProductModel> myProducts = [];

  UsedSystemCubit(this.repository)
      : super(UsedSystemInitial());

  // ==========================================================================
  // PICK MULTIPLE IMAGES
  // ==========================================================================

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();

    final List<XFile> pickedImages =
    await picker.pickMultiImage(
      imageQuality: 85,
    );

    if (pickedImages.isEmpty) {
      return;
    }

    // Find empty slots.
    final availableIndexes = <int>[];

    for (int i = 0; i < images.length; i++) {
      if (images[i] == null) {
        availableIndexes.add(i);
      }
    }

    if (availableIndexes.isEmpty) {
      return;
    }

    // Add selected images to available slots.
    for (int i = 0; i < pickedImages.length; i++) {
      if (i >= availableIndexes.length) {
        break;
      }

      final int index = availableIndexes[i];

      images[index] = pickedImages[i].path;

      changedImageIndexes.add(index);
    }

    emit(
      UploadImage(
        updateToken:
        DateTime.now().microsecondsSinceEpoch.toDouble(),
      ),
    );
  }

  // ==========================================================================
  // REMOVE IMAGE
  // ==========================================================================

  void removeImage(int index) {
    if (index < 0 || index >= images.length) {
      return;
    }

    // Do NOT remove the item from the list.
    //
    // We keep the slot because:
    //
    // image1 -> image1
    // image2 -> image2
    // image3 -> image3
    //
    // If image2 is deleted, image3 must NOT become image2.
    images[index] = null;

    // Mark this slot as changed so PATCH sends imageX = ''.
    changedImageIndexes.add(index);

    emit(
      UploadImage(
        updateToken:
        DateTime.now().microsecondsSinceEpoch.toDouble(),
      ),
    );
  }

  // ==========================================================================
  // FILTERS
  // ==========================================================================

  void setFilterCategory(String? category) {
    filterCategory =
    category == 'all' ? null : category;

    getUsedProducts();
  }

  void setFilters({
    String? condition,
    String? region,
  }) {
    filterCondition = condition;
    filterRegion = region;

    getUsedProducts();
  }

  void clearFilters() {
    filterCategory = null;
    filterCondition = null;
    filterRegion = null;

    getUsedProducts();
  }

  // ==========================================================================
  // GET USED PRODUCTS
  // ==========================================================================

  Future<void> getUsedProducts({
    bool showLoading = false,
  }) async {
    if (showLoading || products.isEmpty) {
      emit(UsedProductsLoading());
    }

    final query = {
      if (filterCategory != null)
        'category': filterCategory,
      if (filterRegion != null)
        'region': filterRegion,
      if (filterCondition != null)
        'condition': filterCondition,
    };

    final result =
    await repository.getUsedProducts(query);

    result.fold(
          (failure) {
        emit(
          UsedProductsFailure(
            mapFailureToMessage(failure),
          ),
        );
      },
          (success) {
        products = success;

        emit(
          UsedProductsSuccess(products),
        );
      },
    );
  }

  // ==========================================================================
  // GET MY USED PRODUCTS
  // ==========================================================================

  Future<void> getMyUsedProducts({
    bool showLoading = false,
  }) async {
    if (showLoading || myProducts.isEmpty) {
      emit(MyUsedProductsLoading());
    }

    final result =
    await repository.getMyUsedProducts();

    result.fold(
          (failure) {
        emit(
          MyUsedProductsFailure(
            mapFailureToMessage(failure),
          ),
        );
      },
          (success) {
        myProducts = success;

        emit(
          MyUsedProductsSuccess(myProducts),
        );
      },
    );
  }

  // ==========================================================================
  // ADD USED PRODUCT
  // ==========================================================================

  Future<void> addUsedProduct() async {
    if (!(addProductKey.currentState?.validate() ?? false)) {
      return;
    }

    emit(AddUsedProductLoading());

    final params = AddUsedProductParams(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory,
      condition: selectedCondition,
      price:
      double.tryParse(priceController.text.trim()) ?? 0,
      region: selectedRegion,

      // Copy the list so it cannot be modified unexpectedly
      // while the request is running.
      images: List<String?>.from(images),

      // On CREATE all 5 image slots are relevant.
      changedImageIndexes: {0, 1, 2, 3, 4},
    );

    final result =
    await repository.addUsedProduct(params);

    result.fold(
          (failure) {
        emit(
          AddUsedProductFailure(
            mapFailureToMessage(failure),
          ),
        );
      },
          (success) {
        clearForm();

        getUsedProducts();

        emit(
          AddUsedProductSuccess(
            success,
            productAddedSuccessfully,
          ),
        );
      },
    );
  }

  // ==========================================================================
  // UPDATE USED PRODUCT
  // ==========================================================================

  Future<void> updateProduct(int id) async {
    if (!(addProductKey.currentState?.validate() ?? false)) {
      return;
    }

    final oldMyProducts =
    List<UsedProductModel>.from(myProducts);

    final params = AddUsedProductParams(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory,
      condition: selectedCondition,
      price:
      double.tryParse(priceController.text.trim()) ?? 0,
      region: selectedRegion,

      images: List<String?>.from(images),

      // IMPORTANT:
      // Only changed image slots will be sent in PATCH.
      changedImageIndexes: Set<int>.from(changedImageIndexes),    );

    // ==========================================================================
    // OPTIMISTIC UI UPDATE
    // ==========================================================================

    final index =
    myProducts.indexWhere((p) => p.id == id);

    if (index != -1) {
      // UsedProductModel expects List<String>, so remove null
      // slots for the local representation.
      final updatedImages = images
          .whereType<String>()
          .toList();

      myProducts[index] =
          myProducts[index].copyWith(
            name: params.name,
            description: params.description,
            category: params.category,
            condition: params.condition,
            price: params.price.toString(),
            region: params.region,
            images: updatedImages,
          );

      emit(
        MyUsedProductsSuccess(
          List.from(myProducts),
        ),
      );
    }

    emit(UpdateProductLoading());

    final result =
    await repository.updateProduct(
      id,
      params,
    );

    result.fold(
          (failure) {
        // Rollback if request failed.
        myProducts = oldMyProducts;

        emit(
          MyUsedProductsSuccess(
            List.from(myProducts),
          ),
        );

        emit(
          UpdateProductFailure(
            mapFailureToMessage(failure),
          ),
        );
      },
          (success) {
        emit(
          const UpdateProductSuccess(
            productUpdatedStatusSuccessfully,
          ),
        );

        clearForm();
      },
    );
  }

  // ==========================================================================
  // UPDATE PRODUCT STATUS
  // ==========================================================================

  Future<void> updateProductStatus(
      int id,
      String status,
      ) async {
    final oldMyProducts =
    List<UsedProductModel>.from(myProducts);

    final index =
    myProducts.indexWhere((p) => p.id == id);

    if (index != -1) {
      myProducts[index] =
          myProducts[index].copyWith(
            status: status,
          );

      emit(
        MyUsedProductsSuccess(
          List.from(myProducts),
        ),
      );
    }

    emit(
      const UpdateProductStatusLoading(),
    );

    final result =
    await repository.updateProductStatus(
      id,
      status,
    );

    result.fold(
          (failure) {
        myProducts = oldMyProducts;

        emit(
          MyUsedProductsSuccess(
            List.from(myProducts),
          ),
        );

        emit(
          UpdateProductStatusFailure(
            mapFailureToMessage(failure),
          ),
        );
      },
          (success) {
        emit(
          const UpdateProductStatusSuccess(
            productUpdatedStatusSuccessfully,
          ),
        );
      },
    );
  }

  // ==========================================================================
  // DELETE PRODUCT
  // ==========================================================================

  Future<void> deleteProduct(int id) async {
    final oldMyProducts =
    List<UsedProductModel>.from(myProducts);

    myProducts.removeWhere(
          (p) => p.id == id,
    );

    emit(
      MyUsedProductsSuccess(
        List.from(myProducts),
      ),
    );

    emit(
      const DeleteProductLoading(),
    );

    final result =
    await repository.deleteProduct(id);

    result.fold(
          (failure) {
        myProducts = oldMyProducts;

        emit(
          MyUsedProductsSuccess(
            List.from(myProducts),
          ),
        );

        emit(
          DeleteProductFailure(
            mapFailureToMessage(failure),
          ),
        );
      },
          (success) {
        emit(
          const DeleteProductSuccess(
            productDeletedSuccessfully,
          ),
        );
      },
    );
  }

  // ==========================================================================
  // INIT FORM
  // ==========================================================================

  void initForm(UsedProductModel? product) {
    // Always reset changed indexes when opening the form.
    changedImageIndexes.clear();

    if (product != null) {
      // ----------------------------------------------------------
      // EDIT MODE
      // ----------------------------------------------------------

      nameController.text = product.name;
      descriptionController.text =
          product.description;
      priceController.text = product.price;

      selectedRegion = product.region;
      selectedCategory = product.category;
      selectedCondition = product.condition;

      // Always create exactly 5 slots.
      images = List<String?>.filled(5, null);

      // Put existing server images into their original slots.
      for (
      int i = 0;
      i < product.images.length && i < 5;
      i++
      ) {
        images[i] = product.images[i];
      }
    } else {
      // ----------------------------------------------------------
      // ADD MODE
      // ----------------------------------------------------------

      clearForm();
    }

    emit(
      UploadImage(
        updateToken:
        DateTime.now().microsecondsSinceEpoch.toDouble(),
      ),
    );
  }

  // ==========================================================================
  // CLEAR FORM
  // ==========================================================================

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();

    images = List<String?>.filled(5, null);

    changedImageIndexes.clear();

    selectedCategory =
        ProductCategoryEnum.solar_panel.category;

    selectedCondition =
        ProductStatusEnum.newS.status;

    selectedRegion =
        RegionEnum.damascus.region;
  }

  // ==========================================================================
  // CLOSE
  // ==========================================================================

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();

    return super.close();
  }
}