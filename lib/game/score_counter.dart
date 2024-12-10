import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreCounter extends TextComponent {
  double score = 1000;

  static final _textRenderer = TextPaint(
    style: GoogleFonts.vt323(
      fontSize: 40,
      color: Colors.white60,
      fontWeight: FontWeight.bold,
    ),
  );

  ScoreCounter()
      : super(position: Vector2.all(20), textRenderer: _textRenderer);

  @override
  void update(double dt) {
    score = max(0, score - dt);
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
