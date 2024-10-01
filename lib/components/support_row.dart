import 'package:flutter/material.dart';
import 'package:jokiapp/models/support_model.dart';
import 'package:intl/intl.dart';

class SupportRow extends StatelessWidget {
  final SupportData supportData;
  final VoidCallback onCheck;

  const SupportRow({
    Key? key,
    required this.supportData,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${supportData.issue}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${supportData.transactionId}', style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                    ),
                  ],
                ),
            Column(
              children: [
                const Text(' '),
                const SizedBox(height: 10),
                Text(
                  DateFormat('yyyy-MM-dd').format(supportData.createdAt),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
