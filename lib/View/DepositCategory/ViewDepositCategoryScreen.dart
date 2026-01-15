import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/DepositCategory/DepositCategoryBloc.dart';
import '../../Bloc/DepositCategory/DepositCategoryState.dart';
import '../../Bloc/DepositCategory/DepositCategoryEvent.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'DepositCategoryDetailScreen.dart';

class ViewDepositCategoryScreen extends StatefulWidget {
  const ViewDepositCategoryScreen({super.key});

  @override
  State<ViewDepositCategoryScreen> createState() => _ViewDepositCategoryScreenState();
}

class _ViewDepositCategoryScreenState extends State<ViewDepositCategoryScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<DepositCategoryBloc>().add(LoadDepositCategory(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Deposit Categories",
      body: BlocBuilder<DepositCategoryBloc, DepositCategoryState>(
        builder: (context, state) {
          if (state is DepositCategoryLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is DepositCategoryLoaded) {
            final categories = state.depositCategories;

            if (categories.isEmpty) {
              return _buildEmptyState(_showDeleted);
            }

            return Column(
              children: [
                if (_showDeleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.orange.shade50,
                    child: Row(
                      children: [
                        Icon(Icons.info, size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Showing deleted categories",
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<DepositCategoryBloc>().add(LoadDepositCategory(showDeleted: _showDeleted));
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
                          //isDeleted: category.deleted,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DepositCategoryDetailScreen(depositCategoryId: category.id),
                              ),
                            );
                            context.read<DepositCategoryBloc>().add(LoadDepositCategory(showDeleted: _showDeleted));
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is DepositCategoryError) {
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
                      context.read<DepositCategoryBloc>().add(LoadDepositCategory(showDeleted: _showDeleted));
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

  Widget _buildEmptyState(bool showDeleted) {
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
              showDeleted ? Icons.delete_outline : Icons.category_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Categories Found" : "No Deposit Categories Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted categories to show"
                : "Create your first deposit category to get started",
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