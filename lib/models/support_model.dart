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