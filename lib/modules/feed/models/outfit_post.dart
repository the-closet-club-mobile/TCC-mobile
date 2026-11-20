class PostAuthor {
  final int id;
  final String username;
  final bool isVerified;
  final String? avatar;

  const PostAuthor({
    required this.id,
    required this.username,
    required this.isVerified,
    this.avatar,
  });

  factory PostAuthor.fromJson(Map<String, dynamic> json) => PostAuthor(
        id: json['id'] as int,
        username: json['username'] as String,
        isVerified: json['is_verified'] as bool? ?? false,
        avatar: json['avatar'] as String?,
      );
}

class TaggedClothing {
  final int id;
  final String name;
  final String? photo;
  final String sizeLabel;
  final String conditionLabel;
  final String statusLabel;

  const TaggedClothing({
    required this.id,
    required this.name,
    this.photo,
    required this.sizeLabel,
    required this.conditionLabel,
    required this.statusLabel,
  });

  factory TaggedClothing.fromJson(Map<String, dynamic> json) => TaggedClothing(
        id: json['id'] as int,
        name: json['name'] as String,
        photo: json['photo'] as String?,
        sizeLabel: json['size_label'] as String? ?? '',
        conditionLabel: json['condition_label'] as String? ?? '',
        statusLabel: json['status_label'] as String? ?? '',
      );
}

class OutfitPost {
  final int id;
  final PostAuthor author;
  final String? image;
  final String caption;
  final List<TaggedClothing> clothes;
  final int likeCount;
  final bool liked;
  final bool isAuthor;
  final DateTime createdAt;

  const OutfitPost({
    required this.id,
    required this.author,
    this.image,
    required this.caption,
    required this.clothes,
    required this.likeCount,
    required this.liked,
    required this.isAuthor,
    required this.createdAt,
  });

  OutfitPost copyWith({int? likeCount, bool? liked}) => OutfitPost(
        id: id,
        author: author,
        image: image,
        caption: caption,
        clothes: clothes,
        likeCount: likeCount ?? this.likeCount,
        liked: liked ?? this.liked,
        isAuthor: isAuthor,
        createdAt: createdAt,
      );

  factory OutfitPost.fromJson(Map<String, dynamic> json) => OutfitPost(
        id: json['id'] as int,
        author: PostAuthor.fromJson(json['author'] as Map<String, dynamic>),
        image: json['image'] as String?,
        caption: json['caption'] as String? ?? '',
        clothes: (json['clothes'] as List? ?? [])
            .map((e) => TaggedClothing.fromJson(e as Map<String, dynamic>))
            .toList(),
        likeCount: json['like_count'] as int? ?? 0,
        liked: json['liked'] as bool? ?? false,
        isAuthor: json['is_author'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}

class PostPage {
  final List<OutfitPost> posts;
  final bool hasNext;
  final int page;

  const PostPage({required this.posts, required this.hasNext, required this.page});
}