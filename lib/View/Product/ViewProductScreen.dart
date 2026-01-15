import 'package:deep_manage_app/Component/Cards/ViewCard.dart';
import 'package:deep_manage_app/Component/CircularIndicator/CustomCircularIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Product/ProductBloc.dart';
import '../../Bloc/Product/ProductState.dart';
import '../../Bloc/Product/ProductEvent.dart';
import '../../Model/Product/ProductModel.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import 'ProductDetailScreen.dart';

class ViewProductScreen extends StatefulWidget {
  const ViewProductScreen({super.key});

  @override
  State<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends State<ViewProductScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProduct(showDeleted: _showDeleted));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Products",
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CustomCircularIndicator(),
            );
          } else if (state is ProductLoaded) {
            final products = state.products;

            if (products.isEmpty) {
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
                            "Showing deleted products",
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
                      context.read<ProductBloc>().add(LoadProduct(showDeleted: _showDeleted));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return _buildProductCard(product);
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ProductError) {
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
                    "Error Loading Products",
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
                      context.read<ProductBloc>().add(LoadProduct(showDeleted: _showDeleted));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No products available"),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    // Determine status color
    Color statusColor;
    switch (product.status) {
      case 'ACTIVE':
        statusColor = Colors.green;
        break;
      case 'INACTIVE':
        statusColor = Colors.orange;
        break;
      case 'DISCONTINUED':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return ViewCard(
        title: product.name,
        subtitle: "Code: ${product.code} | Price: ${product.price}",
        icon: Icons.shopping_bag_rounded,
        dateText: "Created: ${product.created_date}",
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
            builder: (_) => ProductDetailScreen(productId: product.id),
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
              showDeleted ? Icons.delete_outline : Icons.shopping_bag_outlined,
              size: 64,
              color: showDeleted ? Colors.red : Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showDeleted ? "No Deleted Products Found" : "No Products Found",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            showDeleted
                ? "There are no deleted products to show"
                : "Create your first product to get started",
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