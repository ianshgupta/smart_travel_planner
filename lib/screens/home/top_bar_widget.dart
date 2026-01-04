import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onFavoritesPressed;

  const TopBar({super.key, required this.onFavoritesPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onFavoritesPressed,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.favorite_rounded, color: Colors.red, size: 24),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
            height: 45,
            width: 45,
            child: Image.asset(
              'assets/profile.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
