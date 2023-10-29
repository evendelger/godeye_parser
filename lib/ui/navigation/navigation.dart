import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:godeye_parser/data/data.dart';
import 'package:godeye_parser/features/error/error.dart';
import 'package:godeye_parser/features/full_file_search/full_file_search.dart';
import 'package:godeye_parser/features/mini_file_search/mini_file_search.dart';
import 'package:godeye_parser/features/mini_search_menu/mini_search_menu.dart';
import 'package:godeye_parser/features/mini_text_search/mini_text_search.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: "initialRoute",
      path: "/",
      builder: (context, state) => const SizedBox(),
      redirect: (context, state) {
        final isFullSearch = const ScreenSizeService().isFullSize();
        if (isFullSearch) {
          return "/fullSearch";
        }
        return "/miniSearchMenu";
      },
    ),
    GoRoute(
      name: "fullSearch",
      path: "/fullSearch",
      builder: (context, state) => const FullFileSearchScreen(),
    ),
    GoRoute(
      name: "miniSearchMenu",
      path: "/miniSearchMenu",
      builder: (context, state) => const MiniSearchMenuScreen(),
      routes: [
        GoRoute(
          name: "miniFileSearch",
          path: "miniFileSearch",
          builder: (context, state) => const MiniFileSeacrhScreen(),
        ),
        GoRoute(
          name: "miniTextSearch",
          path: "miniTextSearch",
          builder: (context, state) => const MiniTextSearchScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
