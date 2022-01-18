import 'package:flame/components.dart';
import 'package:flame_forge2d/position_body_component.dart';

class TimedExplosion extends TimerComponent with HasGameRef {
  final PositionBodyComponent explodingComponent;

  TimedExplosion(this.explodingComponent, double period)
      : super(period: period);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Add animation to gameRef
  }

  @override
  void onTick() {
    final mass = explodingComponent.body.mass;
    explodingComponent.body.applyLinearImpulse(
      (Vector2.random() - Vector2.random())..scale(mass * 1000),
    );
  }
}
