import '../dependency/injection.dart';
import '../models/llm_chat_models.dart';
import 'chat_ai_service.dart';

class LlmChatbotService {
  final ChatAIService _chatAiService;

  LlmChatbotService({ChatAIService? chatAiService})
      : _chatAiService = chatAiService ?? getIt<ChatAIService>();

  Future<LlmChatResponse> sendMessage({
    required String message,
    String? sessionId,
    List<LlmChatHistoryItem> history = const [],
  }) async {
    final normalizedSessionId = (sessionId != null && sessionId.trim().isNotEmpty) ? sessionId : null;

    final response = await _chatAiService.sendMessage(
      message: message,
      conversationId: normalizedSessionId,
    );

    return LlmChatResponse.fromChatAIResponse(response);
  }
}
