part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}
class AddTransaction extends TransactionEvent {
  final app_tx.Transaction transaction;
  const AddTransaction(this.transaction);
  @override
  List<Object?> get props => [transaction];
}
class UpdateTransaction extends TransactionEvent {
  final app_tx.Transaction transaction;
  const UpdateTransaction(this.transaction);
  @override
  List<Object?> get props => [transaction];
}
class DeleteTransaction extends TransactionEvent {
  final int id;
  const DeleteTransaction(this.id);
  @override
  List<Object?> get props => [id];
}
class FilterTransactions extends TransactionEvent {
  final String? type;
  final String? category;
  const FilterTransactions({this.type, this.category});
  @override
  List<Object?> get props => [type, category];
}
