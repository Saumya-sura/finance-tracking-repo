import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/transaction.dart';
import '../blocs/transaction_bloc.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? editTx;
  const TransactionForm({super.key, this.editTx});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  late double _amount;
  String _type = 'expense';
  String _category = '';
  DateTime _date = DateTime.now();
  String _note = '';

  final List<String> _categories = [
    'Food', 'Transport', 'Shopping', 'Bills', 'Salary', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editTx != null) {
      _amount = widget.editTx!.amount;
      _type = widget.editTx!.type;
      _category = widget.editTx!.category;
      _date = widget.editTx!.date;
      _note = widget.editTx!.note ?? '';
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
                Text(widget.editTx == null ? 'Add Transaction' : 'Edit Transaction', style: Theme.of(context).textTheme.titleMedium),
                TextFormField(
                  initialValue: widget.editTx?.amount.toString(),
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Enter amount' : null,
                  onSaved: (v) => _amount = double.tryParse(v ?? '') ?? 0,
                ),
                DropdownButtonFormField<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'income', child: Text('Income')),
                    DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  ],
                  onChanged: (v) => setState(() => _type = v ?? 'expense'),
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                DropdownButtonFormField<String>(
                  value: _category.isNotEmpty ? _category : null,
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _category = v ?? ''),
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) => v == null || v.isEmpty ? 'Select category' : null,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Date: ${_date.toLocal().toString().split(' ')[0]}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                ),
                TextFormField(
                  initialValue: _note,
                  decoration: const InputDecoration(labelText: 'Note'),
                  onSaved: (v) => _note = v ?? '',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      final tx = Transaction(
                        id: widget.editTx?.id,
                        amount: _amount,
                        type: _type,
                        category: _category,
                        date: _date,
                        note: _note,
                      );
                      if (widget.editTx == null) {
                        context.read<TransactionBloc>().add(AddTransaction(tx));
                      } else {
                        context.read<TransactionBloc>().add(UpdateTransaction(tx));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.editTx == null ? 'Add' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
