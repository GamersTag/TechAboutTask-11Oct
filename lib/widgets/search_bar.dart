// lib/widgets/search_bar.dart //useless

import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const CustomSearchBar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          labelText: 'Search products...',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
