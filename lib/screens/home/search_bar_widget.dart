import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchPressed;

  const SearchBarWidget({super.key, required this.controller, required this.onSearchPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter a city name (e.g. Pune)',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearchPressed(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: onSearchPressed,
          ),
        ],
      ),
    );
  }
}
