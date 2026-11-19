import 'chat_user.dart';

/// One row in the conversation list.
class Conversation {
  final int id;
  final ChatUser other;
  final int? itemId;
  final String itemName;
  final bool accepted;
  final String preview;
  final DateTime lastTime;
  final int unread;

  const Conversation({
    required this.id,
    required this.other,
    required this.itemId,
    required this.itemName,
    required this.accepted,
    required this.preview,
    required this.lastTime,
    required this.unread,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as int,
      other: ChatUser.fromJson(json['other'] as Map<String, dynamic>),
      itemId: json['item_id'] as int?,
      itemName: json['item_name'] as String? ?? '',
      accepted: json['accepted'] as bool? ?? true,
      preview: json['preview'] as String? ?? '',
      lastTime: DateTime.parse(json['last_time'] as String),
      unread: json['unread'] as int? ?? 0,
    );
  }
}

/// Header information returned together with the messages of a room.
class ConversationInfo {
  final int id;
  final String otherUsername;
  final String itemName;
  final bool accepted;
  final bool blockedByMe;
  final bool blockedMe;

  const ConversationInfo({
    required this.id,
    required this.otherUsername,
    required this.itemName,
    required this.accepted,
    required this.blockedByMe,
    required this.blockedMe,
  });

  factory ConversationInfo.fromJson(Map<String, dynamic> json) {
    return ConversationInfo(
      id: json['id'] as int,
      otherUsername: json['other_username'] as String,
      itemName: json['item_name'] as String? ?? '',
      accepted: json['accepted'] as bool? ?? true,
      blockedByMe: json['blocked_by_me'] as bool? ?? false,
      blockedMe: json['blocked_me'] as bool? ?? false,
    );
  }
}