import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';
import 'package:ttt_alarm/features/game/domain/game_logic.dart';
import 'game_event.dart';
import 'game_state.dart';

@injectable
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState()) {
    on<GameStarted>(_onStarted);
    on<PlayerMoved>(_onPlayerMoved);
    on<GameReset>(_onReset);
  }

  void _onStarted(GameStarted event, Emitter<GameState> emit) {
    emit(
      GameState(
        difficulty: event.difficulty,
        status: GameStatus.playing,
        board: List.filled(9, null),
      ),
    );
  }

  void _onReset(GameReset event, Emitter<GameState> emit) {
    emit(
      GameState(
        difficulty: state.difficulty,
        status: GameStatus.playing,
        board: List.filled(9, null),
      ),
    );
  }

  Future<void> _onPlayerMoved(
    PlayerMoved event,
    Emitter<GameState> emit,
  ) async {
    if (state.status != GameStatus.playing ||
        state.isLocked ||
        state.board[event.index] != null) {
      return;
    }

    // Player Move
    final newBoard = List<Player?>.from(state.board);
    newBoard[event.index] = Player.x;

    emit(state.copyWith(board: newBoard, isLocked: true));

    final winner = GameLogic.checkWinner(newBoard);
    if (winner == Player.x) {
      emit(state.copyWith(status: GameStatus.playerWon, isLocked: false));
      return;
    } else if (GameLogic.isBoardFull(newBoard)) {
      emit(state.copyWith(status: GameStatus.draw, isLocked: false));
      return;
    }

    // AI Turn (Simulate thinking delay)
    await Future.delayed(const Duration(milliseconds: 600));

    // Check if game is still going (in case of reset during delay)
    // Actually Bloc processes sequentially, so unless we use concurrent, this is fine.

    final aiMove = GameLogic.getBestMove(newBoard, Player.o, state.difficulty);
    if (aiMove != -1) {
      newBoard[aiMove] = Player.o;
      final aiWinner = GameLogic.checkWinner(newBoard);

      if (aiWinner == Player.o) {
        emit(
          state.copyWith(
            board: newBoard,
            status: GameStatus.aiWon,
            isLocked: false,
          ),
        );
      } else if (GameLogic.isBoardFull(newBoard)) {
        emit(
          state.copyWith(
            board: newBoard,
            status: GameStatus.draw,
            isLocked: false,
          ),
        );
      } else {
        emit(state.copyWith(board: newBoard, isLocked: false));
      }
    } else {
      // Should be draw if no moves, but handled by isBoardFull above usually.
      emit(state.copyWith(isLocked: false));
    }
  }
}
