import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/features/blog/data/model/blog_list_response_model.dart';
import 'package:untitled1/features/blog/data/models/blog_article_model.dart';

abstract class BlogRemoteDataSource {
  Future<BlogFeedModel> getBlogFeed();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final ApiRequest apiRequest;

  BlogRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<BlogFeedModel> getBlogFeed() async {
    try {
      final response = await apiRequest.get(EndPoints.blogArticles);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return BlogListResponseModel.fromJson(response.data).toFeedModel();
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
