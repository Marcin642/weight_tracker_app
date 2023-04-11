import 'package:flutter/material.dart';

class WheelValuePicker extends StatelessWidget {
  const WheelValuePicker({
    super.key,
    required this.controller,
    required this.delegate,
  });

  final FixedExtentScrollController controller;
  final ListWheelChildLoopingListDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SizedBox(
        height: 150,
        width: 50,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(),
                    ),
                  ),
                ),
              ),
            ),
            ListWheelScrollView.useDelegate(
              controller: controller,
              childDelegate: delegate,
              itemExtent: 50,
              overAndUnderCenterOpacity: 0.5,
              physics: const FixedExtentScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }
}
