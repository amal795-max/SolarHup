import 'package:untitled1/features/chatbot/data/model/recommend_model.dart';

enum MessageRole { user, assistant }

class ChatMessage {
  final String? content;
  final MessageRole role;
  final String? imagePath;
  final RecommendedProduct? product;
  final bool isProduct;

  ChatMessage({
    this.content,
    required this.role,
    this.imagePath,
    this.product,
    this.isProduct = false,
  });

  factory ChatMessage.assistant(String text) => 
      ChatMessage(content: text, role: MessageRole.assistant);

  factory ChatMessage.product(RecommendedProduct product) => 
      ChatMessage(role: MessageRole.assistant, product: product, isProduct: true);

  factory ChatMessage.user(String text, {String? imagePath}) => 
      ChatMessage(content: text, role: MessageRole.user, imagePath: imagePath);
}
