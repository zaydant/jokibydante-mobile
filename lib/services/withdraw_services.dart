import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jokiapp/models/withdraw_model.dart';

class WithdrawService {
  final String url =
      "https://api-dante-joki-871423140998.asia-southeast2.run.app/api";

  Future<Map<String, dynamic>> submitRequest(String token, double amount, String method,
      String number, String name, String? note) async {
    final uri = Uri.parse('$url/withdraw');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
        body: jsonEncode({
          "withdrawAmount": amount,
          "withdrawMethod": method,
          "accountNumber": number,
          "accountName": name,
          "notes": note ?? 'No Notes'
        }),
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

  Future<List<WithdrawModel>> getRequestByOwner (String token, String uid) async {
  final uri = Uri.parse('$url/withdraw?uid=$uid');

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
      final List<dynamic> withdrawsJson = data['data'];

      return withdrawsJson.map((json) => WithdrawModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load requests');
    }
  } catch (e) {
    print('Error loading users: $e');
    throw Exception('Error loading requests: $e');
  }
}

Future<List<WithdrawModel>> getWithdraws (String token) async {
  final uri = Uri.parse('$url/withdraw');

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
      final List<dynamic> withdrawsJson = data['data'];

      return withdrawsJson.map((json) => WithdrawModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load withdraws');
    }
  } catch (e) {
    print('Error loading users: $e');
    throw Exception('Error loading users: $e');
  }
}

Future<void> updateWithdrawStatus(
      String token, String withdrawId) async {
    final uri = Uri.parse('$url/withdraw/$withdrawId');

    try {
      final response = await http.put(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // print('Job taken successfully');
        final Map<String, dynamic> responseData = json.decode(response.body)['data'];
        print(responseData);
      } else {
        print('Failed to update status: ${response.statusCode}');
        throw Exception('Failed to update status');
      }
    } catch (e) {
      print('Error to update status: $e');
      throw Exception('Error to update status: $e');
    }
  }
}
