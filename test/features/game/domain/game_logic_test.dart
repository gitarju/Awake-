import 'package:flutter_test/flutter_test.dart';
import 'package:ttt_alarm/features/game/domain/game_logic.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

void main() {
  group('GameLogic', () {
    test('getAvailableMoves returns all indices for empty board', () {
      final board = List<Player?>.filled(9, null);
      final moves = GameLogic.getAvailableMoves(board);
      expect(moves.length, 9);
      expect(moves, [0, 1, 2, 3, 4, 5, 6, 7, 8]);
    });

    test('getAvailableMoves returns correct indices for partially filled board', () {
      final board = List<Player?>.filled(9, null);
      board[0] = Player.x;
      board[4] = Player.o;
      final moves = GameLogic.getAvailableMoves(board);
      expect(moves.length, 7);
      expect(moves, [1, 2, 3, 5, 6, 7, 8]);
    });

    test('isBoardFull returns true when no empty cells', () {
      final board = List<Player?>.filled(9, Player.x);
      expect(GameLogic.isBoardFull(board), isTrue);
    });

    test('isBoardFull returns false when there are empty cells', () {
      final board = List<Player?>.filled(9, null);
      expect(GameLogic.isBoardFull(board), isFalse);
    });

    group('checkWinner', () {
      test('detects row winner', () {
        final board = List<Player?>.filled(9, null);
        board[0] = Player.x;
        board[1] = Player.x;
        board[2] = Player.x;
        expect(GameLogic.checkWinner(board), Player.x);
      });

      test('detects column winner', () {
        final board = List<Player?>.filled(9, null);
        board[0] = Player.o;
        board[3] = Player.o;
        board[6] = Player.o;
        expect(GameLogic.checkWinner(board), Player.o);
      });

      test('detects diagonal winner', () {
        final board = List<Player?>.filled(9, null);
        board[0] = Player.x;
        board[4] = Player.x;
        board[8] = Player.x;
        expect(GameLogic.checkWinner(board), Player.x);
      });

      test('returns null for no winner', () {
        final board = List<Player?>.filled(9, null);
        board[0] = Player.x;
        board[1] = Player.o;
        expect(GameLogic.checkWinner(board), null);
      });
    });

    group('getBestMove (Invincible)', () {
      test('blocks opponent winning move', () {
        // X is about to win on row 0 (indices 0, 1). O should block at 2.
        final board = List<Player?>.filled(9, null);
        board[0] = Player.x;
        board[1] = Player.x;

        // AI is O
        final move = GameLogic.getBestMove(board, Player.o, Difficulty.invincible);
        expect(move, 2);
      });

      test('takes winning move', () {
        // O is about to win on row 0 (indices 0, 1). O should take 2.
        final board = List<Player?>.filled(9, null);
        board[0] = Player.o;
        board[1] = Player.o;

        // AI is O
        final move = GameLogic.getBestMove(board, Player.o, Difficulty.invincible);
        expect(move, 2);
      });

      test('blocks opponent diagonal win', () {
          // X is about to win on diagonal (0, 4). O should block at 8.
          final board = List<Player?>.filled(9, null);
          board[0] = Player.x;
          board[4] = Player.x;

          // AI is O
          final move = GameLogic.getBestMove(board, Player.o, Difficulty.invincible);
          expect(move, 8);
      });
    });
  });
}
