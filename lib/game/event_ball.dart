import 'package:flame/components.dart' as flame;
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'draggable_body.dart';
import 'explosion.dart';
import 'number_block.dart';

enum EventType {
  frameExplosion,
  gravity,
  boxExplosion,
}

class EventBall extends BodyComponent with flame.Draggable, DraggableBody {
  final EventType type;
  final Vector2 startPosition;
  final Vector2 size;
  final double radius;
  static final _paint = Paint()..color = Colors.blue;

  EventBall(this.type, this.startPosition, {this.radius = 3})
      : size = Vector2.all(radius * 2);

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.9
      ..density = 1.0
      ..friction = 0.4;

    final bodyDef = BodyDef()
      ..userData = this
      ..angularDamping = 0.8
      ..position = startPosition
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class BallContact extends ContactCallback<EventBall, DraggableBody> {
  BallContact();

  @override
  void begin(EventBall ball, DraggableBody other, Contact contact) {
    final impulse = Vector2.random() - Vector2.random();
    other.body.applyLinearImpulse(
      impulse
        ..negate()
        ..scale(ball.body.mass * 200),
    );
    if (other.children.query<ExplosionComponent>().length > 5) {
      return;
    }
    if (other is NumberBlock) {
      final explosionCenter = contact.manifold.localPoint;
      other.add(ExplosionComponent(explosionCenter..y *= -1));
    } else {
      final explosionCenter = (ball.body.position - other.body.position)
        ..rotate(-other.angle);
      explosionCenter.x < explosionCenter.y
          ? explosionCenter.x /= 2
          : explosionCenter.y /= 2;
      other.add(ExplosionComponent(explosionCenter..y *= -1));
    }
  }

  @override
  void end(EventBall ball, DraggableBody other, Contact contact) {}
}
