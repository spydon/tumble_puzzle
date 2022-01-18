import 'package:flame/input.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

mixin DraggableBody on BodyComponent {
  late Body _groundBody;
  MouseJoint? mouseJoint;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _groundBody = world.createBody(BodyDef());
  }

  bool onDragStart(int pointerId, DragStartInfo info) {
    final mouseJointDef = MouseJointDef()
      ..maxForce = 200 * body.mass
      ..dampingRatio = 0.1
      ..frequencyHz = 5
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
