import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final int? id;
  final double targetAmount;
  final double currentAmount;
  final String name;
  final DateTime? deadline;

  const Goal({
    this.id,
    required this.targetAmount,
    required this.currentAmount,
    required this.name,
    this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'name': name,
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as int?,
      targetAmount: (map['targetAmount'] as num).toDouble(),
      currentAmount: (map['currentAmount'] as num).toDouble(),
      name: map['name'] as String,
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }

  @override
  List<Object?> get props => [id, targetAmount, currentAmount, name, deadline];
}
