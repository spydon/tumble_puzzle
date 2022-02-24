import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tumble_puzzle/widgets/tumble_card.dart';

class GameOver extends StatelessWidget {
  final PageController controller;
  final int score;

  const GameOver(this.controller, this.score, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TumbleCard(
      controller,
      children: [
        Container(
          width: 50,
          height: 50,
          child: SpriteAnimationWidget.asset(
            path: 'ember.png',
            data: SpriteAnimationData.sequenced(
              amount: 3,
              stepTime: 0.15,
              textureSize: Vector2.all(16),
            ),
          ),
        ),
        Text(
          'You made it with $score points!',
          style: const TextStyle(color: Colors.black, fontSize: 20),
        ),
        Container(
          width: 280,
          child: const Text(
            'Without any frustration at all you managed to solve this simple game. Right?',
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
