import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jokiapp/models/user_model.dart';

class UserService {
  final String url = "https://api-dante-joki-871423140998.asia-southeast2.run.app/api";
    
  Future<List<UserData>> getUsers (String token) async {
  final uri = Uri.parse('$url/user');

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
      final List<dynamic> usersJson = data['data'];

      return usersJson.map((json) => UserData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  } catch (e) {
    print('Error loading users: $e');
    throw Exception('Error loading users: $e');
  }
}
Future<UserData?> getUserById(String uid, String token) async {
    final uri = Uri.parse('$url/user/$uid');
    final response = await http.get(uri, headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body)['data'];
      return UserData.fromJson(responseData);
    } else {
      print('Error fetching transaction: ${response.body}');
      return null;
    }
  }
}