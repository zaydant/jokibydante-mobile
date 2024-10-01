import 'package:flutter/material.dart';
import 'package:jokiapp/models/withdraw_model.dart';
import 'package:intl/intl.dart';

class ReqRow extends StatelessWidget {
  final WithdrawModel withdrawData;
  final VoidCallback onCheck;

  const ReqRow({
    Key? key,
    required this.withdrawData,
    required this.onCheck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    Icon(
                      Icons.wallet
                    )
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${withdrawData.accountName}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('yyyy-MM-dd').format(withdrawData.createdAt)
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(withdrawData.status),
                const SizedBox(height: 10),
                Text(
                  'Rp. ${withdrawData.withdrawAmount}',
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
