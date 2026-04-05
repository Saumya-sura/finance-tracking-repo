import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/goal_bloc.dart';

import '../widgets/goal_form.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: BlocBuilder<GoalBloc, GoalState>(
        builder: (context, state) {
          if (state is GoalLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GoalLoaded) {
            if (state.goals.isEmpty) {
              return const Center(child: Text('No goals set yet.'));
            }
            return ListView.builder(
              itemCount: state.goals.length,
              itemBuilder: (context, i) {
                final goal = state.goals[i];
                final percent = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
                return Dismissible(
                  key: ValueKey(goal.id),
                  background: Container(color: Colors.red, alignment: Alignment.centerLeft, child: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(Icons.delete, color: Colors.white))),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) => context.read<GoalBloc>().add(DeleteGoal(goal.id!)),
                  child: ListTile(
                    title: Text(goal.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(value: percent, minHeight: 8, backgroundColor: Colors.grey[200], color: Colors.teal),
                        Text('${(percent * 100).toStringAsFixed(0)}% of ₹${goal.targetAmount.toStringAsFixed(0)}'),
                        if (goal.deadline != null) Text('Deadline: ${goal.deadline!.toLocal().toString().split(' ')[0]}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => GoalForm(editGoal: goal),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is GoalError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const GoalForm(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
