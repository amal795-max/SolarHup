import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:kitch_plus/core/api/api_keys.dart';
import 'package:kitch_plus/features/authentication/data/model/login_model/login_model.dart';

import '../../../../../core/api/api-requests.dart';
import '../../../../../core/constants/local_storage.dart';
import '../../../../../core/constants/user-parameters.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../model/register_Model/register_model.dart';


abstract class AuthRemoteDataSource{
  Future<RegisterModel> register(RegisterParams registerParams);
  Future<LoginModel> login(LoginParams loginParams);
  Future<Unit> logout();

}

 class  AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
   final ApiRequest api;
   AuthRemoteDataSourceImpl({required this.api});
   @override

  Future<RegisterModel> register(RegisterParams params) async {
     final body = {
       "name": params.name,
       "email": params.email,
       "password": params.password,
       "password_confirmation": params.password_confirmation,
     };
     final response = await api.post(EndPoint.register, body);

    if (response.statusCode == 201 ) {
      final decodedJson = json.decode(response.body);
      RegisterModel registerModel = RegisterModel.fromJson(decodedJson);
      return registerModel;
    }
    else {
       print("Error ${response.statusCode}: ${response.body}");
      throw ServerException(message:getErrorMessage(response.statusCode));
    }
  }

  @override
  Future<LoginModel> login(LoginParams loginParams) async{
    final body ={
    ApiKeys.email:loginParams.email,
    ApiKeys.password:loginParams.password,
    };
    final response = await api.post(EndPoint.login,body);

    if(response.statusCode == 200){
      final decodedJson = json.decode(response.body);
    LoginModel loginModel = LoginModel.fromJson(decodedJson);
      LocalStorage().saveData(key: ApiKeys.token,value:loginModel.dataLoginModel.token);
      LocalStorage().saveData(key: ApiKeys.email,value:loginModel.dataLoginModel.clientModel.email);
      LocalStorage().saveData(key: ApiKeys.name,value:loginModel.dataLoginModel.clientModel.name);
      print(LocalStorage().getData(key: ApiKeys.token));
      return loginModel;
    }
    else {
      print("Error ${response.statusCode}: ${response.body}");
      throw ServerException(message:getErrorMessage(response.statusCode));
    }  }

  @override
  Future<Unit> logout() async{
    final response = await api.post(EndPoint.logout,null);
    if(response.statusCode == 200){
     return Future.value(unit);
  }
    else{
      print("Error ${response.statusCode}: ${response.body}");
      throw ServerException(message: getErrorMessage(response.statusCode));
    }
    }

 }