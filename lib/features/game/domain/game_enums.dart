enum Player { x, o }

enum Difficulty { easy, medium, hard, invincible }

extension PlayerX on Player {
  Player get opponent => this == Player.x ? Player.o : Player.x;
  String get symbol => this == Player.x ? 'X' : 'O';
}
