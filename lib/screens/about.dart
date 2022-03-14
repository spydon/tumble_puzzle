import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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
        const SizedBox(height: 10),
        const Text(
          'The source code can be found at:',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        Linkify(
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              throw 'Could not launch $link';
            }
          },
          text: 'https://github.com/spydon/tumble_puzzle',
          linkStyle: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
