import 'package:flutter/material.dart';

List<String> items = [
  'BCA',
  'GOPAY',
];

class WithdrawCategories extends StatefulWidget {
  final Function(String?) onCategoryChanged;

  const WithdrawCategories({Key? key, required this.onCategoryChanged})
      : super(key: key);

  @override
  State<WithdrawCategories> createState() => _WithdrawCategoriesState();
}

class _WithdrawCategoriesState extends State<WithdrawCategories> {
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        alignment: Alignment.topCenter,
        height: 50,
        // color: Colors.amber,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<String>(
          style: const TextStyle(
              color: Color.fromRGBO(43, 52, 153, 1),
              fontWeight: FontWeight.w500),
          padding: const EdgeInsets.only(left: 10),
          borderRadius: BorderRadius.circular(15),
          iconSize: 30,
          hint: const Text("Choose Withdraw Method", style: TextStyle(
            fontFamily: 'JosefinSans',
            color: Color.fromRGBO(43, 52, 153, 1),
            fontWeight: FontWeight.bold
          ),),
          value: selectedItem,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16, fontFamily: 'JosefinSans', fontWeight: FontWeight.bold),
                    ),
                  ))
              .toList(),
          onChanged: (item) {
            setState(() {
            selectedItem = item;
            });
            widget.onCategoryChanged(item); 
          } 
        ),
      ),
    );
  }
}