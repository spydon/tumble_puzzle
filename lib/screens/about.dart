import 'package:flutter/material.dart';

import '../game/logo_game.dart';
import '../widgets/tumble_card.dart';

class About extends StatelessWidget {
  final PageController controller;

  const About(this.controller, {Key? key}) : super(key: key);

  static const aboutText =
      '''This game was created for the Flutter Puzzle Hack 2022.
It uses the Flame game engine and the Forge2D
physics engine.''';

  @override
  Widget build(BuildContext context) {
    return TumbleCard(
      controller,
      children: [
        LogoGameWidget(),
        const Text(
          'TumblePuzzle',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        const Text(
          aboutText,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }
}
