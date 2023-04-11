import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_tracker_app/src/common_widgets/async_value_widget.dart';
import 'package:weight_tracker_app/src/features/entries/data/hive_entries_repository.dart';
import 'package:weight_tracker_app/src/features/entries/presentation/input_entry/input_entry_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final entriesValue = ref.watch(entriesListStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weight tracker app',
        ),
      ),
      body: AsyncValueWidget(
        value: entriesValue,
        data: (entries) => ListView.builder(
          itemCount: entries.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(
              entries[index].weight.toStringAsFixed(2),
            ),
            subtitle: Text(
              entries[index].date.toString(),
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
        ),
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
