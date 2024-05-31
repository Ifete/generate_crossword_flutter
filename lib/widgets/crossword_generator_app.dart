import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'crossword_info_widget.dart';
import 'crossword_widget.dart';

class CrosswordGeneratorApp extends StatelessWidget {
  const CrosswordGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _EagerInitialization(
      child: Scaffold(
        appBar: AppBar(
          actions: [_CrosswordGeneratorMenu()], // Add this line
          titleTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          title: Text('Crossword Generator'),
        ),
        body: SafeArea(
          child: Consumer(
            // Modify from here
            builder: (context, ref, child) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: CrosswordWidget(),
                  ),
                  if (ref.watch(showDisplayInfoProvider)) CrosswordInfoWidget(),
                ],
              );
            },
          ), // To here.
        ),
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wordListProvider);
    return child;
  }
}

class _CrosswordGeneratorMenu extends ConsumerWidget {
  // Add from here
  @override
  Widget build(BuildContext context, WidgetRef ref) => MenuAnchor(
        menuChildren: [
          for (final entry in CrosswordSize.values)
            MenuItemButton(
              onPressed: () => ref.read(sizeProvider.notifier).setSize(entry),
              leadingIcon: entry == ref.watch(sizeProvider)
                  ? Icon(Icons.radio_button_checked_outlined)
                  : Icon(Icons.radio_button_unchecked_outlined),
              child: Text(entry.label),
            ),
          for (final count in BackgroundWorkers.values) // Add from here
            MenuItemButton(
              leadingIcon: count == ref.watch(workerCountProvider)
                  ? Icon(Icons.radio_button_checked_outlined)
                  : Icon(Icons.radio_button_unchecked_outlined),
              onPressed: () =>
                  ref.read(workerCountProvider.notifier).setCount(count),
              child: Text(count.label), // To here.
            ),
        ],
        builder: (context, controller, child) => IconButton(
          onPressed: () => controller.open(),
          icon: Icon(Icons.settings),
        ),
      ); // To here.
}
