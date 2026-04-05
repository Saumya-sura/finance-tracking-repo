part of 'goal_bloc.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();
  @override
  List<Object?> get props => [];
}

class LoadGoals extends GoalEvent {}
class AddGoal extends GoalEvent {
  final Goal goal;
  const AddGoal(this.goal);
  @override
  List<Object?> get props => [goal];
}
class UpdateGoal extends GoalEvent {
  final Goal goal;
  const UpdateGoal(this.goal);
  @override
  List<Object?> get props => [goal];
}
class DeleteGoal extends GoalEvent {
  final int id;
  const DeleteGoal(this.id);
  @override
  List<Object?> get props => [id];
}
