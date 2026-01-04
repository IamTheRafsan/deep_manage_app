import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Expense/ExpenseBloc.dart';
import '../../Bloc/Expense/ExpenseEvent.dart';
import '../../Bloc/Expense/ExpenseState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateExpenseScreen.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final String expenseId;

  const ExpenseDetailScreen({super.key, required this.expenseId});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(LoadExpenseById(widget.expenseId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Expense Details",
      onBackPressed: () {
        final bloc = context.read<ExpenseBloc>();
        Navigator.of(context).pop();
        bloc.add(LoadExpense());
      },
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseDeleted) {
            SuccessSnackBar.show(context, message: "Expense Deleted Successfully!");
            context.read<ExpenseBloc>().add(LoadExpense());
            Navigator.pop(context);
          }

          if (state is ExpenseUpdated) {
            SuccessSnackBar.show(context, message: "Expense Updated Successfully");
            context.read<ExpenseBloc>().add(LoadExpenseById(widget.expenseId));
          }

          if (state is ExpenseError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ExpenseLoadedSingle) {
            final expense = state.expense;

            // Determine status color
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expense Header Card
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
                                Icons.money_off_outlined,
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
                                    expense.name,
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      expense.status,
                                      style: AppText.BodyText().copyWith(
                                        color: statusColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Amount: ৳${expense.amount}",
                          style: AppText.HeadingText().copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Expense Information Section
                  Text(
                    "Expense Details",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.category_outlined,
                    title: "Category",
                    value: expense.categoryName ?? 'N/A',
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.description_outlined,
                    title: "Description",
                    value: expense.description.isNotEmpty ? expense.description : 'No description',
                  ),

                  const SizedBox(height: 28),

                  // Related Information Section
                  Text(
                    "Related Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  if (expense.warehouseName != null && expense.warehouseName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.warehouse_outlined,
                      title: "Warehouse",
                      value: expense.warehouseName!,
                    ),
                  const SizedBox(height: 12),

                  if (expense.outletName != null && expense.outletName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.store_outlined,
                      title: "Outlet",
                      value: expense.outletName!,
                    ),
                  const SizedBox(height: 12),

                  if (expense.userName != null && expense.userName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.person_outlined,
                      title: "Created By",
                      value: expense.userName!,
                    ),

                  const SizedBox(height: 28),

                  // Audit Information
                  Text(
                    "Audit Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  InfoCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Created Date",
                    value: "${expense.created_date} at ${expense.created_time}",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.update_outlined,
                    title: "Last Updated",
                    value: "${expense.updated_date} at ${expense.updated_time}",
                  ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Delete Expense',
                          onPressed: () {
                            context.read<ExpenseBloc>().add(DeleteExpense(expense.id));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update Expense',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateExpenseScreen(
                                  expenseId: expense.id,
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

          if (state is ExpenseError) {
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
                    "Error Loading Expense",
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
                      context.read<ExpenseBloc>().add(LoadExpenseById(widget.expenseId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No expense information available"),
          );
        },
      ),
    );
  }
}