import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

class MiniSearchActionButtonsRow extends StatefulWidget {
  const MiniSearchActionButtonsRow({super.key});

  @override
  State<MiniSearchActionButtonsRow> createState() =>
      _MiniSearchActionButtonsRowState();
}

class _MiniSearchActionButtonsRowState
    extends State<MiniSearchActionButtonsRow> {
  late bool isOnTop;

  @override
  void initState() {
    isOnTop = false;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await windowManager.isAlwaysOnTop().then((value) {
        setState(() {
          isOnTop = value;
        });
      });
    });
  }

  void _pinWindow() async {
    isOnTop = !(await windowManager.isAlwaysOnTop());
    windowManager.setAlwaysOnTop(isOnTop);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CustomFlatButton(
          text: isOnTop ? 'Открепить' : 'Закрепить',
          onPressed: _pinWindow,
        ),
        const Spacer(),
        _CustomFlatButton(
          text: 'Выйти',
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}

class _CustomFlatButton extends StatelessWidget {
  const _CustomFlatButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 125,
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll(EdgeInsets.only(bottom: 10)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
