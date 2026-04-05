import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int? id;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  final String? note;

  const Transaction({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      amount: map['amount'] as double,
      type: map['type'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, amount, type, category, date, note];
}
