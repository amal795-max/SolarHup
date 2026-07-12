import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/authentication/data/data-source/authentication/authentication_remote_data_source.dart';

class MockApiRequest extends Mock implements ApiRequest {}

void main() {
  late MockApiRequest mockApiRequest;
  late AuthenticationRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiRequest = MockApiRequest();
    dataSource = AuthenticationRemoteDataSourceImpl(mockApiRequest);
  });

  group('checkPhoneNumber', () {
    test('should complete successfully when statusCode = 200', () async {
      when(() => mockApiRequest.post(
        any(),
        body: any(named: 'body'),
      )).thenAnswer(
            (_) async {
          print('✅ MockApiRequest.post called with statusCode=200');
          return Response(
            requestOptions: RequestOptions(path: EndPoints.checkPhoneNumber),
            statusCode: 200,
            data: {'message': 'success'},
          );
        },
      );

      await expectLater(
        dataSource.checkPhoneNumber('0999999999'),
        completes,
      );

      print('✅ checkPhoneNumber finished without exception');

      verify(() => mockApiRequest.post(
        EndPoints.checkPhoneNumber,
        body: AuthenticationParams('0999999999').toJson(),
      )).called(1);

      print('✅ verify passed: post called once with correct params');
    });

    test('should throw ServerException when statusCode != 200', () async {
      when(() => mockApiRequest.post(
        EndPoints.checkPhoneNumber,
        body: AuthenticationParams('0999999999').toJson(),
      )).thenAnswer(
            (_) async {
          print('❌ MockApiRequest.post called with statusCode=422');
          return Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 422,
          );
        },
      );

      await expectLater(
        dataSource.checkPhoneNumber('0999999999'),
        throwsA(isA<ServerException>()),
      );

      print('❌ checkPhoneNumber threw ServerException as expected');

      verify(() => mockApiRequest.post(
        EndPoints.checkPhoneNumber,
        body: AuthenticationParams('0999999999').toJson(),
      )).called(1);

      print('✅ verify passed: post called once with correct params');
    });

  });
}
