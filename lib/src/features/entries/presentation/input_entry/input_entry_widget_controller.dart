import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:weight_tracker_app/src/features/entries/data/hive_entries_repository.dart';
import 'package:weight_tracker_app/src/features/entries/domain/entry.dart';

// For this use case state notifier is obsolete
// hence, this class only serves separation of concerns purposes
class InputEntryWidgetController {
  InputEntryWidgetController(this.ref);
  final Ref ref;

  Future<void> submitEntry({
    Entry? editedEntry,
    required final double weight,
    required final DateTime date,
    required void Function() onSuccess,
  }) async {
    final Entry entry;
    if (editedEntry != null) {
      entry = Entry(
        id: editedEntry.id,
        weight: weight,
        date: date,
      );
    } else {
      entry = Entry(
        id: const Uuid().v1(),
        weight: weight,
        date: date,
      );
    }
    await ref.read(entriesRepositoryProvider).setEntry(entry);
    onSuccess();
  }

  List<int> separateNumber(double weight) {
    final separatedWeight = weight.toString().split('');
    final decimalPointIndex = separatedWeight.indexWhere((e) => e == '.');

    final wholeNumbersList = [];
    final firstDecimal = int.parse(separatedWeight[decimalPointIndex + 1]);
    final secondDecimal = int.parse(separatedWeight.last);

    for (var i = 0; i < separatedWeight.length; i++) {
      if (i < decimalPointIndex) {
        wholeNumbersList.add(separatedWeight[i]);
      } else {
        break;
      }
    }

    final wholeNumber = int.parse(wholeNumbersList.join());

    return [wholeNumber, firstDecimal, secondDecimal];
  }
}

final inputEntryWidgetControllerProvider =
    Provider<InputEntryWidgetController>((ref) {
  return InputEntryWidgetController(ref);
});
