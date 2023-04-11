import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_tracker_app/src/features/entries/data/hive_entries_repository.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final entriesRepository = await HiveEntriesRepository.makeDefault();
  final container = ProviderContainer(overrides: [
    entriesRepositoryProvider.overrideWithValue(entriesRepository)
  ]);

  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}
