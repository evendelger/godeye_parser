import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/features/mini_file_search/bloc/mini_search_bloc.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({
    super.key,
    required this.controllers,
  });

  final List<TextEditingController> controllers;

  void _clearData(BuildContext context) {
    context.read<MiniSearchBloc>().add(const ClearData());
    for (var c in controllers) {
      c.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton.filled(
        padding: EdgeInsets.zero,
        iconSize: 20,
        onPressed: () => _clearData(context),
        icon: const Icon(Icons.restart_alt),
      ),
    );
  }
}
