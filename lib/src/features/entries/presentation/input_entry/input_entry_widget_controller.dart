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

    // set whole number
    for (var i = 0; i < separatedWeight.length; i++) {
      if (i < decimalPointIndex) {
        wholeNumbersList.add(separatedWeight[i]);
      } else {
        break;
      }
    }
    final wholeNumber = int.parse(wholeNumbersList.join());

    // set first decimal
    final firstDecimal = int.parse(separatedWeight[decimalPointIndex + 1]);

    // set secondDecimal
    final int secondDecimal;
    // after decimal dot length
    // e.g - 85.[3] will return 1 and 85.[34] will return 2
    if (((separatedWeight.length - 1) - decimalPointIndex) > 1) {
      // if lenght of items after decimalDot equals 2 - set secondDecimal to the last element of the separatedWeight
      secondDecimal = int.parse(separatedWeight.last);
    } else {
      // if lenght of items afterDecimalDot equals 1 - set secondDecimal to 0
      secondDecimal = 0;
    }

    return [wholeNumber, firstDecimal, secondDecimal];
  }
}

final inputEntryWidgetControllerProvider =
    Provider<InputEntryWidgetController>((ref) {
  return InputEntryWidgetController(ref);
});
