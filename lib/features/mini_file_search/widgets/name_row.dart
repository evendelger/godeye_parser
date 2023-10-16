import 'dart:math';

import 'package:flutter/material.dart';
import 'package:godeye_parser/features/mini_file_search/widgets/widgets.dart';
import 'package:godeye_parser/ui/widgets/widgets.dart';

class NameRow extends StatelessWidget {
  const NameRow({
    super.key,
    required this.size,
    required this.controllers,
  });

  final List<TextEditingController> controllers;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            searchingDataType: SearchingDataType.mini,
            width: null,
            controller: controllers[0],
            hintText: 'Введите ФИО',
            parseType: ParseType.name,
            maxLines: 1,
            fontSize: min(size.width / 22, 23),
            height: size.height / 10 > 60 ? 60 : size.height / 10,
          ),
        ),
        const SizedBox(width: 5),
        ResetButton(controllers: controllers),
      ],
    );
  }
}
