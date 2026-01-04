// lib/Screens/ExpenseCategory/ViewExpenseCategoryScreen.dart
import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryEventBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryStateBloc.dart';
import '../../Model/ExpenseCategory/ExpenseCategoryModel.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'ExpenseCategoryDetailScreen.dart';

class ViewExpenseCategoryScreen extends StatefulWidget {
  const ViewExpenseCategoryScreen({super.key});

  @override
  State<ViewExpenseCategoryScreen> createState() => _ViewExpenseCategoryScreenState();
}

class _ViewExpenseCategoryScreenState extends State<ViewExpenseCategoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseCategoryBloc>().add(LoadExpenseCategory());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Expense Categories",
      body: BlocBuilder<ExpenseCategoryBloc, ExpenseCategoryState>(
        builder: (context, state) {
          if (state is ExpenseCategoryLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is ExpenseCategoryLoaded) {
            final List<ExpenseCategoryModel> categories = state.expenseCategories;

            if (categories.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExpenseCategoryBloc>().add(LoadExpenseCategory());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return ViewCard(
                    title: category.name,
                    subtitle: "Created: ${category.created_date}",
                    icon: Icons.category_outlined,
                    dateText: "${category.created_date}",
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExpenseCategoryDetailScreen(expenseCategoryId: category.id),
                        ),
                      );
                      context.read<ExpenseCategoryBloc>().add(LoadExpenseCategory());
                    },
                  );
                },
              ),
            );
          } else if (state is ExpenseCategoryError) {
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
                    "Error Loading Categories",
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
                      context.read<ExpenseCategoryBloc>().add(LoadExpenseCategory());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No categories available"),
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
              Icons.category_outlined,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No Expense Categories Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Create your first expense category to get started",
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