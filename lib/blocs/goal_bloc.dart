import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/goal.dart';
import '../data/goal_repository.dart';
import 'package:equatable/equatable.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final GoalRepository repository;
  GoalBloc(this.repository) : super(GoalLoading()) {
    on<LoadGoals>(_onLoadGoals);
    on<AddGoal>(_onAddGoal);
    on<UpdateGoal>(_onUpdateGoal);
    on<DeleteGoal>(_onDeleteGoal);
  }

  Future<void> _onLoadGoals(LoadGoals event, Emitter<GoalState> emit) async {
    emit(GoalLoading());
    try {
      final goals = await repository.getGoals();
      emit(GoalLoaded(goals));
    } catch (_) {
      emit(GoalError('Failed to load goals'));
    }
  }

  Future<void> _onAddGoal(AddGoal event, Emitter<GoalState> emit) async {
    if (state is GoalLoaded) {
      await repository.insertGoal(event.goal);
      add(LoadGoals());
    }
  }

  Future<void> _onUpdateGoal(UpdateGoal event, Emitter<GoalState> emit) async {
    if (state is GoalLoaded) {
      await repository.updateGoal(event.goal);
      add(LoadGoals());
    }
  }

  Future<void> _onDeleteGoal(DeleteGoal event, Emitter<GoalState> emit) async {
    if (state is GoalLoaded) {
      await repository.deleteGoal(event.id);
      add(LoadGoals());
    }
  }
}
