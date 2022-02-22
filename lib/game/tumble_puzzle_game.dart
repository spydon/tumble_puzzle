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
  late List<NumberBlock> boxes;

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
    boxes = generateBoxes(puzzleStartPosition).toList(growable: false);
    addAll(boxes);
    addAll(generateFrame(center));
    boxes.sort((b1, b2) => b1.number.compareTo(b2.number));

    children.register<EventBall>();
    children.register<FrameBlock>();

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
      print(isSolved());
    }
  }

  @override
  void update(double dt) {
    if (dt < 1) {
      super.update(dt);
    }
  }

  bool isSolved() {
    print(boxes.map((b) => b.number));
    // TODO: Add wiggle room
    final halfBoxLength = boxLength / 2 + 1;
    for (var y = 1; y <= numberOfBoxesY; y++) {
      for (var x = 1; x <= numberOfBoxesX; x++) {
        if (x == numberOfBoxesX && y == numberOfBoxesY) {
          // There is no 16th box
          break;
        }
        final i = x + ((y - 1) * numberOfBoxesX) - 1;
        final current = boxes[i];
        print(current.number);
        if (y > 1) {
          // Check box that should be above the current box
          final above = boxes[i - numberOfBoxesX];
          final diff = above.body.position - current.body.position;
          if (diff.y < 0 || diff.x.abs() > halfBoxLength) {
            print('above');
            return false;
          }
        }
        if (x > 1) {
          // Check box that should be to the left of the current box
          final left = boxes[i - 1];
          final diff = left.body.position - current.body.position;
          if (diff.x > 0 || diff.y.abs() > halfBoxLength) {
            print('left');
            return false;
          }
        }
        if (y < numberOfBoxesY &&
            i + numberOfBoxesX < numberOfBoxesX * numberOfBoxesY - 1) {
          // Check box that should be below the current box
          final below = boxes[i + numberOfBoxesX];
          final diff = below.body.position - current.body.position;
          if (diff.y > 0 || diff.x.abs() > halfBoxLength) {
            print('below');
            return false;
          }
        }
        if (x < numberOfBoxesX) {
          // Check box that should be to the right of the current box
          final right = boxes[i + 1];
          final diff = right.body.position - current.body.position;
          if (diff.x < 0 || diff.y.abs() > halfBoxLength) {
            print('right');
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
            .reversed
            .toList();
    //..shuffle();

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
