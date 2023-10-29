import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FolderAlertDialog extends StatelessWidget {
  const FolderAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Внимание',
        style: theme.textTheme.headlineSmall,
      ),
      content: const Text(
        'Пожалуйста, выберите папку, где хранятся файлы с Telegram(иконка снизу слева)',
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
