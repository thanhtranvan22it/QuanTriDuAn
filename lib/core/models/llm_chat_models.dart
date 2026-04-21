import 'package:equatable/equatable.dart';

import 'chat_ai_model.dart' as chat_ai;

class LlmChatHistoryItem extends Equatable {
  final String role;
  final String content;

  const LlmChatHistoryItem({
    required this.role,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }

  factory LlmChatHistoryItem.fromJson(Map<String, dynamic> json) {
    return LlmChatHistoryItem(
      role: (json['role'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
    );
  }

  @override
  List<Object?> get props => [role, content];
}

class LlmChatDish extends Equatable {
  final String id;
  final String title;
  final String image;
  final Map<String, dynamic> raw;

  const LlmChatDish({
    required this.id,
    required this.title,
    required this.image,
    required this.raw,
  });

  factory LlmChatDish.fromChatAi(chat_ai.MonAnSuggestion dish) {
    return LlmChatDish(
      id: dish.maMonAn,
      title: dish.tenMonAn,
      image: dish.hinhAnh,
      raw: {
        'dish_id': dish.maMonAn,
        'ma_mon_an': dish.maMonAn,
        'title': dish.tenMonAn,
        'ten_mon_an': dish.tenMonAn,
        'image': dish.hinhAnh,
        'hinh_anh': dish.hinhAnh,
      },
    );
  }

  @override
  List<Object?> get props => [id, title, image, raw];
}

class LlmChatShop extends Equatable {
  final String id;
  final String name;
  final Map<String, dynamic> raw;

  const LlmChatShop({
    required this.id,
    required this.name,
    required this.raw,
  });

  factory LlmChatShop.fromChatAi(chat_ai.GianHangSuggest shop) {
    return LlmChatShop(
      id: shop.maGianHang,
      name: shop.tenGianHang,
      raw: {
        'ma_gian_hang': shop.maGianHang,
        'ten_gian_hang': shop.tenGianHang,
        'vi_tri': shop.viTri,
        'gia': shop.gia,
        'don_vi_ban': shop.donViBan,
        'so_luong': shop.soLuong,
      },
    );
  }

  @override
  List<Object?> get props => [id, name, raw];
}

class LlmChatResponse extends Equatable {
  final String reply;
  final String sessionId;
  final List<LlmChatDish> dishes;
  final List<LlmChatShop> shops;
  final String responseType;

  const LlmChatResponse({
    required this.reply,
    required this.sessionId,
    this.dishes = const [],
    this.shops = const [],
    this.responseType = 'text',
  });

  factory LlmChatResponse.fromChatAIResponse(chat_ai.ChatAIResponse response) {
    final suggestions = response.suggestions;
    final dishes = suggestions?.monAn.map(LlmChatDish.fromChatAi).toList() ?? const <LlmChatDish>[];

    final shopsById = <String, LlmChatShop>{};
    final ingredientSuggestions = suggestions?.nguyenLieu ?? const <chat_ai.NguyenLieuSuggestion>[];
    for (final ingredient in ingredientSuggestions) {
      final shop = ingredient.gianHangSuggest;
      if (shop == null || shop.maGianHang.isEmpty) {
        continue;
      }
      shopsById.putIfAbsent(shop.maGianHang, () => LlmChatShop.fromChatAi(shop));
    }

    return LlmChatResponse(
      reply: response.message,
      sessionId: response.conversationId,
      dishes: dishes,
      shops: shopsById.values.toList(),
      responseType: response.responseType,
    );
  }

  @override
  List<Object?> get props => [reply, sessionId, dishes, shops, responseType];
}
