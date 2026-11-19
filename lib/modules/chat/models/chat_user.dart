class ChatUser {
  final int id;
  final String username;
  final bool isVerified;
  final String? avatar;

  const ChatUser({
    required this.id,
    required this.username,
    required this.isVerified,
    this.avatar,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] as int,
      username: json['username'] as String,
      isVerified: json['is_verified'] as bool? ?? false,
      avatar: json['avatar'] as String?,
    );
  }
}