import 'package:flutter/material.dart';
import 'package:phone_corrector/domain/provider_models/provider_models.dart';
import 'package:phone_corrector/features/file_search/bloc/files_bloc.dart';
import 'package:phone_corrector/features/file_search/widgets/widgets.dart';
import 'package:provider/provider.dart';

class FileSearchScreen extends StatelessWidget {
  const FileSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideBar(),
          MultiProvider(
            providers: [
              Provider<FilesBloc>(
                create: (_) => FilesBloc(),
                lazy: false,
              ),
              Provider<SearchingDataList>(
                create: (_) => SearchingDataList.init(),
                lazy: false,
              ),
            ],
            child: const MainPage(),
          ),
        ],
      ),
    );
  }
}
