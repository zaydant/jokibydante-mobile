import 'package:flutter/material.dart';

class SearchBarComponent extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged; // Callback for search input changes
  final String hintText;

  const SearchBarComponent({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color.fromRGBO(131, 162, 255, 0.3)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: const Color.fromRGBO(43, 52, 153, 1),),
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: onChanged,
                ),
              );
  }
}