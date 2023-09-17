import 'package:flutter/material.dart';
import 'package:phone_corrector/features/file_search/widgets/widgets.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: SingleChildScrollView(
                child: _ListViewBuilder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_box,
              size: 50,
              color: Color(0xFF364091),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleOfList extends StatelessWidget {
  const _TitleOfList({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleMedium;
    // TODO: доработать внешний вид
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('№', style: textStyle),
          const SizedBox(width: 190),
          Text('ФИО', style: textStyle),
          const SizedBox(width: 230),
          Text('Поиск по региону', style: textStyle),
          const SizedBox(width: 80),
          Text('Поиск по городу', style: textStyle),
          const SizedBox(width: 27),
          Text('Поиск по стажу', style: textStyle),
          const SizedBox(width: 33),
          Text('Статус', style: textStyle),
        ],
      ),
    );
  }
}

class _ListViewBuilder extends StatelessWidget {
  const _ListViewBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        //if (index == 0) return const _TitleOfList();
        return ListItem(index: index);
      },
    );
  }
}
