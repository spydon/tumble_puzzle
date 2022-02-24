import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';

class GameState {
  final bool cinematic;
  final bool celebration;
  final int score;
  final List<int> scores;
  final MenuItem menuItem;

  GameState({
    this.cinematic = true,
    this.celebration = false,
    this.score = 0,
    this.scores = const [],
    this.menuItem = MenuItem.menu,
  });

  GameState copyWith({
    bool? cinematic,
    bool? celebration,
    int? score,
    List<int>? scores,
    MenuItem? menuItem,
  }) {
    return GameState(
      cinematic: cinematic ?? this.cinematic,
      celebration: celebration ?? this.celebration,
      score: score ?? this.score,
      scores: scores ?? this.scores,
      menuItem: menuItem ?? this.menuItem,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState());

  void setPlaying() {
    state = state.copyWith(cinematic: false, celebration: false);
  }

  void setGameOver(int score) {
    final scores = state.scores.toList()
      ..add(score)
      ..sort();
    state = state.copyWith(
      cinematic: true,
      celebration: true,
      score: score,
      scores: scores,
      menuItem: MenuItem.gameover,
    );
  }
}

final gameNotifierProvider = StateNotifierProvider<GameNotifier, GameState>(
  (ref) => GameNotifier(),
);