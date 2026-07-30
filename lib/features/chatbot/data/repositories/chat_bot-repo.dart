import 'package:dartz/dartz.dart';
import 'package:untitled1/core/api/errors/exceptions.dart';
import 'package:untitled1/core/api/errors/failures.dart';
import 'package:untitled1/core/constants/user-parameters.dart';
import 'package:untitled1/features/chatbot/data/data_source/chat_bot_remote_data_source.dart';
import 'package:untitled1/features/chatbot/data/model/list_conversations_model.dart';
import 'package:untitled1/features/chatbot/data/model/recommend_model.dart';
import '../../../../core/network/check_internet.dart';
import '../model/conversation_details_model.dart';

abstract class ChatBotRepository {
  Future<Either<Failure, RecommendResponseModel>> recommend(RecommendParams params);
  Future<Either<Failure, ConversationsListModel>> getConversations();
  Future<Either<Failure, ConversationDetailsModel>> getConversationDetails(int conversationId);
}

class ChatBotRepositoryImpl implements ChatBotRepository {
  final ChatBotRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatBotRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, RecommendResponseModel>> recommend(RecommendParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.recommend(params);
        return Right(remoteResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ConversationsListModel>> getConversations() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.getConversations();
        return Right(remoteResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, ConversationDetailsModel>> getConversationDetails(int conversationId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await remoteDataSource.getConversationDetails(conversationId);
        return Right(remoteResponse);
      } on ServerException catch (e) {
        return Left(ServerFailure( e.message));
      }
    } else {
      return const Left(OfflineFailure());
    }
  }
}
