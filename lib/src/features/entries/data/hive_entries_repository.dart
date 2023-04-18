import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weight_tracker_app/src/features/entries/domain/entry.dart';

class HiveEntriesRepository {
  HiveEntriesRepository(this.box);
  final Box box;

  static Future<Box> createDatabase(String boxName) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDir.path);
    return await Hive.openBox(boxName);
  }

  static Future<HiveEntriesRepository> makeDefault() async {
    return HiveEntriesRepository(
      await createDatabase('entries'),
    );
  }

  // set entry
  Future<void> setEntry(Entry entry) async {
    await box.put(entry.id, jsonEncode(entry.toJson()));
  }

  // remove entry by id
  Future<void> removeEntryById(String entryId) async {
    await box.delete(entryId);
  }

  // retrieve entries
  List<Entry> _getEntriesList() {
    final entries = box.values
        .map((entryData) => Entry.fromJson(jsonDecode(entryData)))
        .toList();

    entries.sort(
      (a, b) => b.date.compareTo(a.date),
    );

    return entries.isNotEmpty ? entries : [];
  }

  // fetch
  Future<List<Entry>> fetchEntriesList() async {
    // await Future.delayed(const Duration(seconds: 2));
    return _getEntriesList();
  }

  // watch
  Stream<List<Entry>> watchEntriesList() {
    return box
        .watch()
        .map((_) => _getEntriesList())
        .startWith(_getEntriesList());
  }
}

final entriesRepositoryProvider = Provider<HiveEntriesRepository>((ref) {
  throw UnimplementedError();
});

final entriesListFutureProvider =
    FutureProvider.autoDispose<List<Entry>>((ref) async {
  final entriesRepository = ref.watch(entriesRepositoryProvider);
  return entriesRepository.fetchEntriesList();
});

final entriesListStreamProvider =
    StreamProvider.autoDispose<List<Entry>>((ref) {
  final entriesRepository = ref.watch(entriesRepositoryProvider);
  return entriesRepository.watchEntriesList();
});
