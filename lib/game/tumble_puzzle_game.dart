import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'background.dart';
import 'boundaries.dart';
import 'event_ball.dart';
import 'frame_block.dart';
import 'number_block.dart';

class TumblePuzzleGame extends Forge2DGame with HasDraggables {
  final Function()? onFinish;
  final boxLength = 8.0;
  final frameThickness = 2.0;
  final numberOfBoxesX = 4;
  final numberOfBoxesY = 4;
  final bool isCinematic;
  final bool isCelebration;
  late List<NumberBlock> boxes;

  TumblePuzzleGame({
    this.isCinematic = false,
    this.isCelebration = false,
    this.onFinish,
  }) : super(gravity: isCinematic ? Vector2.zero() : Vector2(0, -10));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // TODO(spydon): This has to be only [size] once it is updated to v1.1
    camera.viewport = FixedResolutionViewport(size * camera.zoom);
    add(Background(world.gravity));
    addContactCallback(BallContact());
    final boundaries = createBoundaries(this);
    addAll(boundaries);
    final center = screenToWorld(camera.viewport.effectiveSize / 2);
    final halfBoxLength = boxLength / 2;
    final startOffset =
        Vector2.all(boxLength * (numberOfBoxesX / 2) - halfBoxLength)..y *= -1;
    final puzzleStartPosition = center - startOffset;
    boxes = generateBoxes(puzzleStartPosition).toList(growable: false);
    addAll(boxes);
    if (!isCelebration) {
      addAll(generateFrame(center));
    }
    boxes.sort((b1, b2) => b1.number.compareTo(b2.number));

    children.register<EventBall>();

    final timer = TimerComponent(
      period: 3,
      repeat: true,
      onTick: () {
        if (children.query<EventBall>().length < (isCelebration ? 10 : 1)) {
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
      if (!isCinematic && isSolved()) {
        onFinish?.call();
      }
    }
  }

  // This vector2 allows us to not create 4 new objects every tick in isSolved.
  final Vector2 _diff = Vector2.zero();

  bool isSolved() {
    final halfBoxLength = boxLength / 2 + 1;
    for (var y = 1; y <= numberOfBoxesY; y++) {
      for (var x = 1; x <= numberOfBoxesX; x++) {
        if (x == numberOfBoxesX && y == numberOfBoxesY) {
          // There is no 16th box
          break;
        }
        final i = x + ((y - 1) * numberOfBoxesX) - 1;
        final current = boxes[i];
        if (y > 1) {
          // Check box that should be above the current box
          final above = boxes[i - numberOfBoxesX];
          _diff
            ..setFrom(above.body.position)
            ..sub(current.body.position);
          if (_diff.y < 0 || _diff.x.abs() > halfBoxLength) {
            return false;
          }
        }
        if (x > 1) {
          // Check box that should be to the left of the current box
          final left = boxes[i - 1];
          _diff
            ..setFrom(left.body.position)
            ..sub(current.body.position);
          if (_diff.x > 0 || _diff.y.abs() > halfBoxLength) {
            return false;
          }
        }
        if (y < numberOfBoxesY &&
            i + numberOfBoxesX < numberOfBoxesX * numberOfBoxesY - 1) {
          // Check box that should be below the current box
          final below = boxes[i + numberOfBoxesX];
          _diff
            ..setFrom(below.body.position)
            ..sub(current.body.position);
          if (_diff.y > 0 || _diff.x.abs() > halfBoxLength) {
            return false;
          }
        }
        if (x < numberOfBoxesX) {
          // Check box that should be to the right of the current box
          final right = boxes[i + 1];
          _diff
            ..setFrom(right.body.position)
            ..sub(current.body.position);
          if (_diff.x < 0 || _diff.y.abs() > halfBoxLength) {
            return false;
          }
        }
      }
    }
    return true;
  }

  Iterable<NumberBlock> generateBoxes(Vector2 puzzleStartPosition) sync* {
    final numbers =
        List.generate(numberOfBoxesX * numberOfBoxesY - 1, (i) => i + 1)
          ..shuffle();

    // Create boxes with numbers in them in a square
    for (var y = 0; y < numberOfBoxesY; y++) {
      for (var x = 0; x < numberOfBoxesX; x++) {
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
