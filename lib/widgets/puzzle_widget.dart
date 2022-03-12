import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/tumble_puzzle_game.dart';
import '../screens/state.dart';
import 'loading_widget.dart';

class PuzzleWidget extends ConsumerWidget {
  const PuzzleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    late TumblePuzzleGame game;
    print('building');
    //final game = TumblePuzzleGame(
    //    isCinematic: isCinematic,
    //    isCelebration: isCelebration,
    //    onFinish: onFinish,
    //    onLoaded: () {
    //      ref.read(gameNotifierProvider.notifier).setLoaded();
    //    });
    return Scaffold(
      body: GameWidget(
        key: Key('game: ${state.cinematic} ${state.celebration}'),
        game: game = TumblePuzzleGame(
          isCinematic: state.cinematic,
          isCelebration: state.celebration,
          onFinish: (score) {
            ref.read(gameNotifierProvider.notifier).setGameOver(score);
          },
          onLoaded: () {
            ref.read(gameNotifierProvider.notifier).setLoaded();
          },
        ),
        loadingBuilder: (_) => LoadingWidget(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: state.cinematic
            ? []
            : [
                FloatingActionButton(
                  child: const Icon(Icons.sports_baseball_outlined),
                  onPressed: game.addBall,
                  heroTag: null,
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.free_breakfast_outlined),
                  onPressed: () {
                    final gravity = game.world.gravity;
                    gravity.y = gravity.isZero() ? -10 : 0;
                  },
                  heroTag: null,
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.restore_outlined),
                  onPressed: () {
                    ref.read(gameNotifierProvider.notifier).setPlaying();
                  },
                  heroTag: null,
                )
              ],
      ),
    );
  }
}
