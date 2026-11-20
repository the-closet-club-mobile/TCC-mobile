import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:the_closet_club_mobile/core/api_config.dart';
import 'package:the_closet_club_mobile/modules/closet/models/clothing.dart';

class ClosetException implements Exception {
  final String message;
  final bool unauthorized;

  const ClosetException(this.message, {this.unauthorized = false});

  @override
  String toString() => message;
}

class ClosetService {
  final CookieRequest request;

  ClosetService(this.request);

  String _url(String path) => '${ApiConfig.baseUrl}/closet/api$path';

  dynamic _checkError(dynamic data) {
    if (data is Map && data.containsKey('detail')) {
      final detail = data['detail'].toString();
      throw ClosetException(
        detail,
        unauthorized: detail.toLowerCase().contains('credentials'),
      );
    }
    return data;
  }

  Future<List<Clothing>> fetchItems() async {
    dynamic data;
    try {
      data = await request.get(_url('/items/'));
    } catch (_) {
      throw const ClosetException('Could not reach the server.');
    }
    _checkError(data);
    if (data is! List) {
      throw const ClosetException('Unexpected response from the server.');
    }
    return data
        .map((e) => Clothing.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
