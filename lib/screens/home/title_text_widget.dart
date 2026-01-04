import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Discover your next\nadventure',
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        height: 1.3,
        color: Colors.black87,
      ),
    );
  }
}
