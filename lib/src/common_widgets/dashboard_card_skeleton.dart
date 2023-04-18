import 'package:flutter/material.dart';

/// Skeleton, which is meant to be used as a base of any Dashboard Widget
class DashboardCardSkeleton extends StatelessWidget {
  const DashboardCardSkeleton({
    super.key,
    required this.title,
    required this.color,
    required this.content,
    this.headerContent,
  });

  final String title;
  final Color color;
  final Widget content;
  final Widget? headerContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(255, 43, 45, 58),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 64,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          // Header - title and header content (settings)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Header content - e.g settings button or range picker
                Container(
                  child: headerContent,
                )
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
            child: content,
          ),
        ],
      ),
    );
  }
}
