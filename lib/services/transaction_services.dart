import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jokiapp/models/transaction_model.dart';

class TransactionService {
  final String url =
      "https://api-dante-joki-871423140998.asia-southeast2.run.app/api";

  Future<TransactionModel?> createTransaction(TransactionModel transactionModel) async {
    final uri = Uri.parse('$url/joki');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(transactionModel.toJson()),
    );

    if (response.statusCode == 201) {
      // Parse the response body
      final Map<String, dynamic> responseData = json.decode(response.body)['data'];
      
      // Return the transaction model with the new data
      return TransactionModel.fromJson(responseData);
    } else {
      print('Error: ${response.body}');
      return null;
    }
  }

  Future<TransactionModel?> getTransactionById(String transactionId) async {
    final uri = Uri.parse('$url/joki/$transactionId');
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body)['data'];
      return TransactionModel.fromJson(responseData);
    } else {
      print('Error fetching transaction: ${response.body}');
      return null;
    }
  }

  Future<List<TransactionData>> getTransactions() async {
    final uri = Uri.parse('$url/joki');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> usersJson = data['data'];

      return usersJson.map((json) => TransactionData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
  Future<List<TransactionData>> getOwnedJobs (String token) async {
  final uri = Uri.parse('$url/joki/jokiStatus/owned');

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

      return usersJson.map((json) => TransactionData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  } catch (e) {
    print('Error loading owned jobs: $e');
    throw Exception('Error loading owned jobs: $e');
  }
}

  Future<void> takeJob(
      String token, String transactionId, String jokiStatus) async {
    final uri = Uri.parse('$url/joki/$transactionId');

    try {
      final response = await http.put(
        uri,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'jokiStatus': jokiStatus,
        }),
      );

      if (response.statusCode == 200) {
        // print('Job taken successfully');
        print(response);
      } else {
        print('Failed to take job: ${response.statusCode}');
        throw Exception('Failed to take job');
      }
    } catch (e) {
      print('Error take job: $e');
      throw Exception('Error take job: $e');
    }
  }
}
