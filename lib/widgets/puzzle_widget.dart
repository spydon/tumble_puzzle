import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/tumble_puzzle_game.dart';

class PuzzleWidget extends ConsumerWidget {
  final bool isCinematic;
  final bool isCelebration;
  final Function()? onFinish;

  const PuzzleWidget({
    this.isCinematic = false,
    this.isCelebration = false,
    this.onFinish,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = TumblePuzzleGame(
      isCinematic: isCinematic,
      isCelebration: isCelebration,
      onFinish: onFinish,
    );
    return Scaffold(
      body: GameWidget(game: game),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: isCinematic
            ? []
            : [
                FloatingActionButton(
                  child: const Icon(Icons.free_breakfast_outlined),
                  onPressed: () {
                    final gravity = game.world.gravity;
                    gravity.y = gravity.isZero() ? -9.8 : 0;
                  },
                  heroTag: null,
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.restore_outlined),
                  onPressed: () => {},
                  heroTag: null,
                )
              ],
      ),
    );
  }
}
