import 'package:flame/components.dart' as flame;
import 'package:flame_forge2d/flame_forge2d.dart';

import 'draggable_body.dart';

enum Direction {
  north,
  east,
  south,
  west,
}

class FrameBlock extends BodyComponent with flame.Draggable, DraggableBody {
  final Vector2 startPosition;
  final Vector2 size;
  final bool isStatic;

  FrameBlock(
    this.startPosition,
    this.size, {
    this.isStatic = false,
  });

  @override
  Body createBody() {
    final shape = PolygonShape()..setAsBoxXY(size.x / 2, size.y / 2);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.4
      ..density = 5.0
      ..friction = 0.4;

    final bodyDef = BodyDef()
      ..userData = this
      ..angularDamping = 0.8
      ..position = startPosition
      ..type = isStatic ? BodyType.static : BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
