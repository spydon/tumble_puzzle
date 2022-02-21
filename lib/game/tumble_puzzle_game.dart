import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'boundaries.dart';
import 'event_ball.dart';
import 'frame_block.dart';
import 'number_block.dart';

class TumblePuzzleGame extends Forge2DGame with HasDraggables {
  final boxLength = 8.0;
  final frameThickness = 2.0;
  final numberOfBoxesX = 4;
  final numberOfBoxesY = 4;
  final bool isCinematic;

  TumblePuzzleGame({this.isCinematic = false, Vector2? gravity})
      : super(gravity: gravity);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addContactCallback(BallContact());
    final boundaries = createBoundaries(this);
    addAll(boundaries);
    final center = screenToWorld(camera.viewport.effectiveSize / 2);
    final halfBoxLength = boxLength / 2;
    final startOffset =
        Vector2.all(boxLength * (numberOfBoxesX / 2) - halfBoxLength)..y *= -1;
    final puzzleStartPosition = center - startOffset;
    final boxes = generateBoxes(puzzleStartPosition).toList(growable: false);
    addAll(boxes);
    addAll(generateFrame(center));

    children.register<EventBall>();
    children.register<FrameBlock>();
    children.register<NumberBlock>();

    final timer = TimerComponent(
      period: 3,
      repeat: true,
      onTick: () {
        if (children.query<EventBall>().length < 1) {
          //add(
          //  NumberBlock(5, center.clone()..y += size.y / 4),
          //);
          add(
            EventBall(EventType.boxExplosion, center.clone()..y += size.y / 4),
          );
        }
      },
    );
    add(timer);
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (!isCinematic) {
      super.onDragStart(pointerId, info);
    }
  }

  @override
  void update(double dt) {
    if (dt < 1) {
      super.update(dt);
    }
  }

  Iterable<NumberBlock> generateBoxes(Vector2 puzzleStartPosition) sync* {
    final numbers =
        List.generate(numberOfBoxesX * numberOfBoxesY - 1, (i) => i + 1)
          ..shuffle();

    // Create boxes with numbers in them in a square
    for (var x = 0; x < numberOfBoxesX; x++) {
      for (var y = 0; y < numberOfBoxesY; y++) {
        if (x == 0 && y == 0) {
          continue;
        }
        final startPosition = puzzleStartPosition.clone()
          ..x += boxLength * x
          ..y -= boxLength * y;
        yield NumberBlock(
          numbers.removeLast(),
          startPosition,
          sideLength: boxLength,
        );
      }
    }
  }

  Iterable<FrameBlock> generateFrame(Vector2 center) {
    final halfFrameThickness = frameThickness / 2;
    const wiggleRoom = 0.2;
    final verticalSize =
        Vector2(frameThickness, numberOfBoxesY * boxLength + 2 * wiggleRoom);
    final horizontalLength = Vector2(
      verticalSize.y + frameThickness * 2,
      frameThickness,
    );
    final centerDistance =
        boxLength * (numberOfBoxesX / 2) + halfFrameThickness + wiggleRoom;
    final frameBlocks = [
      // Left frame part
      FrameBlock(
        center + Vector2(-centerDistance, 0),
        verticalSize,
        isStatic: isCinematic,
      ),

      // Right frame part
      FrameBlock(
        center + Vector2(centerDistance, 0),
        verticalSize,
        isStatic: isCinematic,
      ),

      // Top frame part
      FrameBlock(
        center + Vector2(0, centerDistance),
        horizontalLength,
        isStatic: isCinematic,
      ),

      // Bottom frame part
      FrameBlock(
        center + Vector2(0, -centerDistance),
        horizontalLength,
        isStatic: true,
      ),
    ];
    return frameBlocks;
  }
}
