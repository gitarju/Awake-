import 'dart:math';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

class GameLogic {
  static const int boardSize = 9;

  /// Returns the indices of empty cells
  static List<int> getAvailableMoves(List<Player?> board) {
    return List.generate(
      boardSize,
      (i) => i,
    ).where((i) => board[i] == null).toList();
  }

  /// Checks for a winner. Returns Player.x, Player.o, or null.
  static Player? checkWinner(List<Player?> board) {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Cols
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var line in lines) {
      if (board[line[0]] != null &&
          board[line[0]] == board[line[1]] &&
          board[line[0]] == board[line[2]]) {
        return board[line[0]];
      }
    }
    return null;
  }

  static bool isBoardFull(List<Player?> board) {
    return board.every((cell) => cell != null);
  }

  /// AI Move Calculation
  static int getBestMove(
    List<Player?> board,
    Player aiPlayer,
    Difficulty difficulty,
  ) {
    switch (difficulty) {
      case Difficulty.easy:
        return _getRandomMove(board);
      case Difficulty.medium:
        // 50% chance of random, 50% best
        return Random().nextBool()
            ? _getRandomMove(board)
            : _getMinimaxMove(board, aiPlayer);
      case Difficulty.hard:
        // 20% error margin (example) or depth limited
        return Random().nextInt(10) < 2
            ? _getRandomMove(board)
            : _getMinimaxMove(board, aiPlayer);
      case Difficulty.invincible:
        return _getMinimaxMove(board, aiPlayer);
    }
  }

  static int _getRandomMove(List<Player?> board) {
    final available = getAvailableMoves(board);
    if (available.isEmpty) return -1;
    return available[Random().nextInt(available.length)];
  }

  static int _getMinimaxMove(List<Player?> board, Player aiPlayer) {
    int bestScore = -1000;
    int move = -1;
    final available = getAvailableMoves(board);

    // Minor optimization: check if we can win immediately or need to block immediately
    // to save recursion time on first moves

    for (var i in available) {
      board[i] = aiPlayer;
      int score = _minimax(board, 0, false, aiPlayer);
      board[i] = null;

      if (score > bestScore) {
        bestScore = score;
        move = i;
      }
    }
    return move;
  }

  static int _minimax(
    List<Player?> board,
    int depth,
    bool isMaximizing,
    Player aiPlayer,
  ) {
    Player? winner = checkWinner(board);
    if (winner == aiPlayer) return 10 - depth;
    if (winner == aiPlayer.opponent) return depth - 10;
    if (isBoardFull(board)) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (var i in getAvailableMoves(board)) {
        board[i] = aiPlayer;
        int score = _minimax(board, depth + 1, false, aiPlayer);
        board[i] = null;
        bestScore = max(score, bestScore);
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (var i in getAvailableMoves(board)) {
        board[i] = aiPlayer.opponent;
        int score = _minimax(board, depth + 1, true, aiPlayer);
        board[i] = null;
        bestScore = min(score, bestScore);
      }
      return bestScore;
    }
  }
}
