import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/failure_success_message.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/core/enums/product_status_enum.dart';
import 'package:untitled1/core/enums/region_enum.dart';
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/features/used_system/data/repositories/used_system_repository.dart';

import '../../../../core/enums/product_category.dart';

part 'used_system_state.dart';

class UsedSystemCubit extends Cubit<UsedSystemState> {
  final UsedSystemRepository repository;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final GlobalKey<FormState> addProductKey = GlobalKey<FormState>();

  String selectedCategory = ProductCategoryEnum.solar_panel.category;
  String selectedCondition = ProductStatusEnum.newS.status;
  String selectedRegion = RegionEnum.damascus.region;

  String? filterCategory;
  String? filterCondition;
  String? filterRegion;

  List<String> images = [];
  List<UsedProductModel> products = [];
  List<UsedProductModel> myProducts = [];

  UsedSystemCubit(this.repository) : super(UsedSystemInitial());

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);

      images.add(base64Image);
      emit(UploadImage());
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
    emit(UploadImage());
  }

  void setFilterCategory(String? category) {
    filterCategory = category == 'all' ? null : category;
    getUsedProducts();
  }

  void setFilters({String? condition, String? region}) {
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

  Future<void> getUsedProducts() async {
    emit(UsedProductsLoading());
    final query = {
      if (filterCategory != null) 'category': filterCategory,
      if (filterRegion != null) 'region': filterRegion,
      if (filterCondition != null) 'condition': filterCondition,
    };

    final result = await repository.getUsedProducts(query);
    result.fold(
      (failure) => emit(UsedProductsFailure(mapFailureToMessage(failure))),
      (success) {
        products = success;
        emit(UsedProductsSuccess(products));
      },
    );
  }

  Future<void> getMyUsedProducts() async {
    emit(MyUsedProductsLoading());
    final result = await repository.getMyUsedProducts();
    result.fold(
      (failure) => emit(MyUsedProductsFailure(mapFailureToMessage(failure))),
      (success) {
        myProducts = success;
        emit(MyUsedProductsSuccess(myProducts));
      },
    );
  }

  Future<void> addUsedProduct() async {
    if (addProductKey.currentState?.validate() ?? false) {
      emit(AddUsedProductLoading());
      final params = AddUsedProductParams(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        condition: selectedCondition,
        price: double.tryParse(priceController.text.trim()) ?? 0,
        region: selectedRegion,
        images: images,
      );
      final result = await repository.addUsedProduct(params);
      result.fold(
        (failure) => emit(AddUsedProductFailure(mapFailureToMessage(failure))),
        (success) {
          clearForm();
          getUsedProducts();
          emit(AddUsedProductSuccess(success, productAddedSuccessfully));
        },
      );
    }
  }

  Future<void> updateProduct(int id) async {
    if (addProductKey.currentState?.validate() ?? false) {
      final oldMyProducts = List<UsedProductModel>.from(myProducts);
      final params = AddUsedProductParams(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory,
        condition: selectedCondition,
        price: double.tryParse(priceController.text.trim()) ?? 0,
        region: selectedRegion,
        images: images,
      );

      final index = myProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        myProducts[index] = myProducts[index].copyWith(
          name: params.name,
          description: params.description,
          category: params.category,
          condition: params.condition,
          price: params.price.toString(),
          region: params.region,
          images: images.any((img) => !img.startsWith('http'))
              ? images
              : myProducts[index].images,
        );
        emit(MyUsedProductsSuccess(List.from(myProducts)));
      }

      emit(UpdateProductLoading());
      final result = await repository.updateProduct(id, params);
      result.fold(
        (failure) {
          myProducts = oldMyProducts;
          emit(MyUsedProductsSuccess(List.from(myProducts)));
          emit(UpdateProductFailure(mapFailureToMessage(failure)));
        },
        (success) {
          emit(const UpdateProductSuccess(productUpdatedStatusSuccessfully));
          clearForm();
        },
      );
    }
  }

  Future<void> updateProductStatus(int id, String status) async {
    final oldMyProducts = List<UsedProductModel>.from(myProducts);
    final index = myProducts.indexWhere((p) => p.id == id);
    if (index != -1) {
      myProducts[index] = myProducts[index].copyWith(status: status);
      emit(MyUsedProductsSuccess(List.from(myProducts)));
    }
    emit(const UpdateProductStatusLoading());

    final result = await repository.updateProductStatus(id, status);
    result.fold(
      (failure) {
        myProducts = oldMyProducts;
        emit(MyUsedProductsSuccess(List.from(myProducts)));
        emit(UpdateProductStatusFailure(mapFailureToMessage(failure)));
      },
      (success) {
        emit(
          const UpdateProductStatusSuccess(productUpdatedStatusSuccessfully),
        );
      },
    );
  }

  Future<void> deleteProduct(int id) async {
    final oldMyProducts = List<UsedProductModel>.from(myProducts);
    myProducts.removeWhere((p) => p.id == id);
    emit(MyUsedProductsSuccess(List.from(myProducts)));

    emit(const DeleteProductLoading());
    final result = await repository.deleteProduct(id);
    result.fold(
      (failure) {
        myProducts = oldMyProducts;
        emit(MyUsedProductsSuccess(List.from(myProducts)));
        emit(DeleteProductFailure(mapFailureToMessage(failure)));
      },
      (success) {
        emit(const DeleteProductSuccess(productDeletedSuccessfully));
      },
    );
  }

  void initForm(UsedProductModel? product) {
    if (product != null) {
      nameController.text = product.name;
      descriptionController.text = product.description;
      priceController.text = product.price;
      selectedRegion = product.region;
      selectedCategory = product.category;
      selectedCondition = product.condition;
      images = List.from(product.images);
    } else {
      clearForm();
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    images.clear();
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    return super.close();
  }
}
