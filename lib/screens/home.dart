import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/puzzle_widget.dart';
import 'about.dart';
import 'game_over.dart';
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
          PuzzleWidget(
            key: Key('${state.cinematic}, ${state.celebration}'),
          ),
          if (state.cinematic && state.preLoaded)
            PageView(
              controller: controller,
              children: <Widget>[
                Menu(controller),
                Highscore(controller, state.scores),
                About(controller),
                GameOver(controller, state.score),
              ],
            )
        ],
      ),
    );
  }
}
