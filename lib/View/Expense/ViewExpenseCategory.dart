// lib/Screens/Expense/ViewExpenseScreen.dart
import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Expense/ExpenseBloc.dart';
import '../../Bloc/Expense/ExpenseState.dart';
import '../../Bloc/Expense/ExpenseEvent.dart';
import '../../Model/Expense/ExpenseModel.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'ExpenseDetailScreen.dart';

class ViewExpenseScreen extends StatefulWidget {
  const ViewExpenseScreen({super.key});

  @override
  State<ViewExpenseScreen> createState() => _ViewExpenseScreenState();
}

class _ViewExpenseScreenState extends State<ViewExpenseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpense());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Expenses",
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is ExpenseLoaded) {
            final List<ExpenseModel> expenses = state.expenses;

            if (expenses.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExpenseBloc>().add(LoadExpense());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final expense = expenses[index];

                  // Status color
                  Color statusColor;
                  switch (expense.status) {
                    case 'PAID':
                      statusColor = Colors.green;
                      break;
                    case 'PENDING':
                      statusColor = Colors.orange;
                      break;
                    case 'CANCELLED':
                      statusColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.grey;
                  }

                  return ViewCard(
                    title: expense.name,
                    subtitle: "${expense.categoryName ?? 'No Category'}\n৳${expense.amount}",
                    icon: Icons.money_off_outlined,
                    dateText: "${expense.created_date}",
                    // status: expense.status,
                    // statusColor: statusColor,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpenseDetailScreen(expenseId: expense.id),
                        ),
                      );
                      context.read<ExpenseBloc>().add(LoadExpense());
                    },
                  );
                },
              ),
            );
          } else if (state is ExpenseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error Loading Expenses",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExpenseBloc>().add(LoadExpense());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No expenses available"),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.money_off_outlined,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Expenses Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Create your first expense to get started",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}