import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:the_closet_club_mobile/core/api_config.dart';
import 'package:the_closet_club_mobile/modules/feed/models/outfit_post.dart';

class FeedException implements Exception {
  final String message;
  final bool unauthorized;

  const FeedException(this.message, {this.unauthorized = false});

  @override
  String toString() => message;
}

class FeedService {
  final CookieRequest request;

  FeedService(this.request);

  String _url(String path) => '${ApiConfig.baseUrl}/api/feed$path';

  dynamic _checkError(dynamic data) {
    if (data is Map && data.containsKey('detail')) {
      final detail = data['detail'].toString();
      throw FeedException(
        detail,
        unauthorized: detail.toLowerCase().contains('credentials'),
      );
    }
    return data;
  }

  Future<PostPage> fetchPosts({String q = '', String sort = 'new', int page = 1}) async {
    final uri = Uri.parse(_url('/posts/')).replace(queryParameters: {
      if (q.isNotEmpty) 'q': q,
      'sort': sort,
      'page': '$page',
    });
    dynamic data;
    try {
      data = await request.get(uri.toString());
    } catch (_) {
      throw const FeedException('Could not reach the server.');
    }
    _checkError(data);
    if (data is! Map) {
      throw const FeedException('Unexpected response from the server.');
    }
    return PostPage(
      posts: (data['results'] as List)
          .map((e) => OutfitPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: data['has_next'] as bool? ?? false,
      page: data['page'] as int? ?? page,
    );
  }

  Future<OutfitPost> fetchPost(int id) async {
    dynamic data;
    try {
      data = await request.get(_url('/posts/$id/'));
    } catch (_) {
      throw const FeedException('Could not reach the server.');
    }
    _checkError(data);
    return OutfitPost.fromJson(data as Map<String, dynamic>);
  }

  /// Returns the new like state: {liked, like_count}.
  Future<({bool liked, int likeCount})> toggleLike(int id) async {
    dynamic data;
    try {
      data = await request.postJson(_url('/posts/$id/like/'), jsonEncode({}));
    } catch (_) {
      throw const FeedException('Could not reach the server.');
    }
    _checkError(data);
    return (
      liked: data['liked'] as bool,
      likeCount: data['like_count'] as int,
    );
  }
}