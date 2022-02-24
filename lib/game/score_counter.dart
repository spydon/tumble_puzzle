import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class ScoreCounter extends TextComponent {
  @override
  PositionType positionType = PositionType.viewport;
  double score = 500;

  ScoreCounter()
      : super(
          position: Vector2.all(20),
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 24,
              color: BasicPalette.white.color,
            ),
          ),
        );

  @override
  void update(double dt) {
    score -= dt;
    final roundedScore = max(score.floor(), 0);
    text = 'Score: $roundedScore';
    if (roundedScore % 100 == 0 && children.isEmpty) {
      add(
        MoveEffect.by(
          Vector2(100, 0),
          EffectController(
            duration: 1,
            curve: Curves.easeInExpo,
            alternate: true,
          ),
        ),
      );
    }
  }
}
