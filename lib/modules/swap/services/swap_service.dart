import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/swap_request.dart';

class SwapService {
  final String baseUrl;

  SwapService({required this.baseUrl});

  Future<List<SwapRequest>> getSwapRequests(
    String type, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl/swap/api/requests/$type/');

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((item) => SwapRequest.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load $type swap requests: ${response.statusCode}',
    );
  }
}
