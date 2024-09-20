import 'dart:convert';

import 'package:jokiapp/models/loginModel.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String url = "https://api-dante-joki-871423140998.asia-southeast2.run.app/api";

  //login
  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    var uriLog = Uri.parse("$url/auth/login");
    final response = await http.post(
      uriLog,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginRequestModel.toJson()),
    );
    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else if (response.statusCode == 401) {
      return LoginResponseModel(
          error: 'Unauthorized: Please check your credentials');
    } else if (response.statusCode == 400) {
      return LoginResponseModel(error: 'Please Input your credential');
    } else {
      print('Failed to fetch data: ${response.statusCode}');
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}