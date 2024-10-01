
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
  String? proof;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.jokiStatus,
    this.proof,
    required this.createdAt,
    required this.updatedAt,
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
      jokiStatus: json['jokiStatus'],
      proof: json['proof'],
      createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt'])
      );
  }
}

class TransactionModel {
  final String email;
  final String password;
  final String loginMethod;
  final String reqHero;
  final String notes;
  final String contactNumber;
  final String rank;
  final double price;
  final int quantity;
  final String paymentMethod;
  final bool paymentStatus;
  final String jokiStatus;
  final String? transactionId; // Nullable field for transaction ID
  final String? proof;
  final String? createdAt; // Nullable field for creation time
  final String? updatedAt; // Nullable field for update time

  TransactionModel({
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
    required this.jokiStatus,
    this.transactionId, // Optional field for the transaction ID
    this.proof,
    this.createdAt, // Optional field for creation time
    this.updatedAt, // Optional field for update time
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'loginMethod': loginMethod,
      'reqHero': reqHero,
      'notes': notes,
      'contactNumber': contactNumber,
      'rank': rank,
      'price': price,
      'quantity': quantity,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'jokiStatus': jokiStatus,
    };
  }

  // Convert JSON response to object
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      email: json['email'],
      password: json['password'],
      loginMethod: json['loginMethod'],
      reqHero: json['reqHero'],
      notes: json['notes'],
      contactNumber: json['contactNumber'],
      rank: json['rank'],
      price: double.parse(json['price']),
      quantity: json['quantity'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      jokiStatus: json['jokiStatus'],
      transactionId: json['transactionId'],
      proof: json['proof'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
