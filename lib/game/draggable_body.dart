import 'dart:math';

import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/position_body_component.dart';
import 'package:flutter/material.dart';

mixin DraggableBody on PositionBodyComponent {
  late Body _groundBody;
  MouseJoint? mouseJoint;
  final Paint rubberPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _groundBody = world.createBody(BodyDef());
  }

  @override
  void render(Canvas c) {
    super.render(c);
    if (mouseJoint != null) {
      final pointA = (body.localPoint(mouseJoint!.anchorA)..y *= -1).toOffset();
      final pointB = (body.localPoint(mouseJoint!.anchorB)..y *= -1).toOffset();
      final waveLength = pointB - pointA;
      final diffLength = waveLength.distance;
      final strokeWidth = positionComponent!.size.x - diffLength / 5;
      rubberPaint.strokeWidth = min(max(0.3, strokeWidth), 2);
      final path = Path()..moveTo(pointA.dx, pointA.dy);
      final amplitude = Offset(
        waveLength.dx / 2 + min(10, diffLength / 2),
        waveLength.dy / 2 + min(10, diffLength / 2),
      );
      path.relativeConicTo(
        amplitude.dx,
        amplitude.dy,
        waveLength.dx,
        waveLength.dy,
        1,
      );
      c.drawPath(path, rubberPaint);
    }
  }

  bool onDragStart(int pointerId, DragStartInfo info) {
    final mouseJointDef = MouseJointDef()
      ..maxForce = 50 * body.mass
      ..dampingRatio = 0.1
      ..frequencyHz = 100
      ..target.setFrom(info.eventPosition.game)
      ..collideConnected = false
      ..bodyA = _groundBody
      ..bodyB = body;

    mouseJoint ??= world.createJoint(mouseJointDef) as MouseJoint;

    return false;
  }

  bool onDragUpdate(int pointerId, DragUpdateInfo info) {
    mouseJoint?.setTarget(info.eventPosition.game);
    return false;
  }

  bool onDragEnd(int pointerId, _) {
    return onDragCancel(pointerId);
  }

  bool onDragCancel(int pointerId) {
    if (mouseJoint == null) {
      return true;
    }
    world.destroyJoint(mouseJoint!);
    mouseJoint = null;
    return true;
  }
}
