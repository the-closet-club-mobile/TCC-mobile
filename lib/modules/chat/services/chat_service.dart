import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:the_closet_club_mobile/core/api_config.dart';
import 'package:the_closet_club_mobile/modules/chat/models/conversation.dart';
import 'package:the_closet_club_mobile/modules/chat/models/message.dart';

class ChatException implements Exception {
  final String message;
  final bool unauthorized;

  const ChatException(this.message, {this.unauthorized = false});

  @override
  String toString() => message;
}

class RoomData {
  final ConversationInfo info;
  final List<Message> messages;

  const RoomData({required this.info, required this.messages});
}

class ChatService {
  final CookieRequest request;

  ChatService(this.request);

  String _url(String path) => '${ApiConfig.baseUrl}/chat/api$path';

  /// DRF errors come back as {"detail": "..."}; turn them into exceptions.
  dynamic _checkError(dynamic data) {
    if (data is Map && data.containsKey('detail')) {
      final detail = data['detail'].toString();
      throw ChatException(
        detail,
        unauthorized: detail.toLowerCase().contains('credentials'),
      );
    }
    return data;
  }

  Future<List<Conversation>> fetchConversations() async {
    dynamic data;
    try {
      data = await request.get(_url('/conversations/'));
    } catch (_) {
      throw const ChatException('Could not reach the server.');
    }
    _checkError(data);
    if (data is! List) {
      throw const ChatException('Unexpected response from the server.');
    }
    return data
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<RoomData> fetchRoom(int conversationId) async {
    dynamic data;
    try {
      data = await request.get(_url('/conversations/$conversationId/messages/'));
    } catch (_) {
      throw const ChatException('Could not reach the server.');
    }
    _checkError(data);
    if (data is! Map) {
      throw const ChatException('Unexpected response from the server.');
    }
    return RoomData(
      info: ConversationInfo.fromJson(data['conversation'] as Map<String, dynamic>),
      messages: (data['messages'] as List)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Message> sendMessage(
    int conversationId,
    String content, {
    int? replyTo,
  }) async {
    dynamic data;
    try {
      data = await request.postJson(
        _url('/conversations/$conversationId/messages/'),
        jsonEncode({'content': content, if (replyTo != null) 'reply_to': replyTo}),
      );
    } catch (_) {
      throw const ChatException('Could not reach the server.');
    }
    _checkError(data);
    return Message.fromJson(data as Map<String, dynamic>);
  }
}