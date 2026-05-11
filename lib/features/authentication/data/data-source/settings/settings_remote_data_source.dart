import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:kitch_plus/features/authentication/data/model/PrivacyPolicyModel.dart';
import 'package:kitch_plus/features/authentication/data/model/TermsOfUseModel.dart';

import '../../../../../core/api/api-requests.dart';
import '../../../../../core/api/api_keys.dart';
import '../../../../../core/errors/exceptions.dart';

abstract class TermsAndPrivacyRemoteDataSource{
  Future<PrivacyPolicyModel> privacyPolicy();
  Future<TermsOfUseModel> termsOfUse();

}
class TermsAndPrivacyRemoteDataSourceImpl implements TermsAndPrivacyRemoteDataSource{
  final ApiRequest api;

  TermsAndPrivacyRemoteDataSourceImpl({required this.api});
  @override
  Future<PrivacyPolicyModel> privacyPolicy() async{
    print("================Start get privacy");
    final response = await api.get(EndPoint.showPrivacyPolicy,);
    if (response.statusCode == 201) {
      final decodedJson = json.decode(response.body);
      PrivacyPolicyModel privacyPolicyModel = PrivacyPolicyModel.fromJson(decodedJson);
      return privacyPolicyModel;
    }
    else {
      print("Error ${response.statusCode}: ${response.body}");
      throw ServerException(message: getErrorMessage(response.statusCode));
    }
  }

  @override
  Future<TermsOfUseModel> termsOfUse() async{
    final response = await api.get(EndPoint.showTerms,);
    if (response.statusCode == 201) {
      final decodedJson = json.decode(response.body);
      TermsOfUseModel termsOfUseModel = TermsOfUseModel.fromJson(decodedJson);
      return termsOfUseModel;
    }
    else {
      print("Error ${response.statusCode}: ${response.body}");
      throw ServerException(message: getErrorMessage(response.statusCode));
    }
  }
}