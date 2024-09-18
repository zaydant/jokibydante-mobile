import 'package:flutter/material.dart';
import 'package:jokiapp/theme.dart';

class ServiceBox extends StatelessWidget {
  final String title;
  final double originalPrice; // Original price as a double
  final double discount; // Discount as a percentage (e.g., 20 for 20%)
  final String assetImagePath; // Path to the image asset
  final Function(double currentPrice) onTap; // Callback for onTap

  const ServiceBox({
    Key? key,
    required this.title,
    required this.originalPrice,
    required this.discount,
    required this.assetImagePath,
    required this.onTap, // Pass the callback function
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the current price based on the discount and original price
    double currentPrice = originalPrice - (originalPrice * (discount / 100));

    return GestureDetector(
      onTap: () => onTap(currentPrice), // Call the onTap callback when clicked
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 10,
                  color: Color(0x33000000),
                  offset: Offset(0, 0),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Column: Texts (Title, Current Price, and Original Price)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Rp ${currentPrice.toStringAsFixed(0)}', // Convert double to string and remove decimals
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Rp ${originalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),

                // Right Column: Image
                Image.asset(
                  assetImagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          // Discount Ribbon
          Positioned(
            top: 0,
            right: 0,
            child: ClipPath(
              clipper: RibbonClipper(),
              child: Container(
                color: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  '${discount.toStringAsFixed(0)}% OFF', // Display the discount percentage
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom ClipPath to create the ribbon-like shape
class RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 10, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 10, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
