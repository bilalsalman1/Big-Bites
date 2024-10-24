import 'package:flutter/material.dart';

class Categorycard extends StatelessWidget {
  const Categorycard({super.key, required this.image, required this.title});

  final Image image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 100,
          width: 80,
          child: Card(
            color: const Color(0xff0b1225),
            child: Center(child: image),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
