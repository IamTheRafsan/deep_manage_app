import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/ProductCategory/ProductCategoryBloc.dart';
import '../../Bloc/ProductCategory/ProductCategoryState.dart';
import '../../Bloc/ProductCategory/ProductCategoryEvent.dart';
import '../../Model/ProductCategory/ProductCategoryModel.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'ProductCategoryDetailScreen.dart';

class ViewProductCategoryScreen extends StatefulWidget {
  const ViewProductCategoryScreen({super.key});

  @override
  State<ViewProductCategoryScreen> createState() => _ViewProductCategoryScreenState();
}

class _ViewProductCategoryScreenState extends State<ViewProductCategoryScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductCategoryBloc>().add(LoadProductCategory(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Product Categories",
      body: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
        builder: (context, state) {
          if (state is ProductCategoryLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is ProductCategoryLoaded) {
            final categories = state.productCategories;

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
                      context.read<ProductCategoryBloc>().add(LoadProductCategory(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return _buildCategoryCard(category);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ProductCategoryError) {
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
                      context.read<ProductCategoryBloc>().add(LoadProductCategory(showDeleted: _showDeleted));
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

  Widget _buildCategoryCard(ProductCategoryModel category) {
    return ViewCard(
        title: category.name,
        subtitle: "Code: ${category.code}",
        dateText: "Created: ${category.created_date}",
        icon: Icons.category_rounded,
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductCategoryDetailScreen(productCategoryId: category.id),
            ),
          );
        }
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
            showDeleted ? "No Deleted Categories Found" : "No Product Categories Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted categories to show"
                : "Create your first product category to get started",
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