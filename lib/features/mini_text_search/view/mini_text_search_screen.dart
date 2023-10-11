import 'package:flutter/material.dart';

class MiniTextSearchScreen extends StatelessWidget {
  const MiniTextSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Text('Text search'),
    );
  }
}
