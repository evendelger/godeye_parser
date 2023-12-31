import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:godeye_parser/domain/domain.dart';
import 'package:godeye_parser/features/full_file_search/full_file_search.dart';
import 'package:godeye_parser/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

const duration = Duration(milliseconds: 1000);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final GlobalKey<AnimatedListState> _animatedListKey;
  late final ScrollController _scrollController;
  late List<FileSearchData> fileList;

  @override
  void initState() {
    _animatedListKey = GlobalKey<AnimatedListState>();
    _scrollController = ScrollController();
    super.initState();
  }

  Future<int> _getInitialCount() async {
    fileList = await DatabaseHelper.instance.selectFileList();
    return fileList.length;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addToList(int count) {
    final bloc = context.read<FullSearchBloc>();
    bloc.add(AddItems(count: count));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 100 * count,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.fastOutSlowIn,
    );
    _animatedListKey.currentState!.insertAllItems(
      bloc.state.models.length,
      count,
      duration: duration,
    );
    DatabaseHelper.instance.insertItemsToList(count);
  }

  void _clearList() {
    _animatedListKey.currentState!
        .removeAllItems((context, animation) => const SizedBox.shrink());

    context.read<FullSearchBloc>().add(const ClearList());
    DatabaseHelper.instance.fillDatabases(false);
    fileList = List.generate(5, (_) => FileSearchData.empty());
    Future.microtask(
      () => {
        for (int i = 0;
            i < context.read<FullSearchBloc>().state.models.length;
            i++)
          {
            _animatedListKey.currentState!.insertItem(
              i,
              duration: duration,
            )
          }
      },
    );
  }

  Future<void> _setDirectory() async {
    final selectedDirectory = await FilePicker.platform
        .getDirectoryPath(dialogTitle: 'Выберите папку загрузки Telegram');
    if (selectedDirectory != null) {
      final prefs = getIt<SharedPreferences>();
      await prefs.setString(StorageKeys.filesFolderKey, selectedDirectory);
      getIt<DataProvider>().changePath(selectedDirectory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FutureBuilder<int>(
              future: _getInitialCount(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  context
                      .read<FullSearchBloc>()
                      .add(SetupState(length: snapshot.data!));

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30, left: 5, right: 5, bottom: 10),
                      child: AnimatedList(
                        controller: _scrollController,
                        key: _animatedListKey,
                        initialItemCount: snapshot.data!,
                        itemBuilder: (context, index, animation) {
                          return AnimatedListItem(
                            index: index,
                            animation: animation,
                            fileSearchData: index < fileList.length
                                ? fileList[index]
                                : FileSearchData.empty(),
                          );
                        },
                      ),
                    ),
                  );
                }
                return const Expanded(child: Text('Загрузка данных...'));
              }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                _filledButton(Icons.folder_open, _setDirectory),
                const Spacer(),
                _addButton(count: 1),
                const SizedBox(width: 30),
                _addButton(count: 10),
                const Spacer(),
                _filledButton(Icons.restart_alt, _clearList),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FilledButton _filledButton(IconData icon, VoidCallback onPressed) {
    return FilledButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
      ),
      child: Icon(icon, size: 30),
    );
  }

  FilledButton _addButton({required int count}) {
    return FilledButton.icon(
      onPressed: () => _addToList(count),
      icon: const Icon(Icons.add, size: 30),
      label: Text(
        count == 10 ? '10' : '1 ',
        style: const TextStyle(fontSize: 30),
      ),
    );
  }
}

class AnimatedListItem extends StatelessWidget {
  const AnimatedListItem({
    super.key,
    required this.animation,
    required this.index,
    required this.fileSearchData,
  });

  final Animation<double> animation;
  final int index;
  final FileSearchData fileSearchData;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ListItem(
        index: index,
        fileSearchData: fileSearchData,
      ),
    );
  }
}
