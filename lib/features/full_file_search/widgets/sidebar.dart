import 'package:flutter/material.dart';
import 'package:godeye_parser/ui/theme/theme.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      color: ColorsList.primary,
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
                  index: 0,
                ),
                SizedBox(height: 15),
                _SideBarIcon(
                  title: 'Поиск по тексту',
                  icon: Icons.abc,
                  index: 1,
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
  const _SideBarIcon({
    required this.title,
    required this.icon,
    required this.index,
  });

  final String title;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(ColorsList.darkPrimary),
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
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
