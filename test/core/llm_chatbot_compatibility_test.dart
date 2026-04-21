import 'package:flutter_test/flutter_test.dart';
import 'package:dngo/core/models/chat_ai_model.dart' as chat_ai;
import 'package:dngo/core/models/llm_chat_models.dart';

void main() {
  group('LlmChatResponse', () {
    test('maps ChatAIResponse suggestions into llm chatbot contract', () {
      final chatAiResponse = chat_ai.ChatAIResponse(
        success: true,
        responseType: 'suggestions',
        message: 'Goi y cho ban',
        suggestions: chat_ai.ChatSuggestions(
          monAn: [
            chat_ai.MonAnSuggestion(
              maMonAn: 'dish-1',
              tenMonAn: 'Pho bo',
              hinhAnh: 'pho.png',
            ),
          ],
          nguyenLieu: [
            chat_ai.NguyenLieuSuggestion(
              maNguyenLieu: 'ingredient-1',
              tenNguyenLieu: 'Thit bo',
              gianHangSuggest: chat_ai.GianHangSuggest(
                maGianHang: 'shop-1',
                tenGianHang: 'Hang thit',
                viTri: 'A1',
                gia: '120000',
                donViBan: 'kg',
                soLuong: 2,
              ),
              actions: chat_ai.NguyenLieuActions(
                canViewDetail: true,
                canAddToCart: true,
                detailEndpoint: '/detail',
                addToCartEndpoint: '/cart',
              ),
            ),
          ],
        ),
        conversationId: 'conv-1',
      );

      final response = LlmChatResponse.fromChatAIResponse(chatAiResponse);

      expect(response.reply, 'Goi y cho ban');
      expect(response.sessionId, 'conv-1');
      expect(response.dishes, hasLength(1));
      expect(response.dishes.first.title, 'Pho bo');
      expect(response.dishes.first.raw['ma_mon_an'], 'dish-1');
      expect(response.shops, hasLength(1));
      expect(response.shops.first.raw['ma_gian_hang'], 'shop-1');
    });
  });

  group('LlmChatHistoryItem', () {
    test('serializes to api history shape', () {
      const item = LlmChatHistoryItem(role: 'user', content: 'Xin chao');

      expect(item.toJson(), {
        'role': 'user',
        'content': 'Xin chao',
      });
    });
  });
}
