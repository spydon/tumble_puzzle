import 'package:flame/components.dart' as flame;
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'draggable_body.dart';

enum BlockColor {
  red,
  green,
}

class NumberBlock extends BodyComponent with flame.Draggable, DraggableBody {
  final BlockColor color;
  final int number;
  final Vector2 startPosition;
  final double sideLength;
  final Vector2 size;

  NumberBlock(
    this.number,
    this.startPosition, {
    this.sideLength = 6,
    this.color = BlockColor.green,
  }) : size = Vector2.all(sideLength);

  @override
  Body createBody() {
    final halfSideLength = sideLength / 2;
    final shape = PolygonShape()..setAsBoxXY(halfSideLength, halfSideLength);

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

    final _textRenderer = TextPaint(
      style: GoogleFonts.vt323(
        fontSize: 5,
        color: Colors.white60,
        fontWeight: FontWeight.bold,
      ),
    );
    final boxSize = Vector2.all(sideLength);
    final boxSprite = await () {
      switch (color) {
        case BlockColor.green:
          return Sprite.load('green_box.png');
        case BlockColor.red:
          return Sprite.load('red_box.png');
      }
    }();
    renderBody = false;
    add(
      flame.SpriteComponent(
        sprite: boxSprite,
        position: -boxSize / 2,
        size: boxSize,
      )
        ..add(
          TextComponent(
            text: number.toString(),
            textRenderer: _textRenderer,
            anchor: Anchor.center,
            position: size / 2,
          ),
        )
        ..add(
          RectangleComponent(
            size: Vector2(sideLength / 2, sideLength / 20),
            position: Vector2(sideLength / 2, sideLength * (3.8 / 5)),
            anchor: Anchor.center,
            paint: Paint()..color = Colors.white60,
          ),
        ),
    );
    //}
  }
}
