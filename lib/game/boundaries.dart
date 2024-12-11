import 'dart:ui';

import 'package:flame/experimental.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:tumble_puzzle/game/tumble_puzzle_game.dart';

List<Wall> createBoundaries(TumblePuzzleWorld world) {
  final bounds = Rectangle.fromRect(world.game.camera.visibleWorldRect);

  return [
    Wall(bounds.topLeft, bounds.topRight),
    Wall(bounds.topRight, bounds.bottomRight),
    Wall(bounds.bottomRight, bounds.bottomLeft),
    Wall(bounds.bottomLeft, bounds.topLeft),
  ];
}

class Wall extends BodyComponent {
  final Vector2 start;
  final Vector2 end;

  Wall(this.start, this.end);

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.0
      ..friction = 0.3;

    final bodyDef = BodyDef()
      ..userData = this // To be able to determine object in collision
      ..position = Vector2.zero()
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
