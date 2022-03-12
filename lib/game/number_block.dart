import 'package:flame/components.dart' as flame;
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'draggable_body.dart';

class NumberBlock extends PositionBodyComponent
    with flame.Draggable, DraggableBody {
  final int number;
  final Vector2 startPosition;
  final double sideLength;
  static final _paint = Paint()..color = Colors.blue;

  NumberBlock(this.number, this.startPosition, {this.sideLength = 6})
      : super(size: Vector2.all(sideLength));

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
    //debugMode = true;
    final _textRenderer = TextPaint(
      style: const TextStyle(
        color: Colors.black38,
        fontFamily: 'monospace',
        height: 3.50,
        //letterSpacing: 2.0,
        fontSize: 4.0,
        //shadows: [
        //  Shadow(color: Colors.red, offset: Offset(0.1, 0.1), blurRadius: 0.5),
        //  Shadow(color: Colors.yellow, offset: Offset(0.2, 0.2), blurRadius: 1),
        //],
      ),
    );
    positionComponent = RectangleComponent.square(size: sideLength)
      ..add(
        TextComponent(
          text: number.toString(),
          textRenderer: _textRenderer,
          anchor: Anchor.center,
          position: size / 2,
          priority: -1,
        ),
      )
      ..add(
        RectangleComponent(
          size: Vector2(sideLength / 2, sideLength / 20),
          position: Vector2(sideLength / 2, sideLength * (3.8 / 5)),
          anchor: Anchor.center,
          paint: Paint()..color = Colors.black38,
        ),
      );
    //}
  }
}
