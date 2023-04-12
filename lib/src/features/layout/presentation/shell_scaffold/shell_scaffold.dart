import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weight_tracker_app/src/features/entries/presentation/input_entry/input_entry_widget.dart';

class ShellScaffold extends StatefulWidget {
  const ShellScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<ShellScaffold> {
  final _tabs = [
    CustomBottomNavigationBarItem(
      icon: const Icon(Icons.home),
      label: 'Home',
      path: '/',
    ),
    CustomBottomNavigationBarItem(
      icon: const Icon(Icons.history),
      label: 'Logbook',
      path: '/logbook',
    ),
  ];

  // current index
  int get _currentIndex => _locationToTabIndex(GoRouter.of(context).location);

  // location to tab index
  int _locationToTabIndex(String location) {
    final index = _tabs.indexWhere((tab) => tab.path.startsWith(location));

    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabs[_currentIndex].label ?? ''),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: _tabs,
        currentIndex: _currentIndex,
        onTap: (index) {
          context.go(_tabs[index].path);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const InputEntryWidget(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomBottomNavigationBarItem extends BottomNavigationBarItem {
  CustomBottomNavigationBarItem({
    required super.icon,
    required super.label,
    required this.path,
  });
  final String path;
}
