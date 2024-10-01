import 'dart:convert';
import 'dart:io';
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

  Future<List<SupportData>> getSupports (String token) async {
  final uri = Uri.parse('$url/support');

  try {
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> supportsJson = data['data'];

      return supportsJson.map((json) => SupportData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  } catch (e) {
    print('Error loading users: $e');
    throw Exception('Error loading users: $e');
  }
}

Future<bool> deleteUser(String token, String id) async {
    final uri = Uri.parse('$url/support/$id');
    final response = await http.delete(uri, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}