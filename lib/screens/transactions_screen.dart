import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction_bloc.dart';

import '../widgets/transaction_form.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? selectedType;
    String? selectedCategory;
    String searchText = '';
    final List<String> categories = [
      'Food', 'Transport', 'Shopping', 'Bills', 'Salary', 'Other'
    ];
    final typeOptions = ['All', 'income', 'expense'];

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: AppBar(title: const Text('Transactions')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedType ?? 'All',
                        items: typeOptions.map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type[0].toUpperCase() + type.substring(1)),
                        )).toList(),
                        onChanged: (val) {
                          setState(() => selectedType = val == 'All' ? null : val);
                          context.read<TransactionBloc>().add(FilterTransactions(type: selectedType, category: selectedCategory));
                        },
                        hint: const Text('Type'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        items: [null, ...categories].map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat ?? 'All'),
                        )).toList(),
                        onChanged: (val) {
                          setState(() => selectedCategory = val);
                          context.read<TransactionBloc>().add(FilterTransactions(type: selectedType, category: selectedCategory));
                        },
                        hint: const Text('Category'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear Filters',
                      onPressed: () {
                        setState(() {
                          selectedType = null;
                          selectedCategory = null;
                          searchText = '';
                        });
                        context.read<TransactionBloc>().add(LoadTransactions());
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search (category or note)',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (val) {
                    setState(() => searchText = val);
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TransactionLoaded) {
                      final filtered = state.transactions.where((tx) {
                        final matchesSearch = searchText.isEmpty ||
                          tx.category.toLowerCase().contains(searchText.toLowerCase()) ||
                          (tx.note?.toLowerCase().contains(searchText.toLowerCase()) ?? false);
                        return matchesSearch;
                      }).toList();
                      if (filtered.isEmpty) {
                        return const Center(child: Text('No transactions yet.'));
                      }
                      return ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final tx = filtered[i];
                          return Dismissible(
                            key: ValueKey(tx.id),
                            background: Container(color: Colors.red, alignment: Alignment.centerLeft, child: const Padding(padding: EdgeInsets.only(left: 16), child: Icon(Icons.delete, color: Colors.white)) ),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (_) => context.read<TransactionBloc>().add(DeleteTransaction(tx.id!)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: tx.type == 'income' ? Colors.green : Colors.red,
                                child: Icon(tx.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
                              ),
                              title: Text('${tx.category} - ₹${tx.amount.toStringAsFixed(2)}'),
                              subtitle: Text('${tx.date.toLocal().toString().split(' ')[0]}${tx.note != null && tx.note!.isNotEmpty ? '\n${tx.note}' : ''}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => TransactionForm(editTx: tx),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is TransactionError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const TransactionForm(),
            ),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
