
class TransactionResponse {
  String message;
  dynamic data;

  TransactionResponse({
    required this.message,
    required this.data,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      return TransactionResponse(
        message: json['message'],
        data: List<TransactionData>.from(json['data'].map((x) => TransactionData.fromJson(x))),
      );
    } else if (json['data'] is Map<String, dynamic>) {
      return TransactionResponse(
        message: json['message'],
        data: TransactionData.fromJson(json['data']),
      );
    } else {
      throw Exception("Invalid data type for 'data' field in JSON");
    }
  }
}

class TransactionData{
  final String transactionId;
  String? owner;
  final String email;
  final String password;
  final String loginMethod;
  final String reqHero;
  final String notes;
  final String contactNumber;
  final String rank;
  final String price;
  final int quantity;
  final String paymentMethod;
  final bool paymentStatus;
  final String jokiStatus;

  TransactionData ({
    required this.transactionId,
    this.owner,
    required this.email,
    required this.password,
    required this.loginMethod,
    required this.reqHero,
    required this.notes,
    required this.contactNumber,
    required this.rank,
    required this.price,
    required this.quantity,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.jokiStatus
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      transactionId: json['transactionId'], 
      owner: json['owner'], 
      email: json['email'], 
      password: json['password'], 
      loginMethod: json['loginMethod'], 
      reqHero: json['reqHero'], 
      notes: json['notes'], 
      contactNumber: json['contactNumber'], 
      rank: json['rank'], 
      price: json['price'], 
      quantity: json['quantity'], 
      paymentMethod: json['paymentMethod'], 
      paymentStatus: json['paymentStatus'], 
      jokiStatus: json['jokiStatus']
      );
  }
}