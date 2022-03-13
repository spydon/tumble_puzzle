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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: state.cinematic
            ? []
            : [
                InkWell(
                  child: FloatingActionButton.extended(
                    icon: const Icon(Icons.sports_baseball_outlined),
                    backgroundColor: Colors.red.shade600,
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
                InkWell(
                  child: FloatingActionButton.extended(
                    icon: const Icon(Icons.free_breakfast_outlined),
                    backgroundColor: Colors.red.shade600,
                    label: const Text('Switch gravity'),
                    isExtended: state.hovers['switch-gravity'] ?? false,
                    onPressed: () {
                      final gravity = state.game.world.gravity;
                      gravity.y = gravity.isZero() ? -10 : 0;
                    },
                  ),
                  onTap: () {},
                  onHover: (isHovering) {
                    ref.read(gameNotifierProvider.notifier).setHover(
                          'switch-gravity',
                          isHovering,
                        );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: FloatingActionButton.extended(
                    icon: const Icon(Icons.arrow_back_rounded),
                    backgroundColor: Colors.red.shade600,
                    label: const Text('Back to menu'),
                    isExtended: state.hovers['menu'] ?? false,
                    onPressed: () {
                      ref.read(gameNotifierProvider.notifier).setPlay(false);
                    },
                  ),
                  onTap: () {},
                  onHover: (isHovering) {
                    ref.read(gameNotifierProvider.notifier).setHover(
                          'menu',
                          isHovering,
                        );
                  },
                ),
              ],
      ),
    );
  }
}
