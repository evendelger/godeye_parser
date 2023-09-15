import 'package:flutter/material.dart';
import 'package:phone_corrector/features/file_search/widgets/widgets.dart';

class FileSearchScreen extends StatelessWidget {
  const FileSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          SideBar(),
          MainPage(),
        ],
      ),
    );
  }
}
