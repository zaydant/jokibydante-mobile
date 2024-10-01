import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final bool readOnly;
  final String? Function(String?)? validator; // Add validator parameter

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.readOnly,
    this.validator, // Add validator to the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Container(
        height: 50,
        child: TextFormField( // Changed from TextField to TextFormField
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: Color.fromRGBO(131, 162, 255, 0.3)),
              borderRadius: BorderRadius.circular(15),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'JosefinSans',
              color: Color.fromRGBO(43, 52, 153, 1),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: const Color.fromRGBO(43, 52, 153, 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          readOnly: readOnly,
          validator: validator, // Pass the validator to TextFormField
        ),
      ),
    );
  }
}
