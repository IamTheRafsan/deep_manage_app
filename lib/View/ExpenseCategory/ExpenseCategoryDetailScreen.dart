// lib/Screens/ExpenseCategory/ExpenseCategoryDetailScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryEventBloc.dart';
import '../../Bloc/ExpenseCategory/ExpenseCategoryStateBloc.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateExpenseCategoryScreen.dart';

class ExpenseCategoryDetailScreen extends StatefulWidget {
  final String expenseCategoryId;

  const ExpenseCategoryDetailScreen({super.key, required this.expenseCategoryId});

  @override
  State<ExpenseCategoryDetailScreen> createState() => _ExpenseCategoryDetailScreenState();
}

class _ExpenseCategoryDetailScreenState extends State<ExpenseCategoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseCategoryBloc>().add(LoadExpenseCategoryById(widget.expenseCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Expense Category Details",
      onBackPressed: () {
        final bloc = context.read<ExpenseCategoryBloc>();
        Navigator.of(context).pop();
        bloc.add(LoadExpenseCategory());
      },
      body: BlocConsumer<ExpenseCategoryBloc, ExpenseCategoryState>(
        listener: (context, state) {
          if (state is ExpenseCategoryDeleted) {
            SuccessSnackBar.show(context, message: "Expense Category Deleted Successfully!");
            context.read<ExpenseCategoryBloc>().add(LoadExpenseCategory());
            Navigator.pop(context);
          }

          if (state is ExpenseCategoryUpdated) {
            SuccessSnackBar.show(context, message: "Expense Category Updated Successfully");
            context.read<ExpenseCategoryBloc>().add(LoadExpenseCategoryById(widget.expenseCategoryId));
          }

          if (state is ExpenseCategoryError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is ExpenseCategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ExpenseCategoryLoadedSingle) {
            final category = state.expenseCategory;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color.cardBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: color.primaryColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.category_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category.name,
                                    style: AppText.HeadingText(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Category Information Section
                  Text(
                    "Category Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Created Date",
                    value: "${category.created_date} at ${category.created_time}",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.update_outlined,
                    title: "Last Updated",
                    value: "${category.updated_date} at ${category.updated_time}",
                  ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Delete Category',
                          onPressed: () {
                            context.read<ExpenseCategoryBloc>().add(DeleteExpenseCategory(category.id));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update Category',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateExpenseCategoryScreen(
                                  expenseCategoryId: category.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          if (state is ExpenseCategoryError) {
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
                    "Error Loading Category",
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
                      context.read<ExpenseCategoryBloc>().add(LoadExpenseCategoryById(widget.expenseCategoryId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No category information available"),
          );
        },
      ),
    );
  }
}