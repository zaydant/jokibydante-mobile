class UserResponse {
  String message;
  dynamic data;

  UserResponse({
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return UserResponse(
        message: json['message'],
        data:
            List<UserData>.from(json['data'].map((x) => UserData.fromJson(x))),
      );
    } else if (json['data'] is Map<String, dynamic>) {
      return UserResponse(
        message: json['message'],
        data: UserData.fromJson(json['data']),
      );
    } else {
      throw Exception("Invalid data type for 'data' field in JSON");
    }
  }
}

class UserData {
  final String uid;
  final String fullName;
  final String username;
  final String email;
  final String phoneNumber;
  final String balance;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.balance,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        uid: json['uid'],
        fullName: json['fullName'],
        username: json['username'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        balance: json['balance'],
        role: json['role'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']));
  }
}

class UserModel {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;

  UserModel({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber
  });

  Map<String, dynamic> toJson(){
    return {
      'fullName': fullName,
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': phoneNumber
    };
  }
}
