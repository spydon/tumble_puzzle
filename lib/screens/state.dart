import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'menu.dart';

class GameState {
  final bool cinematic;
  final bool celebration;
  final MenuItem menuItem;
  // TODO: Maybe a shouldRestart?

  GameState({
    this.cinematic = true,
    this.celebration = false,
    this.menuItem = MenuItem.menu,
  });

  GameState copyWith({
    bool? cinematic,
    bool? celebration,
    MenuItem? menuItem,
  }) {
    return GameState(
      cinematic: cinematic ?? this.cinematic,
      celebration: celebration ?? this.celebration,
      menuItem: menuItem ?? this.menuItem,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState());

  void setPlaying() {
    state = state.copyWith(cinematic: false, celebration: false);
  }

  void setGameOver() {
    state = state.copyWith(
      cinematic: true,
      celebration: true,
      menuItem: MenuItem.highscore,
    );
  }
}

final gameNotifierProvider = StateNotifierProvider<GameNotifier, GameState>(
  (ref) => GameNotifier(),
);
