import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';

class LogoGame extends FlameGame with TapDetector {
  late final PositionComponent logoBall;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    logoBall = PositionComponent(anchor: Anchor.center);

    final grayBallSprite = await Sprite.load('ball_gray.png');
    final fireBallSprite = await Sprite.load('ball_fire.png');

    logoBall.add(
      SpriteComponent(
        sprite: fireBallSprite,
        position: size / 2,
        size: size,
        anchor: Anchor.center,
      )..add(
          OpacityEffect.fadeOut(
            EffectController(
              duration: 1.0,
              curve: Curves.easeOutExpo,
              alternate: true,
              infinite: true,
            ),
          ),
        ),
    );
    logoBall.add(
      SpriteComponent(
        sprite: grayBallSprite,
        position: size / 2,
        size: size,
        anchor: Anchor.center,
      )..add(
          RotateEffect.by(
            5,
            EffectController(
              duration: 1.0,
              curve: Curves.bounceIn,
              infinite: true,
            ),
          ),
        ),
    );
    add(logoBall);
  }

  @override
  void onTap() {
    const radius = Radius.elliptical(30, 30);
    final path = Path()
      ..lineTo(0, 0)
      ..arcToPoint(const Offset(0, 300), radius: radius)
      ..arcToPoint(const Offset(0, 0), radius: radius);
    logoBall.add(MoveAlongPathEffect(path, EffectController(duration: 2)));
    logoBall.add(
      ScaleEffect.to(
        Vector2.all(1.5),
        EffectController(duration: 0.3, repeatCount: 3, alternate: true),
      ),
    );
  }
}

class LogoGameWidget extends Container {
  LogoGameWidget()
      : super(
          width: 50,
          height: 50,
          child: GameWidget(game: LogoGame()),
        );
}
