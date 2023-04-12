import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker_app/src/common_widgets/async_value_widget.dart';
import 'package:weight_tracker_app/src/features/entries/data/hive_entries_repository.dart';
import 'package:weight_tracker_app/src/features/entries/presentation/input_entry/input_entry_widget.dart';

class LogbookScreen extends ConsumerWidget {
  const LogbookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesValue = ref.watch(entriesListStreamProvider);
    return AsyncValueWidget(
      value: entriesValue,
      data: (entries) => entries.isNotEmpty
          ? ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  entries[index].weight.toStringAsFixed(2),
                ),
                subtitle: Text(
                  DateFormat.yMMMEd().format(entries[index].date),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          InputEntryWidget(editedEntry: entries[index]),
                    );
                  },
                ),
              ),
            )
          : const Center(child: Text('*crickets sound effect*')),
    );
  }
}
