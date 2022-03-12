import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import 'drag_arm.dart';

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
    _groundBody = world.createBody(BodyDef());
  }

  bool onDragStart(DragStartInfo info) {
    final mouseJointDef = MouseJointDef()
      ..maxForce = 50 * body.mass
      ..dampingRatio = 0.1
      ..frequencyHz = 100
      ..target.setFrom(info.eventPosition.game)
      ..collideConnected = false
      ..bodyA = _groundBody
      ..bodyB = body;

    mouseJoint ??= world.createJoint(mouseJointDef) as MouseJoint;
    add(dragArm = DragArm(body: body, mouseJoint: mouseJoint!));

    return false;
  }

  bool onDragUpdate(DragUpdateInfo info) {
    mouseJoint?.setTarget(info.eventPosition.game);
    return false;
  }

  bool onDragEnd(_) {
    return onDragCancel();
  }

  bool onDragCancel() {
    remove(dragArm!);
    if (mouseJoint == null) {
      return true;
    }
    world.destroyJoint(mouseJoint!);
    mouseJoint = null;
    return true;
  }
}
