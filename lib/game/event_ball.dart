import 'package:flame/components.dart' as flame;
import 'package:flame/components.dart';
import 'package:flame_forge2d/contact_callbacks.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:flutter/material.dart';

import 'draggable_body.dart';
import 'explosion.dart';

enum EventType {
  frameExplosion,
  gravity,
  boxExplosion,
}

class EventBall extends PositionBodyComponent
    with flame.Draggable, DraggableBody {
  final EventType type;
  final Vector2 startPosition;
  final double radius;
  static final _paint = Paint()..color = Colors.blue;

  EventBall(this.type, this.startPosition, {this.radius = 3})
      : super(size: Vector2.all(radius * 2));

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.8
      ..density = 1.0
      ..friction = 0.4;

    final bodyDef = BodyDef()
      ..userData = this
      ..angularDamping = 0.8
      ..position = startPosition
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    //debugMode = true;

    positionComponent = flame.CircleComponent(radius: radius);
  }
}

class BallContact extends ContactCallback<EventBall, PositionBodyComponent> {
  BallContact();

  @override
  void begin(EventBall ball, PositionBodyComponent other, Contact contact) {
    final impulse = Vector2.random() - Vector2.random();
    ball.body.applyLinearImpulse(impulse.clone()..scale(ball.body.mass * 50));
    other.body.applyLinearImpulse(
      impulse
        ..negate()
        ..scale(ball.body.mass * 200),
    );
    final ballComponent = ball.positionComponent!;
    final otherComponent = other.positionComponent!;
    final explosionCenter =
        (ballComponent.absoluteCenter + otherComponent.absoluteCenter) / 2;
    final localExplosionPosition = otherComponent.toLocal(explosionCenter);
    other.positionComponent?.add(ExplosionComponent(localExplosionPosition));
  }

  @override
  void end(EventBall ball, PositionBodyComponent other, Contact contact) {}
}
