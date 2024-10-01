import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jokiapp/models/user_model.dart';

class UserService {
  final String url =
      "https://api-dante-joki-871423140998.asia-southeast2.run.app/api";

  Future<List<UserData>> getUsers(String token) async {
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
      final Map<String, dynamic> responseData =
          json.decode(response.body)['data'];
      return UserData.fromJson(responseData);
    } else {
      print('Error fetching transaction: ${response.body}');
      return null;
    }
  }

  Future<bool> deleteUser(String token, String id) async {
    final uri = Uri.parse('$url/user/$id');
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

  Future<Map<String, dynamic>> createUser(UserModel user) async {
    final uri = Uri.parse('$url/auth/register');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(user.toJson()),
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

  Future<void> updateUser(String token, String? password,
      String? newPassword, String? phoneNumber) async {
    final uri = Uri.parse('$url/user');

    try {
      final response = await http.put(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'newPassword': newPassword ?? '',
          'oldPassword': password ?? '',
          'phoneNumber': phoneNumber ?? ''
        }),
      );

      if (response.statusCode == 200) {
        // print('Job taken successfully');
        final Map<String, dynamic> responseData =
            json.decode(response.body)['data'];
        print(responseData);
      } else {
        print('Failed to take job: ${response.statusCode}');
        throw Exception('Failed to take job');
      }
    } catch (e) {
      print(uri);
      print('Error take job: $e');
      throw Exception('Error take job: $e');
    }
  }
  
}
