import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/state.dart';
import 'loading_widget.dart';

class PuzzleWidget extends ConsumerWidget {
  const PuzzleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameNotifierProvider);
    return Scaffold(
      body: GameWidget(
        key: Key('game: ${state.cinematic} ${state.celebration}'),
        game: state.game,
        loadingBuilder: (_) => LoadingWidget(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: state.cinematic
            ? []
            : [
                InkWell(
                  child: FloatingActionButton.extended(
                    icon: const Icon(Icons.sports_baseball_outlined),
                    hoverColor: Colors.redAccent,
                    label: const Text('Add a ball'),
                    isExtended: state.hovers['add-ball'] ?? false,
                    onPressed: state.game.addBall,
                  ),
                  onTap: () {},
                  onHover: (isHovering) {
                    ref.read(gameNotifierProvider.notifier).setHover(
                          'add-ball',
                          isHovering,
                        );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.free_breakfast_outlined),
                  hoverColor: Colors.redAccent,
                  tooltip: 'Switch gravity',
                  onPressed: () {
                    final gravity = state.game.world.gravity;
                    gravity.y = gravity.isZero() ? -10 : 0;
                  },
                  heroTag: null,
                ),
                const SizedBox(
                  height: 10,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.restore_outlined),
                  hoverColor: Colors.redAccent,
                  tooltip: 'Restart',
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
