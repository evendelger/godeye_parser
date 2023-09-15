import 'package:flutter/material.dart';

class SideBarIcon extends StatelessWidget {
  const SideBarIcon({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 28, 26, 56)),
            iconColor: MaterialStateProperty.all(Colors.white),
          ),
          icon: Icon(
            icon,
            size: 55,
          ),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
