import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/DepositCategory/DepositCategoryBloc.dart';
import '../../Bloc/DepositCategory/DepositCategoryEvent.dart';
import '../../Bloc/DepositCategory/DepositCategoryState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateDepositCategoryScreen.dart';

class DepositCategoryDetailScreen extends StatefulWidget {
  final String depositCategoryId;

  const DepositCategoryDetailScreen({super.key, required this.depositCategoryId});

  @override
  State<DepositCategoryDetailScreen> createState() => _DepositCategoryDetailScreenState();
}

class _DepositCategoryDetailScreenState extends State<DepositCategoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DepositCategoryBloc>().add(LoadDepositCategoryById(widget.depositCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Deposit Category Details",
      onBackPressed: () {
        final bloc = context.read<DepositCategoryBloc>();
        Navigator.of(context).pop();
        bloc.add(LoadDepositCategory());
      },
      body: BlocConsumer<DepositCategoryBloc, DepositCategoryState>(
        listener: (context, state) {
          if (state is DepositCategoryDeleted) {
            SuccessSnackBar.show(context, message: "Deposit Category Deleted Successfully!");
            context.read<DepositCategoryBloc>().add(LoadDepositCategory());
            Navigator.pop(context);
          }

          if (state is DepositCategoryUpdated) {
            SuccessSnackBar.show(context, message: "Deposit Category Updated Successfully");
            context.read<DepositCategoryBloc>().add(LoadDepositCategoryById(widget.depositCategoryId));
          }

          if (state is DepositCategoryError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is DepositCategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DepositCategoryLoadedSingle) {
            final category = state.depositCategory;

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
                                  if (category.deleted)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "DELETED",
                                        style: AppText.BodyText().copyWith(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
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
                            context.read<DepositCategoryBloc>().add(DeleteDepositCategory(category.id));
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
                                builder: (context) => UpdateDepositCategoryScreen(
                                  depositCategoryId: category.id,
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

          if (state is DepositCategoryError) {
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
                      context.read<DepositCategoryBloc>().add(LoadDepositCategoryById(widget.depositCategoryId));
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