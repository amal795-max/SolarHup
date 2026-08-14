import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/api_response_utils.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/blog/data/model/blog_list_response_model.dart';
import 'package:untitled1/features/blog/data/models/blog_article_detail_model.dart';

abstract class BlogDetailRemoteDataSource {
  Future<BlogArticleDetailModel> getArticleDetail(String articleId);
}

class BlogDetailRemoteDataSourceImpl implements BlogDetailRemoteDataSource {
  final ApiRequest apiRequest;

  BlogDetailRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<BlogArticleDetailModel> getArticleDetail(String articleId) async {
    try {
      final response = await apiRequest.get(EndPoints.blogArticle(articleId));
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        final data = response.data;
        final json = data is Map<String, dynamic>
            ? unwrapApiPayload(data)
            : data as Map<String, dynamic>;
        return BlogArticleApiModel.fromJson(json).toDetailModel();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
