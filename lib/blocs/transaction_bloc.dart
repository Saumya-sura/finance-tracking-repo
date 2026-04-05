import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/transaction.dart' as app_tx;
import '../data/transaction_repository.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;
  TransactionBloc(this.repository) : super(TransactionLoading()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<FilterTransactions>(_onFilterTransactions);
  }

  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final txs = await repository.getTransactions();
      emit(TransactionLoaded(txs));
    } catch (_) {
      emit(TransactionError('Failed to load transactions'));
    }
  }

  Future<void> _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) async {
    if (state is TransactionLoaded) {
      await repository.insertTransaction(event.transaction);
      add(LoadTransactions());
    }
  }

  Future<void> _onUpdateTransaction(UpdateTransaction event, Emitter<TransactionState> emit) async {
    if (state is TransactionLoaded) {
      await repository.updateTransaction(event.transaction);
      add(LoadTransactions());
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) async {
    if (state is TransactionLoaded) {
      await repository.deleteTransaction(event.id);
      add(LoadTransactions());
    }
  }

  Future<void> _onFilterTransactions(FilterTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final txs = await repository.filterTransactions(type: event.type, category: event.category);
      emit(TransactionLoaded(txs));
    } catch (_) {
      emit(TransactionError('Failed to filter transactions'));
    }
  }
}
