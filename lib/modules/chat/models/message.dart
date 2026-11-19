import 'chat_user.dart';

class ReplyPreview {
  final int id;
  final String sender;
  final String preview;

  const ReplyPreview({
    required this.id,
    required this.sender,
    required this.preview,
  });

  factory ReplyPreview.fromJson(Map<String, dynamic> json) {
    return ReplyPreview(
      id: json['id'] as int,
      sender: json['sender'] as String,
      preview: json['preview'] as String? ?? '',
    );
  }
}

class Message {
  final int id;
  final ChatUser sender;
  final String type; // text, location, image, file, swap
  final String content;
  final String placeName;
  final String address;
  final double? latitude;
  final double? longitude;
  final bool isEdited;
  final bool isRead;
  final DateTime createdAt;
  final String attachmentName;
  final String? attachmentUrl;
  final ReplyPreview? replyTo;
  final int? swapRequestId;

  const Message({
    required this.id,
    required this.sender,
    required this.type,
    required this.content,
    required this.placeName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isEdited,
    required this.isRead,
    required this.createdAt,
    required this.attachmentName,
    required this.attachmentUrl,
    required this.replyTo,
    required this.swapRequestId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    final reply = json['reply_to'];
    return Message(
      id: json['id'] as int,
      sender: ChatUser.fromJson(json['sender'] as Map<String, dynamic>),
      type: json['message_type'] as String? ?? 'text',
      content: json['content'] as String? ?? '',
      placeName: json['place_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isEdited: json['is_edited'] as bool? ?? false,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      attachmentName: json['attachment_name'] as String? ?? '',
      attachmentUrl: json['attachment_url'] as String?,
      replyTo: reply is Map<String, dynamic> ? ReplyPreview.fromJson(reply) : null,
      swapRequestId: json['swap_request'] as int?,
    );
  }
}