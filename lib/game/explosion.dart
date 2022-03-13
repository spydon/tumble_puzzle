import 'dart:math';

import 'package:flame/components.dart';

import 'tumble_puzzle_game.dart';

class ExplosionComponent extends SpriteAnimationComponent
    with HasGameRef<TumblePuzzleGame> {
  ExplosionComponent(Vector2 position)
      : super(
          position: position,
          anchor: Anchor.center,
          removeOnFinish: true,
          priority: 2,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final rng = Random();
    size = Vector2.random(rng)
      ..scale(30)
      ..x += 10
      ..y += 10;
    final animationData = SpriteAnimationData.sequenced(
      amount: 64,
      stepTime: 0.05,
      textureSize: Vector2.all(128),
      amountPerRow: 8,
      loop: false,
    );
    animation =
        await gameRef.loadSpriteAnimation('explosion.png', animationData);
  }
}
