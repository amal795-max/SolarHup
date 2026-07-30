import 'package:dio/dio.dart';
import 'package:untitled1/core/api/api-requests.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/constants/app_url.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/chatbot/data/model/conversation_details_model.dart';
import 'package:untitled1/features/chatbot/data/model/list_conversations_model.dart';
import 'package:untitled1/features/chatbot/data/model/recommend_model.dart';

abstract class ChatBotRemoteDataSource {
  Future<RecommendResponseModel> recommend(RecommendParams body);
  Future <ConversationsListModel> getConversations();
  Future<ConversationDetailsModel> getConversationDetails(int conversationId);
}

class ChatBotRemoteDataSourceImpl implements ChatBotRemoteDataSource {
  final ApiRequest apiRequest;

  ChatBotRemoteDataSourceImpl(this.apiRequest);

  @override
  Future<RecommendResponseModel> recommend(RecommendParams body) async {
    try {
      final response = await apiRequest.post(
        EndPoints.recommend,

        body: FormData.fromMap({
          'message': body.message,
          if (body.budget != null) 'budget': body.budget,
          if (body.conversationId != null) 'conversation_id': body.conversationId,
          if (body.image != null)  'image':await MultipartFile.fromFile(body.image??''),
        })
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        print(body.conversationId);
        return RecommendResponseModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future <ConversationsListModel> getConversations() async {
    try {
      final response = await apiRequest.get(EndPoints.conversations);
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return  ConversationsListModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }

  @override
  Future<ConversationDetailsModel> getConversationDetails(int conversationId) async {
    try {
      final response = await apiRequest.get(
        EndPoints.conversationDetails(conversationId),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: getErrorMessage(response.statusCode ?? 0),
        );
      } else {
        return ConversationDetailsModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      throw ServerException(message: mapDioError(e));
    }
  }
}
