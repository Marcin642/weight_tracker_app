import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weight_tracker_app/src/common_widgets/async_value_widget.dart';
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
  bool isInitialized = false;

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

  void _initializeControllers({
    List<int>? separatedWeight,
  }) {
    wholeNumberController = FixedExtentScrollController(
        initialItem: separatedWeight?.elementAt(0) ?? 0);
    firstDecimalController = FixedExtentScrollController(
        initialItem: separatedWeight?.elementAt(1) ?? 0);
    secondDecimalController = FixedExtentScrollController(
        initialItem: separatedWeight?.elementAt(2) ?? 0);
  }

  // Function used to initialize important parameters such as:
  // picked date and number controllers.
  void _initialize(List<Entry> entriesList) {
    if (isEdited) {
      pickedDate = widget.editedEntry!.date;
      // *entry is edited*
      // pickedDate = widget.editedEntry!.date;
      final separatedWeight = ref
          .read(inputEntryWidgetControllerProvider)
          .separateNumber(widget.editedEntry!.weight);

      _initializeControllers(separatedWeight: separatedWeight);
    } else {
      pickedDate = DateTime.now();
      // *entry is not edited*
      if (entriesList.isNotEmpty) {
        // wheel value picker should be initialized with previous values
        final separatedWeight = ref
            .read(inputEntryWidgetControllerProvider)
            .separateNumber(entriesList.first.weight);

        _initializeControllers(separatedWeight: separatedWeight);
      } else {
        // wheel value picker should be initialized with default values - 0, 0, 0
        _initializeControllers();
      }
    }

    // with this variable set to true, this function will be called only once during this widgets lifetime
    isInitialized = true;
  }

  @override
  void initState() {
    super.initState();

    isEdited = widget.editedEntry != null;

    wholeNumberDelegate = _createDelegate(300);
    firstDecimalDelegate = _createDelegate(10);
    secondDecimalDelegate = _createDelegate(10);
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
    final entriesValue = ref.watch(entriesListFutureProvider);
    return AsyncValueWidget(
      value: entriesValue,
      data: (entriesList) {
        // Since, I'm populating wheel value pickers with data from my repository
        // this function cannot be executed in initState
        if (!isInitialized) _initialize(entriesList);
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
                    final weight = double.parse(
                        '$wholeNumber.$firstDecimal$secondDecimal');

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
      },
    );
  }
}
