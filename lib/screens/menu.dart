import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/tumble_card.dart';
import 'state.dart';

enum MenuItem {
  menu,
  highscore,
  about,
  gameover,
}

class Menu extends ConsumerWidget {
  final PageController controller;

  const Menu(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TumbleCard(
      controller,
      children: [
        Container(
          width: 50,
          height: 50,
          child: SpriteAnimationWidget.asset(
            path: 'ember.png',
            data: SpriteAnimationData.sequenced(
              amount: 3,
              stepTime: 0.15,
              textureSize: Vector2.all(16),
            ),
          ),
        ),
        const Text(
          'TumblePuzzle',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(gameNotifierProvider.notifier).setPlaying();
          },
          child: const Text('Play'),
        ),
        ElevatedButton(
          onPressed: () => controller.animateToPage(
            MenuItem.highscore.index,
            curve: Curves.linear,
            duration: const Duration(seconds: 1),
          ),
          child: const Text('Highscore'),
        ),
        ElevatedButton(
          onPressed: () => controller.animateToPage(
            MenuItem.about.index,
            curve: Curves.linear,
            duration: const Duration(seconds: 1),
          ),
          child: const Text('About'),
        ),
      ],
      withBackButton: false,
    );
  }
}
