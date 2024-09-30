import 'package:flutter/material.dart';
import 'package:jokiapp/models/transaction_model.dart';
import 'package:jokiapp/models/user_provider.dart';
import 'package:provider/provider.dart';

class TransactionRow extends StatelessWidget {
  final TransactionData transaction;
  final VoidCallback onCheck;

  const TransactionRow({
    Key? key,
    required this.transaction,
    required this.onCheck,
  }) : super(key: key);

  // Function to get image path based on transaction rank
  String _getRankImage(String rank) {
    switch (rank) {
      case 'Master':
        return 'assets/images/master.png';
      case 'Grandmaster':
        return 'assets/images/gm.png';
      case 'Epic':
        return 'assets/images/epic.png';
      case 'Legend':
        return 'assets/images/legend.png';
      case 'Mythic':
      case 'Grading': // Mythic and Grading share the same image
        return 'assets/images/mythic.png';
      case 'Honor':
        return 'assets/images/honor.png';
      case 'Glory':
        return 'assets/images/glory.png';
      case 'Immortal':
        return 'assets/images/immo.png';
      default:
        return 'assets/images/default.png'; // Fallback image
    }
  }

  String _getStatus(String jokiStatus, bool paymentStatus) {
    if (jokiStatus == 'actionNeeded' && paymentStatus == false) {
      return 'Not Paid';
    }

    switch (jokiStatus) {
      case 'actionNeeded':
        return 'Available';
      case 'onProgress':
        return 'In Progress';
      case 'finished':
        return 'Completed';
      default:
        return 'No Status';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return GestureDetector(
      onTap: onCheck,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Color(0x33000000),
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    // Use the _getRankImage function to get the correct image based on rank
                    Image.asset(
                      _getRankImage(transaction.rank),
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${transaction.rank} x${transaction.quantity}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(userProvider.role == 'admin'
                        ? transaction.transactionId
                        : transaction.reqHero),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(_getStatus(
                    transaction.jokiStatus, transaction.paymentStatus)),
                const SizedBox(height: 10),
                Text(
                  'Rp. ${transaction.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
