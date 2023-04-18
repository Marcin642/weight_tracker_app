import 'package:flutter/material.dart';
import 'package:weight_tracker_app/src/common_widgets/dashboard_card_skeleton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: DashboardCardSkeleton(
          title: 'Statistics',
          color: Colors.blue,
          content: Text(
            'Hello world',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
