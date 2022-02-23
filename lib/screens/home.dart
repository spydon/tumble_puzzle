import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/tumble_puzzle_game.dart';
import 'about.dart';
import 'highscore.dart';
import 'menu.dart';
import 'state.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    final controller = PageController(initialPage: state.menuItem.index);
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: TumblePuzzleGame(
              isCinematic: state.cinematic,
              isCelebration: state.celebration,
              onFinish: () {
                ref.read(gameNotifierProvider.notifier).setGameOver();
              },
            ),
          ),
          if (state.cinematic)
            PageView(
              controller: controller,
              children: <Widget>[
                Menu(controller),
                Highscore(controller),
                About(controller),
                Highscore(controller),
              ],
            )
        ],
      ),
    );
  }
}
