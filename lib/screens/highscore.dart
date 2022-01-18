import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tumble_puzzle/widgets/tumble_card.dart';

class Highscore extends StatelessWidget {
  final PageController controller;

  const Highscore(this.controller, {Key? key}) : super(key: key);

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
        const Text(
          'Highscore',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        const Text(
          '<All of the highscore>',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }
}
