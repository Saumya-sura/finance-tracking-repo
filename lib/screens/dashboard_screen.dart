import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/transaction_bloc.dart';
import '../blocs/goal_bloc.dart';
import '../models/transaction.dart';
import '../models/goal.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, txState) {
        return BlocBuilder<GoalBloc, GoalState>(
          builder: (context, goalState) {
            double balance = 0;
            double income = 0;
            double expenses = 0;
            List<Transaction> txs = [];
            List<Goal> goals = [];
            if (txState is TransactionLoaded) {
              txs = txState.transactions;
              for (var tx in txs) {
                if (tx.type == 'income') {
                  income += tx.amount;
                  balance += tx.amount;
                } else {
                  expenses += tx.amount;
                  balance -= tx.amount;
                }
              }
            }
            if (goalState is GoalLoaded) {
              goals = goalState.goals;
            }
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: txState is TransactionLoading || goalState is GoalLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      key: ValueKey(balance + income + expenses),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Current Balance', style: Theme.of(context).textTheme.titleMedium),
                          Text('₹${balance.toStringAsFixed(2)}', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.teal)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _SummaryCard(label: 'Income', value: income, color: Colors.green),
                              _SummaryCard(label: 'Expenses', value: expenses, color: Colors.red),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text('Spending by Category', style: Theme.of(context).textTheme.titleMedium),
                          SizedBox(
                            height: 180,
                            child: _SpendingChart(transactions: txs),
                          ),
                          const SizedBox(height: 24),
                          if (goals.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Savings Progress', style: Theme.of(context).textTheme.titleMedium),
                                ...goals.map((g) => _GoalProgress(goal: g)),
                              ],
                            ),
                        ],
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  const _SummaryCard({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            Text('₹${value.toStringAsFixed(2)}', style: TextStyle(color: color, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class _SpendingChart extends StatelessWidget {
  final List<Transaction> transactions;
  const _SpendingChart({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final data = <String, double>{};
    for (var tx in transactions) {
      if (tx.type == 'expense') {
        data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
      }
    }
    final chartData = data.entries.toList();
    if (chartData.isEmpty) {
      return const Center(child: Text('No expense data'));
    }
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: chartData.map((e) => e.value).fold(0.0, (a, b) => a > b ? a : b) + 10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= chartData.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(chartData[idx].key, style: const TextStyle(fontSize: 12)),
                );
              },
              interval: 1,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(chartData.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: chartData[i].value,
                color: Colors.red,
                width: 18,
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(show: false),
              ),
            ],
            showingTooltipIndicators: [],
          );
        }),
        gridData: FlGridData(show: false),
      ),
    );
  }
}



class _GoalProgress extends StatelessWidget {
  final Goal goal;
  const _GoalProgress({required this.goal});
  @override
  Widget build(BuildContext context) {
    final percent = (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(goal.name, style: Theme.of(context).textTheme.bodyLarge),
          LinearProgressIndicator(value: percent, minHeight: 8, backgroundColor: Colors.grey[200], color: Colors.teal),
          Text('${(percent * 100).toStringAsFixed(0)}% of ₹${goal.targetAmount.toStringAsFixed(0)}'),
        ],
      ),
    );
  }
}
