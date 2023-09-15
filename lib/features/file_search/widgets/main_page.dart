import 'package:flutter/material.dart';
import 'package:phone_corrector/features/file_search/widgets/widgets.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 50,
                  itemBuilder: (BuildContext context, int index) {
                    return ListItem(index: index);
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Icon(
              Icons.add_box,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
