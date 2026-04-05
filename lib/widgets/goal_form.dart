import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/goal.dart';
import '../blocs/goal_bloc.dart';

class GoalForm extends StatefulWidget {
  final Goal? editGoal;
  const GoalForm({super.key, this.editGoal});

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  late double _targetAmount;
  late double _currentAmount;
  String _name = '';
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    if (widget.editGoal != null) {
      _targetAmount = widget.editGoal!.targetAmount;
      _currentAmount = widget.editGoal!.currentAmount;
      _name = widget.editGoal!.name;
      _deadline = widget.editGoal!.deadline;
    } else {
      _targetAmount = 0;
      _currentAmount = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.editGoal == null ? 'Add Goal' : 'Edit Goal', style: Theme.of(context).textTheme.titleMedium),
                TextFormField(
                  initialValue: widget.editGoal?.targetAmount.toString(),
                  decoration: const InputDecoration(labelText: 'Target Amount'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter target amount' : null,
                  onSaved: (v) => _targetAmount = double.tryParse(v ?? '') ?? 0,
                ),
                TextFormField(
                  initialValue: widget.editGoal?.currentAmount.toString() ?? '0',
                  decoration: const InputDecoration(labelText: 'Current Amount'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter current amount' : null,
                  onSaved: (v) => _currentAmount = double.tryParse(v ?? '') ?? 0,
                ),
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Goal Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Enter goal name' : null,
                  onSaved: (v) => _name = v ?? '',
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Deadline: ${_deadline != null ? _deadline!.toLocal().toString().split(' ')[0] : 'None'}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _deadline ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _deadline = picked);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      final goal = Goal(
                        id: widget.editGoal?.id,
                        targetAmount: _targetAmount,
                        currentAmount: _currentAmount,
                        name: _name,
                        deadline: _deadline,
                      );
                      if (widget.editGoal == null) {
                        context.read<GoalBloc>().add(AddGoal(goal));
                      } else {
                        context.read<GoalBloc>().add(UpdateGoal(goal));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.editGoal == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
