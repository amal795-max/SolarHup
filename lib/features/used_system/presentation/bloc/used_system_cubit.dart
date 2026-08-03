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
import 'package:untitled1/features/used_system/data/model/used_product_model.dart';
import 'package:untitled1/features/used_system/data/repositories/used_system_repository.dart';

import '../../../../core/enums/product_category.dart';

part 'used_system_state.dart';

class UsedSystemCubit extends Cubit<UsedSystemState> {
  final UsedSystemRepository repository;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final regionController = TextEditingController();
  final GlobalKey<FormState> addProductKey = GlobalKey<FormState>();

  String selectedCategory = 'solar_panel';
  String selectedCondition = 'new';
  
  String? filterCategory;
  String? filterCondition;
  String? filterRegion;
  
  List<String> images = [];

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
      (success) => emit(UsedProductsSuccess(success)),
    );
  }

  Future<void> getMyUsedProducts() async {
    emit(MyUsedProductsLoading());
    final result = await repository.getMyUsedProducts();
    result.fold(
      (failure) => emit(MyUsedProductsFailure(mapFailureToMessage(failure))),
      (success) => emit(MyUsedProductsSuccess(success)),
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
        region: regionController.text.trim(),
        images: images,
      );
      final result = await repository.addUsedProduct(params);
      result.fold(
        (failure) => emit(AddUsedProductFailure(mapFailureToMessage(failure))),
        (success) {
          clearForm();
          emit(AddUsedProductSuccess(success, productAddedSuccessfully));
        },
      );
    }
  }

  void clearForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    regionController.clear();
    images.clear();
    selectedCategory = ProductCategoryEnum.solar_panel.category;
    selectedCondition = ProductStatusEnum.newS.status;
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    regionController.dispose();
    return super.close();
  }
}
