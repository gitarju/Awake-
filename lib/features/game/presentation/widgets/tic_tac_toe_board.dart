import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';
import 'package:ttt_alarm/features/game/presentation/bloc/game_bloc.dart';
import 'package:ttt_alarm/features/game/presentation/bloc/game_event.dart';
import 'package:ttt_alarm/features/game/presentation/bloc/game_state.dart';

class TicTacToeBoard extends StatelessWidget {
  const TicTacToeBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return AspectRatio(
          aspectRatio: 1,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildCell(context, 0, state),
                    _buildCell(context, 1, state),
                    _buildCell(context, 2, state),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildCell(context, 3, state),
                    _buildCell(context, 4, state),
                    _buildCell(context, 5, state),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildCell(context, 6, state),
                    _buildCell(context, 7, state),
                    _buildCell(context, 8, state),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCell(BuildContext context, int index, GameState state) {
    final value = state.board[index];
    final isLocked = state.isLocked || state.status != GameStatus.playing;

    return Expanded(
      child: GestureDetector(
        onTap: (value == null && !isLocked)
            ? () => context.read<GameBloc>().add(PlayerMoved(index))
            : null,
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value?.symbol ?? '',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: value == Player.x
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
