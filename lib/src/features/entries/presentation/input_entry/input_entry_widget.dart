import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker_app/src/features/entries/data/hive_entries_repository.dart';
import 'package:weight_tracker_app/src/features/entries/domain/entry.dart';
import 'package:weight_tracker_app/src/features/entries/presentation/input_entry/input_entry_widget_controller.dart';
import 'package:weight_tracker_app/src/features/entries/presentation/input_entry/wheel_value_picker.dart';

class InputEntryWidget extends ConsumerStatefulWidget {
  const InputEntryWidget({
    super.key,
    this.editedEntry,
  });

  final Entry? editedEntry;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InputEntryWidgetState();
}

class _InputEntryWidgetState extends ConsumerState<InputEntryWidget> {
  late DateTime pickedDate;

  late bool isEdited;

  late final FixedExtentScrollController wholeNumberController;
  late ListWheelChildLoopingListDelegate wholeNumberDelegate;

  late final FixedExtentScrollController firstDecimalController;
  late ListWheelChildLoopingListDelegate firstDecimalDelegate;

  late final FixedExtentScrollController secondDecimalController;
  late ListWheelChildLoopingListDelegate secondDecimalDelegate;

  ListWheelChildLoopingListDelegate _createDelegate(int numberOfItems) {
    return ListWheelChildLoopingListDelegate(
      children: [
        for (var i = 0; i < numberOfItems; i++)
          Center(
            child: Text(
              '$i',
              style: const TextStyle(fontSize: 24),
            ),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    isEdited = widget.editedEntry != null;

    wholeNumberDelegate = _createDelegate(300);
    firstDecimalDelegate = _createDelegate(10);
    secondDecimalDelegate = _createDelegate(10);

    if (widget.editedEntry != null) {
      // entry is edited
      pickedDate = widget.editedEntry!.date;

      final separatedWeight = ref
          .read(inputEntryWidgetControllerProvider)
          .separateNumber(widget.editedEntry!.weight);

      wholeNumberController =
          FixedExtentScrollController(initialItem: separatedWeight[0]);
      firstDecimalController =
          FixedExtentScrollController(initialItem: separatedWeight[1]);
      secondDecimalController =
          FixedExtentScrollController(initialItem: separatedWeight[2]);
    } else {
      // entry is not edited
      pickedDate = DateTime.now();
      // set the wheelpicker value to the latest entry weight val
      final lastEntry = ref.read(entriesListStreamProvider).value?.first;
      if (lastEntry != null) {
        final separatedWeight = ref
            .read(inputEntryWidgetControllerProvider)
            .separateNumber(lastEntry.weight);

        wholeNumberController =
            FixedExtentScrollController(initialItem: separatedWeight[0]);
        firstDecimalController =
            FixedExtentScrollController(initialItem: separatedWeight[1]);
        secondDecimalController =
            FixedExtentScrollController(initialItem: separatedWeight[2]);
      } else {
        wholeNumberController = FixedExtentScrollController();
        firstDecimalController = FixedExtentScrollController();
        secondDecimalController = FixedExtentScrollController();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    wholeNumberController.dispose();
    firstDecimalController.dispose();
    secondDecimalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEdited ? 'Edit weight entry' : 'Add weight entry',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WheelValuePicker(
              controller: wholeNumberController,
              delegate: wholeNumberDelegate,
            ),
            const Text(
              '.',
              style: TextStyle(fontSize: 24),
            ),
            WheelValuePicker(
              controller: firstDecimalController,
              delegate: firstDecimalDelegate,
            ),
            WheelValuePicker(
              controller: secondDecimalController,
              delegate: secondDecimalDelegate,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () async {
                final result = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );

                if (result != null) {
                  setState(() {
                    pickedDate = result;
                  });
                }
              },
              child: Text(
                DateFormat.yMMMEd().format(pickedDate),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final wholeNumber = wholeNumberDelegate
                    .trueIndexOf(wholeNumberController.selectedItem);
                final firstDecimal = firstDecimalDelegate
                    .trueIndexOf(firstDecimalController.selectedItem);
                final secondDecimal = secondDecimalDelegate
                    .trueIndexOf(secondDecimalController.selectedItem);
                final weight =
                    double.parse('$wholeNumber.$firstDecimal$secondDecimal');

                ref.read(inputEntryWidgetControllerProvider).submitEntry(
                      editedEntry: widget.editedEntry,
                      weight: weight,
                      date: pickedDate,
                      onSuccess: () => Navigator.of(context).pop(),
                    );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ],
    );
  }
}
