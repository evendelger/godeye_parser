import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_corrector/domain/models/models.dart';
import 'package:phone_corrector/features/file_search/bloc/files_bloc.dart';
import 'package:phone_corrector/features/file_search/widgets/widgets.dart';

const duration = Duration(milliseconds: 1000);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final _animatedListKey;
  late final ScrollController _scrollController;

  void _addToList(int count) {
    final bloc = context.read<FilesBloc>();

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
    context.read<SearchingDataList>().addItems(count);
  }

  void _clearList() {
    _animatedListKey.currentState!
        .removeAllItems((context, animation) => const SizedBox.shrink());

    context.read<FilesBloc>().add(const ClearList());
    context.read<SearchingDataList>().clearList();
    Future.microtask(
      () => {
        for (int i = 0; i < context.read<FilesBloc>().state.models.length; i++)
          {
            _animatedListKey.currentState!.insertItem(
              i,
              duration: duration,
            )
          }
      },
    );
  }

  @override
  void initState() {
    _animatedListKey = GlobalKey<AnimatedListState>();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 15, right: 15, bottom: 10),
              child: AnimatedList(
                controller: _scrollController,
                key: _animatedListKey,
                initialItemCount:
                    context.read<SearchingDataList>().listOfControllers.length,
                itemBuilder: (context, index, animation) {
                  return AnimatedListItem(
                    index: index,
                    animation: animation,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                _addIcon(count: 1),
                const SizedBox(width: 30),
                _addIcon(count: 10),
                const Spacer(),
                _resetIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FilledButton _resetIcon() {
    return FilledButton(
      onPressed: () => _clearList(),
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(EdgeInsets.all(15)),
      ),
      child: const Icon(Icons.restart_alt, size: 30),
    );
  }

  FilledButton _addIcon({required int count}) {
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
  });

  final Animation<double> animation;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ListItem(index: index),
    );
  }
}
