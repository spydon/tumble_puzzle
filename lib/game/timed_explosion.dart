import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';

import 'tumble_puzzle_game.dart';

class TimedExplosion extends TimerComponent with HasGameRef<TumblePuzzleGame> {
  final PositionBodyComponent explodingComponent;
  late final Body body;
  late final SpriteAnimation explosion;

  TimedExplosion(this.explodingComponent, double period)
      : super(period: period);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body = explodingComponent.body;
    final animationData = SpriteAnimationData.sequenced(
      amount: 64,
      stepTime: 0.05,
      textureSize: Vector2.all(128),
      amountPerRow: 8,
      loop: false,
    );
    explosion =
        await gameRef.loadSpriteAnimation('explosion.png', animationData);
  }

  @override
  void onTick() {
    final positionComponent = explodingComponent.positionComponent!;
    final explosionComponent = SpriteAnimationComponent(
      animation: explosion,
      size: Vector2.all(30),
      position: positionComponent.size / 2,
      removeOnFinish: true,
      anchor: Anchor.center,
    );
    positionComponent.add(explosionComponent);
    body.applyLinearImpulse(
      (Vector2.random() - Vector2.random())..scale(body.mass * 1000),
    );
  }
}
