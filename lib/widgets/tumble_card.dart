import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/home.dart';

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
                menuItems['menu']!,
                duration: const Duration(seconds: 1),
                curve: Curves.linear,
              ),
              child: const Text('Back'),
            ),
          ]..insertAll(0, this.children))
        : this.children;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 400),
        child: Card(
          color: Colors.grey.shade200.withOpacity(0.8),
          elevation: 5,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              spacing: 10,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
