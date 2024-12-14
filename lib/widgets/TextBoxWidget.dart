import 'package:flutter/material.dart';

class TextBoxWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const TextBoxWidget({
    super.key,
    required this.labelText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Add spacing around the text box
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Add internal padding
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey[700], // Subtle label color
            fontSize: 14,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor), // Highlight color when focused
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
