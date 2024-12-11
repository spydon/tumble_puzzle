import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'package:tumble_puzzle/game/drag_arm.dart';
import 'package:tumble_puzzle/game/explosion.dart';

mixin DraggableBody on BodyComponent {
  late Body _groundBody;
  MouseJoint? mouseJoint;
  final Paint rubberPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;
  DragArm? dragArm;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    children.register<ExplosionComponent>();
    _groundBody = world.createBody(BodyDef());
  }

  bool onDragStart(DragStartEvent event) {
    final mouseJointDef = MouseJointDef()
      ..maxForce = 50 * body.mass
      ..dampingRatio = 0.1
      ..frequencyHz = 100
      ..target.setFrom(event.localPosition)
      ..collideConnected = false
      ..bodyA = _groundBody
      ..bodyB = body;

    if (mouseJoint == null) {
      mouseJoint = MouseJoint(mouseJointDef);
      world.createJoint(mouseJoint!);
      world.add(dragArm = DragArm(body: body, mouseJoint: mouseJoint!));
      priority = 2;
    }

    return false;
  }

  bool onDragUpdate(DragUpdateEvent event) {
    mouseJoint?.setTarget(event.localEndPosition);
    return false;
  }

  void onDragEnd(DragEndEvent event) {
    return onDragCancel(DragCancelEvent(event.pointerId));
  }

  void onDragCancel(DragCancelEvent event) {
    world.remove(dragArm!);
    priority = 0;
    if (mouseJoint == null) {
      return;
    }
    world.destroyJoint(mouseJoint!);
    mouseJoint = null;
  }
}
