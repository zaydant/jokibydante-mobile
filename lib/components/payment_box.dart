import 'package:flutter/material.dart';

class PaymentBox extends StatelessWidget {
  final String method;
  final String price; // Original price as a string
  final String assetImagePath; // Path to the image asset
  final bool isSelected; // Indicates if the box is selected
  final VoidCallback onTap; // Callback for when the box is tapped

  const PaymentBox({
    Key? key,
    required this.method,
    required this.price,
    required this.assetImagePath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Notify parent when the box is tapped
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Duration for animation
        curve: Curves.easeInOut, // Smooth animation curve
        transform: isSelected
            ? (Matrix4.identity()..scale(1.00)) // Slight scale up on selection
            : Matrix4.identity(), // Normal scale when not selected
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: isSelected
                  ? const Color.fromRGBO(43, 52, 153, 1) // Shadow color on selection
                  : const Color(0x33000000), // Default shadow color
              offset: const Offset(0, 0),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Column: Texts (Title and Image)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Image.asset(
                  assetImagePath,
                  width: 100,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            // Right Column: Price
            Text(
              price,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
