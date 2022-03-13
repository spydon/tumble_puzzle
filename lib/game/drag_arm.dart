import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class DragArm extends PositionComponent {
  final Body body;
  final MouseJoint mouseJoint;
  final Paint rubberPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;

  DragArm({required this.body, required this.mouseJoint}) : super(priority: 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void render(Canvas c) {
    final pointA = (body.localPoint(mouseJoint.anchorA)..y *= -1).toOffset();
    final pointB = (body.localPoint(mouseJoint.anchorB)..y *= -1).toOffset();
    final waveLength = pointB - pointA;
    final diffLength = waveLength.distance;
    const maxStrokeWidth = 2.0;
    const minStrokeWidth = 0.3;
    final strokeWidth = maxStrokeWidth - diffLength / 20;
    rubberPaint.strokeWidth = strokeWidth.clamp(minStrokeWidth, maxStrokeWidth);
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
