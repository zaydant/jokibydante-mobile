import 'package:flutter/material.dart';
import 'package:jokiapp/models/user_model.dart';

class UserRow extends StatelessWidget {
  final UserData user;
  final VoidCallback onCheck;

  const UserRow({
    Key? key,
    required this.user,
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
                    Image.asset(
                      'assets/images/profile.png',
                      height: 50,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.fullName}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(user.uid),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Text(user.role),
                const SizedBox(height: 10),
                Text(
                  'Rp. ${user.balance}',
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
