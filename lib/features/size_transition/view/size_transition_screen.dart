import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:phone_corrector/domain/data/data.dart';
import 'package:phone_corrector/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SizeTransitionScreen extends StatelessWidget {
  const SizeTransitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSize =
        getIt<SharedPreferences>().getString(StorageKeys.appSizeKey);
    switch (currentSize) {
      case null:
      case ('full'):
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushNamed('/full_size');
        });
      case ('mini'):
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/mini_size', (route) => false);
        });
    }
    return const Scaffold(
      body: Center(
        child: Text('Загрузка...'),
      ),
    );
  }
}
