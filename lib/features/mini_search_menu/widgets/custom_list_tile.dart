import 'package:flutter/material.dart';
import 'package:godeye_parser/ui/theme/theme.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.titleText,
    required this.icon,
    required this.onTap,
    required this.dividerOnBotom,
  });

  final String titleText;
  final IconData icon;
  final VoidCallback onTap;
  final bool dividerOnBotom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const borderSide = BorderSide(
      color: Colors.white,
      width: 2,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: dividerOnBotom ? BorderSide.none : borderSide,
          bottom: dividerOnBotom ? borderSide : BorderSide.none,
        ),
      ),
      child: ListTile(
        hoverColor: ColorsList.hoverColor,
        iconColor: ColorsList.hoverColor,
        leading: Icon(icon),
        title: Text(
          titleText,
          style: theme.textTheme.labelLarge,
        ),
        onTap: onTap,
      ),
    );
  }
}
