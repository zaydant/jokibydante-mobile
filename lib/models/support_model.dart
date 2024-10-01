class SupportResponse {
  String message;
  dynamic data;

  SupportResponse({
    required this.message,
    required this.data,
  });

  factory SupportResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return SupportResponse(
        message: json['message'],
        data:
            List<SupportData>.from(json['data'].map((x) => SupportData.fromJson(x))),
      );
    } else if (json['data'] is Map<String, dynamic>) {
      return SupportResponse(
        message: json['message'],
        data: SupportData.fromJson(json['data']),
      );
    } else {
      throw Exception("Invalid data type for 'data' field in JSON");
    }
  }
}

class SupportData {
  final String supportId;
  final String name;
  final String email;
  final String phoneNumber;
  final String transactionId;
  final String issue;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupportData({
    required this.supportId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.transactionId,
    required this.issue,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportData.fromJson(Map<String, dynamic> json) {
    return SupportData(
        supportId: json['supportId'],
        name: json['name'],
        email: json['email'],
        phoneNumber: json['phoneNumber'],
        transactionId: json['transactionId'],
        issue: json['issue'],
        description: json['description'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']));
  }
}

class SupportModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String transactionId;
  final String issue;
  final String description;

  SupportModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.transactionId,
    required this.issue,
    required this.description
  });

  Map<String, dynamic> toJson(){
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'transactionId': transactionId,
      'issue': issue,
      'description': description
    };
  }
}

