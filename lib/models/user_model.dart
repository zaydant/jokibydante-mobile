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

  UserData(
      {required this.uid,
      required this.fullName,
      required this.username,
      required this.email,
      required this.phoneNumber,
      required this.balance,
      required this.role});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        uid: json['uid'],
        fullName: json['fullName'],
        username: json['username'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        balance: json['balance'],
        role: json['role']);
  }
}
