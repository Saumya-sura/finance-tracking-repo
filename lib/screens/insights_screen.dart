import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction_bloc.dart';
import '../models/transaction.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('No data for insights.'));
            }
            final txs = state.transactions;
            final now = DateTime.now();
            final thisWeek = txs.where((tx) => tx.date.isAfter(now.subtract(const Duration(days: 7)))).toList();
            final lastWeek = txs.where((tx) => tx.date.isAfter(now.subtract(const Duration(days: 14))) && tx.date.isBefore(now.subtract(const Duration(days: 7)))).toList();
            final byCategory = <String, double>{};
            for (var tx in txs) {
              if (tx.type == 'expense') {
                byCategory[tx.category] = (byCategory[tx.category] ?? 0) + tx.amount;
              }
            }
            String topCategory = '';
            double topAmount = 0;
            byCategory.forEach((cat, amt) {
              if (amt > topAmount) {
                topAmount = amt;
                topCategory = cat;
              }
            });
            double thisWeekSpent = thisWeek.where((tx) => tx.type == 'expense').fold(0.0, (a, b) => a + b.amount);
            double lastWeekSpent = lastWeek.where((tx) => tx.type == 'expense').fold(0.0, (a, b) => a + b.amount);
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: ListView(
                key: ValueKey(txs.length),
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    title: const Text('Highest Spending Category'),
                    subtitle: Text(topCategory.isNotEmpty ? '$topCategory (₹${topAmount.toStringAsFixed(2)})' : 'N/A'),
                  ),
                  ListTile(
                    title: const Text('This Week vs Last Week'),
                    subtitle: Text('This week: ₹${thisWeekSpent.toStringAsFixed(2)}\nLast week: ₹${lastWeekSpent.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: const Text('Spending by Category'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: byCategory.entries.map((e) => Text('${e.key}: ₹${e.value.toStringAsFixed(2)}')).toList(),
                    ),
                  ),
                  ListTile(
                    title: const Text('Frequent Transaction Type'),
                    subtitle: Text(_mostFrequentType(txs)),
                  ),
                ],
              ),
            );
          } else if (state is TransactionError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }

  String _mostFrequentType(List<Transaction> txs) {
    final typeCount = <String, int>{};
    for (var tx in txs) {
      typeCount[tx.type] = (typeCount[tx.type] ?? 0) + 1;
    }
    if (typeCount.isEmpty) return 'N/A';
    return typeCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
