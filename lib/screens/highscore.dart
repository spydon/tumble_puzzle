import 'package:flutter/material.dart';

import '../game/logo_game.dart';
import '../widgets/tumble_card.dart';

class Highscore extends StatelessWidget {
  final PageController controller;
  final List<int> scores;

  const Highscore(this.controller, this.scores, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TumbleCard(
      controller,
      children: [
        LogoGameWidget(),
        const Text(
          'Highscore',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        if (scores.isEmpty)
          const Text(
            'Finish the game you lazy vogon!',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        for (final score in scores)
          Text(
            score.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}
