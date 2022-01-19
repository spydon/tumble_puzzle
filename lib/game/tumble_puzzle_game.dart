import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:tumble_puzzle/game/timed_explosion.dart';

import 'boundaries.dart';
import 'frame_block.dart';
import 'number_block.dart';

class TumblePuzzleGame extends Forge2DGame with HasDraggables {
  final boxLength = 8.0;
  final frameThickness = 2.0;
  final numberOfBoxesX = 4;
  final numberOfBoxesY = 4;
  final bool isCinematic;
  late final Iterable<FrameBlock> _frameBlocks;

  TumblePuzzleGame({this.isCinematic = false, Vector2? gravity})
      : super(gravity: gravity);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final boundaries = createBoundaries(this);
    addAll(boundaries);
    final center = screenToWorld(camera.viewport.effectiveSize / 2);
    final halfBoxLength = boxLength / 2;
    final startOffset =
        Vector2.all(boxLength * (numberOfBoxesX / 2) - halfBoxLength)..y *= -1;
    final puzzleStartPosition = center - startOffset;
    final boxes = generateBoxes(puzzleStartPosition).toList(growable: false);
    addAll(boxes);
    addAll(_frameBlocks = generateFrame(center));
    final explosions = List.generate(
      isCinematic ? 100 : 3,
      (i) => TimedExplosion((boxes..shuffle()).first, 3.0 + i),
    );
    addAll(explosions);
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (!isCinematic) {
      super.onDragStart(pointerId, info);
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
    final frameBlocks = [
      // Left frame part
      FrameBlock(
        center -
            Vector2(
                (numberOfBoxesY / 2) * boxLength + halfFrameThickness + 0.1, 0),
        Vector2(frameThickness, numberOfBoxesY * boxLength),
        isStatic: !isCinematic,
      ),

      // Right frame part
      FrameBlock(
        center +
            Vector2(
                (numberOfBoxesY / 2) * boxLength + halfFrameThickness + 0.1, 0),
        Vector2(frameThickness, numberOfBoxesY * boxLength),
        isStatic: !isCinematic,
      ),

      // Top frame part
      FrameBlock(
        center +
            Vector2(
                0, boxLength * (numberOfBoxesX / 2) + halfFrameThickness + 0.1),
        Vector2(
          numberOfBoxesX * boxLength + 2 * frameThickness,
          frameThickness,
        ),
        isStatic: !isCinematic,
      ),

      // Bottom frame part
      FrameBlock(
        center -
            Vector2(
                0, boxLength * (numberOfBoxesX / 2) + halfFrameThickness + 0.1),
        Vector2(
          numberOfBoxesX * boxLength + 2 * frameThickness,
          frameThickness,
        ),
        isStatic: true,
      ),
    ];
    return frameBlocks;
  }
}
