import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class DragArm extends PositionComponent {
  DragArm({required this.body, required this.mouseJoint}) : super(priority: 1);

  final Body body;
  final MouseJoint mouseJoint;
  final Paint rubberPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 5.0;

  @override
  void render(Canvas c) {
    final pointA = body.position;
    final pointB = mouseJoint.anchorA;
    final waveLength = pointB - pointA;
    final diffLength = waveLength.length;
    const maxStrokeWidth = 2.0;
    const minStrokeWidth = 0.3;
    final strokeWidth = maxStrokeWidth - diffLength / 20;
    rubberPaint.strokeWidth = strokeWidth.clamp(minStrokeWidth, maxStrokeWidth);
    final path = Path()..moveTo(pointA.x, pointA.y);
    final amplitude = Vector2(
      waveLength.x / 2 + min(10, diffLength / 2),
      waveLength.y / 2 + min(10, diffLength / 2),
    );
    path.relativeConicTo(
      amplitude.x,
      amplitude.y,
      waveLength.x,
      waveLength.y,
      1,
    );
    c.drawPath(path, rubberPaint);
  }
}
