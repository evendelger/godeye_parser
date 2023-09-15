import 'package:flutter/material.dart';
import 'package:phone_corrector/features/file_search/widgets/sidebar_icon.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      color: const Color(0xFF364091),
      child: const Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideBarIcon(title: 'Поиск по файлу', icon: Icons.file_open),
            SizedBox(height: 15),
            SideBarIcon(title: 'Поиск по тексту', icon: Icons.abc),
          ],
        ),
      ),
    );
  }
}
