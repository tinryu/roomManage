import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;

  const SearchInput({super.key, this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      constraints: const BoxConstraints(maxHeight: 64),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true, // Add this
          hintText: hintText ?? 'Search...',
          hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0, // Adjust this
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }
}
