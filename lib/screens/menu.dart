import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/logo_game.dart';
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

  static const instructionText =
      '''You are a crazy scientist god solving a slider puzzle in space. 
Since you are a god, some rules can be bent (press the buttons),
it doesn't necessarily make it easier though...\n
The blocks don't have to have the correct angle for you to win
(they can be upside-down for example), as long as they go from
1 to 15 in a square.''';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.read(gameNotifierProvider);
    return TumbleCard(
      controller,
      children: [
        LogoGameWidget(),
        const Text(
          'TumblePuzzle',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        if (state.showInstructions)
          const Text(
            instructionText,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ElevatedButton(
          onPressed: () {
            if (state.showInstructions) {
              ref.read(gameNotifierProvider.notifier).setPlay(true);
            } else {
              ref.read(gameNotifierProvider.notifier).setInstructions(true);
            }
          },
          child: const Text('Play'),
        ),
        if (!state.showInstructions) ...[
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
      ],
      withBackButton: false,
    );
  }
}
