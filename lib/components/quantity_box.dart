import 'package:flutter/material.dart';

class QuantityBox extends StatefulWidget {
  final int minValue; // The minimum value allowed (e.g., 3)
  final int initialValue; // The initial/default value (e.g., 3)
  final Function(int) onQuantityChanged; // Callback to notify the parent of quantity changes

  const QuantityBox({
    Key? key,
    this.minValue = 3, // Default minimum value is 3
    this.initialValue = 3, // Default initial value is 3
    required this.onQuantityChanged, // Required callback function
  }) : super(key: key);

  @override
  _QuantityBoxState createState() => _QuantityBoxState();
}

class _QuantityBoxState extends State<QuantityBox> {
  late int _quantity; // Internal state to hold the current quantity

  @override
  void initState() {
    super.initState();
    // Initialize the quantity with the provided initial value
    _quantity = widget.initialValue;
  }

  // Method to increase quantity
  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
    widget.onQuantityChanged(_quantity); // Notify parent of the change
  }

  // Method to decrease quantity but not lower than the minimum value
  void _decreaseQuantity() {
    if (_quantity > widget.minValue) {
      setState(() {
        _quantity--;
      });
      widget.onQuantityChanged(_quantity); // Notify parent of the change
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Minus Button
          IconButton(
            icon: const Icon(Icons.remove, size: 20),
            onPressed: _decreaseQuantity, // Decrease quantity when pressed
          ),
          // Display the current quantity value
          Text(
            _quantity.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          // Plus Button
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            onPressed: _increaseQuantity, // Increase quantity when pressed
          ),
        ],
      ),
    );
  }
}
