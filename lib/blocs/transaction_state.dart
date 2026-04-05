part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionLoading extends TransactionState {}
class TransactionLoaded extends TransactionState {
  final List<app_tx.Transaction> transactions;
  const TransactionLoaded(this.transactions);
  @override
  List<Object?> get props => [transactions];
}
class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
  @override
  List<Object?> get props => [message];
}
