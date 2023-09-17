import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      color: const Color(0xFF364091),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _SideBarIcon(
                  title: 'Поиск по файлу',
                  icon: Icons.file_open,
                ),
                SizedBox(height: 15),
                _SideBarIcon(
                  title: 'Поиск по тексту',
                  icon: Icons.abc,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SideBarIcon extends StatelessWidget {
  const _SideBarIcon({super.key, required this.title, required this.icon});

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
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}