import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'background.dart';
import 'boundaries.dart';
import 'event_ball.dart';
import 'frame_block.dart';
import 'number_block.dart';
import 'score_counter.dart';

class TumblePuzzleGame extends Forge2DGame with HasDraggables {
  final Function(int score)? onFinish;
  final Function()? onLoaded;
  final boxLength = 8.0;
  final frameThickness = 2.0;
  final numberOfBoxesX = 4;
  final numberOfBoxesY = 4;
  final bool cinematic;
  final bool celebration;
  final bool preLoaded;
  late List<NumberBlock> boxes;
  ScoreCounter? scoreCounter;
  // TODO: remove
  bool isFinished = false;

  TumblePuzzleGame({
    this.cinematic = true,
    this.celebration = false,
    this.preLoaded = false,
    this.onFinish,
    this.onLoaded,
  }) : super(gravity: cinematic ? Vector2.zero() : Vector2(0, -10));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final viewportSize = camera.canvasSize.clone();
    viewportSize.x = viewportSize.x.clamp(500, double.infinity);
    viewportSize.y = viewportSize.y.clamp(800, double.infinity);
    camera.viewport = FixedResolutionViewport(viewportSize);

    add(Background(world.gravity));
    addContactCallback(BallContact());
    final boundaries = createBoundaries(this);
    addAll(boundaries);

    final center = screenToWorld(camera.canvasSize / 2);
    final halfBoxLength = boxLength / 2;
    final startOffset =
        Vector2.all(boxLength * (numberOfBoxesX / 2) - halfBoxLength)..y *= -1;
    final puzzleStartPosition = center - startOffset;
    boxes = generateBoxes(puzzleStartPosition).toList(growable: false);
    addAll(boxes);
    boxes.sort((b1, b2) => b1.number.compareTo(b2.number));

    if (!celebration) {
      addAll(generateFrame(center));
    }
    if (!cinematic) {
      add(scoreCounter = ScoreCounter());
    }

    children.register<EventBall>();
    children.register<TimerComponent>();
    final numberOfBalls =
        ((camera.viewport.effectiveSize.length / 1000).floor()).clamp(1, 10);
    late final timer = TimerComponent(
      period: 1,
      repeat: true,
      removeOnFinish: true,
      onTick: () {
        if (children.query<EventBall>().length < numberOfBalls) {
          addBall(startBall: true);
        } else {
          // TODO: Refactor this.
          children
              .query<TimerComponent>()
              .forEach((t) => t.timer.repeat = false);
        }
      },
    );
    if (!preLoaded) {
      await Future.delayed(const Duration(seconds: 3));
    }
    add(timer);
    onLoaded?.call();
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (!cinematic) {
      super.onDragStart(pointerId, info);
    }
  }

  @override
  void update(double dt) {
    if (dt < 1) {
      super.update(dt);
      if (!cinematic && isSolved()) {
        onFinish?.call(scoreCounter!.score.floor());
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
        if (x < numberOfBoxesX && i < numberOfBoxesY * numberOfBoxesX - 2) {
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

  void addBall({bool startBall = false}) {
    if (children.query<EventBall>().length < 10) {
      final center = screenToWorld(camera.canvasSize / 2);
      if (!startBall) {
        scoreCounter?.score += 50;
      }
      add(EventBall(EventType.boxExplosion, center.clone()..y += size.y / 4));
    }
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
        isStatic: cinematic,
      ),

      // Right frame part
      FrameBlock(
        center + Vector2(centerDistance, 0),
        verticalSize,
        isStatic: cinematic,
      ),

      // Top frame part
      FrameBlock(
        center + Vector2(0, centerDistance),
        horizontalLength,
        isStatic: cinematic,
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
