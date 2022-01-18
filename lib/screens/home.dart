import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/tumble_puzzle_game.dart';
import 'about.dart';
import 'highscore.dart';
import 'menu.dart';

final Map<String, int> menuItems = {'menu': 0, 'highscore': 1, 'about': 2};

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: TumblePuzzleGame(isCinematic: true, gravity: Vector2.zero()),
          ),
          PageView(
            controller: controller,
            children: <Widget>[
              Menu(controller),
              Highscore(controller),
              About(controller),
            ],
          )
        ],
      ),
    );
  }
}
