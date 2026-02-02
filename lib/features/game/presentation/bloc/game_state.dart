import 'package:equatable/equatable.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

enum GameStatus { initial, playing, playerWon, aiWon, draw }

class GameState extends Equatable {
  final List<Player?> board;
  final GameStatus status;
  final Difficulty difficulty;
  final Player currentPlayer;
  final bool isLocked; // True when AI is thinking

  const GameState({
    this.board = const [null, null, null, null, null, null, null, null, null],
    this.status = GameStatus.initial,
    this.difficulty = Difficulty.medium,
    this.currentPlayer = Player.x,
    this.isLocked = false,
  });

  GameState copyWith({
    List<Player?>? board,
    GameStatus? status,
    Difficulty? difficulty,
    Player? currentPlayer,
    bool? isLocked,
  }) {
    return GameState(
      board: board ?? this.board,
      status: status ?? this.status,
      difficulty: difficulty ?? this.difficulty,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  List<Object?> get props => [
    board,
    status,
    difficulty,
    currentPlayer,
    isLocked,
  ];
}
