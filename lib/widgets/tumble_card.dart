import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/menu.dart';

class TumbleCard extends ConsumerWidget {
  final List<Widget> children;
  final bool withBackButton;
  final PageController controller;

  const TumbleCard(
    this.controller, {
    Key? key,
    this.children = const [],
    this.withBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Maybe refactor this?
    final children = withBackButton
        ? (<Widget>[
            ElevatedButton(
              onPressed: () => controller.animateToPage(
                MenuItem.menu.index,
                duration: const Duration(seconds: 1),
                curve: Curves.linear,
              ),
              child: const Text('Back'),
            ),
          ]..insertAll(0, this.children))
        : this.children;

    return Center(
      child: Wrap(
        children: [
          Card(
            color: Colors.grey.shade200.withOpacity(0.8),
            elevation: 5,
            margin: const EdgeInsets.all(20),
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
