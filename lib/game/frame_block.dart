import 'package:flame/components.dart' as flame;
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'draggable_body.dart';
import 'number_block.dart';
import 'tumble_puzzle_game.dart';

enum Direction {
  north,
  east,
  south,
  west,
}

class FrameBlock extends BodyComponent
    with flame.Draggable, DraggableBody {
  final Vector2 startPosition;
  final Vector2 size;
  final bool isStatic;
  final BlockColor color;

  FrameBlock(
    this.startPosition,
    this.size, {
    this.isStatic = false,
    this.color = BlockColor.red,
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

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final boxSprite = await () {
      switch (color) {
        case BlockColor.green:
          return Sprite.load('green_black_box.png');
        case BlockColor.red:
          return Sprite.load('red_black_box.png');
      }
    }();
    add(
      flame.SpriteComponent(
        sprite: boxSprite,
        position: -size / 2,
        size: size,
      ),
    );
  }
}
