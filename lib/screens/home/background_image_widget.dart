import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/destinations/destination_2.png',
        fit: BoxFit.fitHeight,
        errorBuilder: (_, __, ___) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade100, const Color(0xFFF8F8F8)],
            ),
          ),
        ),
      ),
    );
  }
}
