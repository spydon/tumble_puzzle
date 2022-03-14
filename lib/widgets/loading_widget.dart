import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingWidget extends GameWidget {
  LoadingWidget() : super(game: LoadingScreen());
}

class LoadingScreen extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final logo = await loadSprite('flame.png');
    add(
      SpriteComponent(sprite: logo, position: size / 2, anchor: Anchor.center)
        ..add(
          OpacityEffect.fadeOut(
            EffectController(duration: 2, infinite: true, alternate: true),
          ),
        ),
    );

    final pixelStyle = TextPaint(
      style: GoogleFonts.saira(
        fontSize: 20,
        color: Colors.grey,
        fontWeight: FontWeight.bold,
      ),
    );

    add(
      TextComponent(
        text: 'Made with Flame',
        textRenderer: pixelStyle,
        position: (size / 2)..y += 125,
        anchor: Anchor.center,
        priority: 1,
      ),
    );
  }
}
