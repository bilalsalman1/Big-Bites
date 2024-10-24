import 'package:flutter/material.dart';

class ProfileList extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onpressed;
  const ProfileList(
      {super.key,
      required this.icon,
      required this.title,
      required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: ListTile(
        leading: Container(
          height: 47,
          width: 47,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
