import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tumble_puzzle/widgets/tumble_card.dart';

class About extends StatelessWidget {
  final PageController controller;

  const About(this.controller, {Key? key}) : super(key: key);

  static const aboutText =
      '''You are playing as a computer scientist and just like in 
reality the first thing you do is to break the frame so that
you can organize the blocks as you wish, since you know that
this can be done in a much better time complexity than
tediously sliding around the blocks inside of the frame. 

Computer scientist: Breaking the rules to get O(n) instead
of O(n²)? Totally worth it!''';

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
          'TumblePuzzle',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        const Text(
          aboutText,
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }
}
