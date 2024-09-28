import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jokiapp/models/support_model.dart';

class SupportService {
  final String url = "https://api-dante-joki-871423140998.asia-southeast2.run.app/api";

  Future<Map<String, dynamic>> saveSupportRequest(SupportModel supportItem) async {
    final uri = Uri.parse('$url/support');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(supportItem.toJson()),
      );

      return {
        'success': response.statusCode == 201,
        'statusCode': response.statusCode,
        'body': response.body,
      };
    } catch (e) {
      print('Error submitting support request: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}