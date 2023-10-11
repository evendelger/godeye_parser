import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:provider/provider.dart';

enum SearchingDataType {
  full,
  mini,
}

enum ParseType {
  name,
  city,
  experience,
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.searchingDataType,
    required this.width,
    required this.controller,
    required this.hintText,
    required this.parseType,
    required this.height,
    this.index,
    required this.fontSize,
    required this.maxLines,
  });

  final SearchingDataType searchingDataType;
  final double? width;
  final double? height;
  final String hintText;
  final TextEditingController controller;
  final ParseType parseType;
  final int? index;
  final double fontSize;
  final int? maxLines;

  Future<void> _getAndFormatText(BuildContext context) async {
    final cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata == null || cdata.text == null) return;

    switch (parseType) {
      case ParseType.name:
        {
          final text = cdata.text!.trim();
          controller.text = text;

          if (context.mounted) {
            _saveControllerValue(context, text);
          }
        }
      case ParseType.city:
        {
          final trimmedText = cdata.text!.trim();
          final indexOfSpace = trimmedText.lastIndexOf(' ');
          final text = indexOfSpace != -1
              ? trimmedText.substring(0, indexOfSpace)
              : trimmedText;
          controller.text = text;

          if (context.mounted) {
            _saveControllerValue(context, text);
          }
        }
      case ParseType.experience:
        {
          final parsedText = StringBuffer();
          for (int i = 0; i < cdata.text!.length; i++) {
            final symbol = cdata.text![i];
            if (int.tryParse(symbol) != null) {
              parsedText.write(symbol);
            }
          }
          controller.text = parsedText.toString().isNotEmpty
              ? parsedText.toString()
              : controller.text;

          if (context.mounted) {
            _saveControllerValue(context, parsedText.toString());
          }
        }
    }
  }

  void _saveControllerValue(BuildContext context, String value) {
    final controllersModel = searchingDataType == SearchingDataType.full
        ? context.read<FullSearchingData>().controllers[index!]
        : context.read<MiniSearchingData>().controllers;

    switch (parseType) {
      case ParseType.name:
        {
          controllersModel.nameControllerText = controller.text;
        }
      case ParseType.city:
        {
          controllersModel.cityControllerText = controller.text;
        }
      case ParseType.experience:
        {
          final parsedValue = int.tryParse(controller.text);
          if (parsedValue != null) {
            controllersModel.experienceControllerText = controller.text;
          }
        }
    }
    //print(controllersModel);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        expands: maxLines == null ? true : false,
        maxLines: maxLines,
        onChanged: (value) => _saveControllerValue(context, value),
        style: TextStyle(
          letterSpacing: 0.01,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
          isDense: true,
          suffixIcon: CupertinoButton(
            onPressed: () => _getAndFormatText(context),
            padding: EdgeInsets.zero,
            child: const Icon(Icons.paste, size: 20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFF364091),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
