import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/rendering.dart';

class Background extends ParallaxComponent {
  Background(this.velocity);

  final Vector2 velocity;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = game.size;

    parallax = await game.loadParallax(
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
