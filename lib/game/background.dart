import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/rendering.dart';

class Background extends ParallaxComponent {
  @override
  PositionType positionType = PositionType.viewport;
  final Vector2 velocity;

  @override
  int priority = -1;

  Background(this.velocity);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = gameRef.camera.viewport.effectiveSize;

    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('bg.png'),
        ParallaxImageData('bg2.png'),
      ],
      baseVelocity: velocity,
      velocityMultiplierDelta: Vector2.all(2),
      repeat: ImageRepeat.repeat,
    );
  }

  @override
  void update(double t) {
    super.update(t);
  }
}
