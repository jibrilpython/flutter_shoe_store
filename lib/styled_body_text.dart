import 'package:flutter/material.dart';

class StyledBodyText extends StatelessWidget {
  const StyledBodyText(this.text, {super.key});

  final String text ;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        height: 1.5,
      ),
    );
  }
}