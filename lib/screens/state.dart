import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game/tumble_puzzle_game.dart';
import 'menu.dart';

class GameState {
  final TumblePuzzleGame game;
  final bool preLoaded;
  final bool showInstructions;
  final int score;
  final List<int> scores;
  final Map<String, bool> hovers;
  final MenuItem menuItem;

  GameState({
    required this.game,
    this.preLoaded = false,
    this.showInstructions = false,
    this.score = 0,
    this.scores = const [],
    this.hovers = const {},
    this.menuItem = MenuItem.menu,
  });

  bool get cinematic => game.cinematic;
  bool get celebration => game.celebration;

  GameState copyWith({
    TumblePuzzleGame? game,
    bool? preLoaded,
    bool? showInstructions,
    int? score,
    List<int>? scores,
    Map<String, bool>? hovers,
    MenuItem? menuItem,
  }) {
    return GameState(
      game: game ?? this.game,
      preLoaded: preLoaded ?? this.preLoaded,
      showInstructions: showInstructions ?? this.showInstructions,
      score: score ?? this.score,
      scores: scores ?? this.scores,
      hovers: hovers ?? this.hovers,
      menuItem: menuItem ?? this.menuItem,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(TumblePuzzleGame game) : super(GameState(game: game));

  TumblePuzzleGame _retrieveGame({
    bool? cinematic,
    bool? celebration,
    bool? preLoaded,
  }) {
    if ((cinematic == null || cinematic == state.cinematic) &&
        (celebration == null || celebration == state.cinematic) &&
        (preLoaded == null || preLoaded == state.preLoaded)) {
      return state.game;
    } else {
      return TumblePuzzleGame(
        cinematic: cinematic ?? state.cinematic,
        celebration: celebration ?? state.celebration,
        preLoaded: preLoaded ?? state.preLoaded,
        onFinish: setGameOver,
        onLoaded: setLoaded,
      );
    }
  }

  void setPlay(bool playing) {
    if (state.cinematic == playing) {
      state = state.copyWith(
        game: _retrieveGame(cinematic: !playing),
        showInstructions: false,
        hovers: {},
      );
    }
  }

  void setGameOver(int score) {
    final scores = state.scores.toList()
      ..add(score)
      ..sort();
    state = state.copyWith(
      game: _retrieveGame(cinematic: true, celebration: true),
      score: score,
      scores: scores,
      hovers: {},
      menuItem: MenuItem.gameover,
    );
  }

  void setLoaded() {
    if (state.preLoaded != true) {
      state = state.copyWith(preLoaded: true);
    }
  }

  void setHover(String key, bool isHovering) {
    if (state.hovers[key] != isHovering) {
      state = state.copyWith(
        hovers: {
          ...state.hovers,
          ...{key: isHovering}
        },
      );
    }
  }

  void setInstructions(bool showInstructions) {
    if (state.showInstructions != showInstructions) {
      state = state.copyWith(showInstructions: showInstructions);
    }
  }
}

final gameNotifierProvider = StateNotifierProvider<GameNotifier, GameState>(
  (ref) {
    return GameNotifier(
      TumblePuzzleGame(
        onLoaded: () => ref.read(gameNotifierProvider.notifier).setLoaded(),
      ),
    );
  },
);
