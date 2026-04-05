import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/insights_screen.dart';
import 'blocs/transaction_bloc.dart';
import 'blocs/goal_bloc.dart';
import 'data/transaction_repository.dart';
import 'data/goal_repository.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	final dbPath = await getDatabasesPath();
	final path = join(dbPath, 'finance_app2.db');
	await deleteDatabase(path); // TEMP: Delete old DB to force table creation
	print('Database deleted at $path');
	runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
	const FinanceApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MultiRepositoryProvider(
			providers: [
				RepositoryProvider(create: (_) => TransactionRepository()),
				RepositoryProvider(create: (_) => GoalRepository()),
			],
			child: MultiBlocProvider(
				providers: [
					BlocProvider(create: (context) => TransactionBloc(context.read<TransactionRepository>())..add(LoadTransactions())),
					BlocProvider(create: (context) => GoalBloc(context.read<GoalRepository>())..add(LoadGoals())),
				],
				child: MaterialApp(
					title: 'Finance Companion',
					theme: ThemeData(
						colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
						useMaterial3: true,
						visualDensity: VisualDensity.adaptivePlatformDensity,
					),
					home: const MainNavigation(),
				),
			),
		);
	}
}

class MainNavigation extends StatefulWidget {
	const MainNavigation({super.key});

	@override
	State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
	int _selectedIndex = 0;
	final List<Widget> _screens = const [
		DashboardScreen(),
		TransactionsScreen(),
		GoalsScreen(),
		InsightsScreen(),
	];

	void _onItemTapped(int index) {
		setState(() {
			_selectedIndex = index;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: AnimatedSwitcher(
				duration: const Duration(milliseconds: 400),
				child: _screens[_selectedIndex],
				transitionBuilder: (child, animation) => FadeTransition(
					opacity: animation,
					child: child,
				),
			),
			bottomNavigationBar: NavigationBar(
				selectedIndex: _selectedIndex,
				onDestinationSelected: _onItemTapped,
				destinations: const [
					NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
					NavigationDestination(icon: Icon(Icons.list_alt), label: 'Transactions'),
					NavigationDestination(icon: Icon(Icons.flag), label: 'Goals'),
					NavigationDestination(icon: Icon(Icons.insights), label: 'Insights'),
				],
			),
		);
	}
}
