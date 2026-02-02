import 'package:equatable/equatable.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameStarted extends GameEvent {
  final Difficulty difficulty;
  const GameStarted({required this.difficulty});

  @override
  List<Object> get props => [difficulty];
}

class PlayerMoved extends GameEvent {
  final int index;
  const PlayerMoved(this.index);

  @override
  List<Object> get props => [index];
}

class GameReset extends GameEvent {}
