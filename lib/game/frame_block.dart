import 'package:flame/components.dart';
import 'package:flame/components.dart' as flame;
import 'package:flame_forge2d/flame_forge2d.dart';

import 'draggable_body.dart';

enum Direction {
  north,
  east,
  south,
  west,
}

class FrameBlock extends PositionBodyComponent
    with flame.Draggable, DraggableBody {
  final Vector2 startPosition;
  final bool isStatic;

  FrameBlock(
    this.startPosition,
    Vector2 size, {
    this.isStatic = false,
  }) : super(size: size);

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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    positionComponent = RectangleComponent(size: size);
  }
}
