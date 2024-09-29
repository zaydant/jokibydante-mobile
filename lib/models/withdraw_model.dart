class WithdrawResponse {
  String message;
  dynamic data;

  WithdrawResponse({
    required this.message,
    required this.data,
  });

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return WithdrawResponse(
        message: json['message'],
        data:
            List<WithdrawModel>.from(json['data'].map((x) => WithdrawModel.fromJson(x))),
      );
    } else if (json['data'] is Map<String, dynamic>) {
      return WithdrawResponse(
        message: json['message'],
        data: WithdrawModel.fromJson(json['data']),
      );
    } else {
      throw Exception("Invalid data type for 'data' field in JSON");
    }
  }
}

class WithdrawModel {
  final String withdrawId;
  final String uid;
  final String withdrawAmount;
  final String withdrawMethod;
  final String accountNumber;
  final String accountName;
  final String notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  WithdrawModel(
      {
        required this.withdrawId,
        required this.uid,
      required this.withdrawAmount,
      required this.withdrawMethod,
      required this.accountNumber,
      required this.accountName,
      required this.notes,
      required this.status,
      required this.createdAt,
    required this.updatedAt,
      });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) {
    return WithdrawModel(
        withdrawId: json['withdrawId'],
        uid: json['uid'],
        withdrawAmount: json['withdrawAmount'],
        withdrawMethod: json['withdrawMethod'],
        accountNumber: json['accountNumber'],
        accountName: json['accountName'],
        notes: json['notes'],
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}