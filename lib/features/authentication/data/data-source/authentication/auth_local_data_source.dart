import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kitch_plus/core/api/api_keys.dart';
import 'package:kitch_plus/core/constants/local_storage.dart';
import 'package:kitch_plus/features/authentication/data/model/login_model/login_model.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class AuthLocalDataSource{
  Future<LoginModel> getCachedUser();
  Future<Unit> cacheUser(LoginModel loginModel);
}
class AuthLocalDataSourceImpl implements AuthLocalDataSource{

  @override
  Future<Unit> cacheUser(LoginModel loginModel) {
    LocalStorage().saveData(key: ApiKeys.token,value:loginModel.dataLoginModel.token);
    LocalStorage().saveData(key: ApiKeys.email,value:loginModel.dataLoginModel.clientModel.email);
    LocalStorage().saveData(key: ApiKeys.name,value:loginModel.dataLoginModel.clientModel.name);
    return Future.value(unit);
  }
  @override
  Future<LoginModel> getCachedUser() {
    final jsonString = LocalStorage().getData(key: "CacheUser");
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return Future.value(LoginModel.fromJson(jsonMap));
    } else {
      throw EmptyCacheException();
    }
  }
}