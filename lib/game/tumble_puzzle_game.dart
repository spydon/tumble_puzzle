import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumble_puzzle/screens/state.dart';

import 'background.dart';
import 'boundaries.dart';
import 'event_ball.dart';
import 'explosion.dart';
import 'frame_block.dart';
import 'number_block.dart';
import 'score_counter.dart';

class TumblePuzzleGame extends Forge2DGame {
  TumblePuzzleGame({
    required this.ref,
    this.cinematic = true,
    this.celebration = false,
    this.preLoaded = false,
    this.onFinish,
    this.onLoaded,
  });

  final Ref ref;
  final bool cinematic;
  final bool celebration;
  final bool preLoaded;
  final Function(int score)? onFinish;
  final Function()? onLoaded;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final viewportSize = size.clone();
    viewportSize.x = viewportSize.x.clamp(500, double.infinity);
    viewportSize.y = viewportSize.y.clamp(800, double.infinity);
    camera.viewport = FixedResolutionViewport(resolution: viewportSize);

    camera.backdrop.add(Background(world.gravity));
    if (!preLoaded) {
      await Future.delayed(const Duration(seconds: 4));
    }
    world = TumblePuzzleWorld(cinematic: cinematic);
  }
}

class TumblePuzzleWorld extends Forge2DWorld
    with DragCallbacks, HasGameReference<TumblePuzzleGame> {
  TumblePuzzleWorld({bool cinematic = true})
      : super(gravity: cinematic ? Vector2.zero() : Vector2(0, 10));

  final boxLength = 8.0;
  final frameThickness = 2.0;
  final numberOfBoxesX = 4;
  final numberOfBoxesY = 4;
  late List<NumberBlock> boxes;
  late List<FrameBlock> frame;
  bool _staticFrame = false;
  ScoreCounter? scoreCounter;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final boundaries = createBoundaries(this);
    addAll(boundaries);

    final center = Vector2.zero();
    final halfBoxLength = boxLength / 2;
    final startOffset =
        Vector2.all(boxLength * (numberOfBoxesX / 2) - halfBoxLength)..y *= -1;
    final puzzleStartPosition = center - startOffset;
    boxes = generateBoxes(puzzleStartPosition).toList(growable: false);
    addAll(boxes);
    boxes.sort((b1, b2) => b1.number.compareTo(b2.number));

    if (!game.celebration) {
      addAll(frame = generateFrame(static: true));
    }
    if (!game.cinematic) {
      game.camera.viewport.add(scoreCounter = ScoreCounter());
    }

    children.register<EventBall>();
    children.register<TimerComponent>();
    final numberOfBalls =
        (game.size.length ~/ 1000).clamp(1, 10) + (game.celebration ? 3 : 0);
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
    if (!game.preLoaded) {
      await Future.delayed(const Duration(seconds: 4));
    }
    add(timer);
    game.ref.read(gameNotifierProvider.notifier).setLoaded();
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (!game.cinematic) {
      // TODO: This doesn't work anymore since we don't go through the game
      // mixin.
      super.onDragStart(event);
    }
  }

  @override
  void update(double dt) {
    if (dt < 1) {
      super.update(dt);
      if (!game.cinematic && isSolved()) {
        game.onFinish?.call(scoreCounter!.score.floor());
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
      if (!startBall) {
        scoreCounter?.score += 50;
      }
      add(EventBall(Vector2(0, game.size.y / game.camera.viewfinder.zoom / 4)));
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

  void breakFrame() {
    if (!_staticFrame) {
      return;
    }
    frame.forEach((side) => side.removeFromParent());
    frame.clear();
    frame = generateFrame(static: false);
    addAll(frame);
  }

  List<FrameBlock> generateFrame({required bool static}) {
    _staticFrame = static;
    final center = Vector2.zero();
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
        isStatic: static,
      ),

      // Right frame part
      FrameBlock(
        center + Vector2(centerDistance, 0),
        verticalSize,
        isStatic: static,
      ),

      // Top frame part
      FrameBlock(
        center + Vector2(0, centerDistance),
        horizontalLength,
        isStatic: static,
      ),

      // Bottom frame part
      FrameBlock(
        center + Vector2(0, -centerDistance),
        horizontalLength,
        isStatic: true,
      ),
    ];
    if (!static) {
      final centerDiff = Vector2.all(centerDistance);
      final flippedCenter = center..y *= -1;
      final explosions = [
        ExplosionComponent(flippedCenter + centerDiff),
        ExplosionComponent(flippedCenter - centerDiff),
        ExplosionComponent(flippedCenter + (centerDiff.clone()..x *= -1)),
        ExplosionComponent(flippedCenter + (centerDiff.clone()..y *= -1)),
      ];
      addAll(explosions);
    }
    return frameBlocks;
  }
}
