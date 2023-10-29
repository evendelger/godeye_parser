import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Functions {
  static Future<void> pasteData(TextEditingController controller) async {
    final cdata = await Clipboard.getData(Clipboard.kTextPlain);
    if (cdata != null) controller.text = cdata.text ?? controller.text;
  }
}
