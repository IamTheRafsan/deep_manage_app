import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Product/ProductBloc.dart';
import '../../Bloc/Product/ProductEvent.dart';
import '../../Bloc/Product/ProductState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateProductScreen.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductById(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Product Details",
      onBackPressed: () {
        final bloc = context.read<ProductBloc>();
        Navigator.of(context).pop();
        bloc.add(LoadProduct());
      },
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductDeleted) {
            SuccessSnackBar.show(context, message: "Product Deleted Successfully!");
            context.read<ProductBloc>().add(LoadProduct());
            Navigator.pop(context);
          }

          if (state is ProductUpdated) {
            SuccessSnackBar.show(context, message: "Product Updated Successfully");
            context.read<ProductBloc>().add(LoadProductById(widget.productId));
          }

          if (state is ProductError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductLoadedSingle) {
            final product = state.product;

            // Determine status color
            Color statusColor;
            switch (product.status) {
              case 'AVAILABLE':
                statusColor = Colors.green;
                break;
              case 'OUT_OF_STOCK':
                statusColor = Colors.orange;
                break;
              case 'LOW_STOCK':
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
                  // Product Header Card
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
                                Icons.shopping_bag_outlined,
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
                                    product.name,
                                    style: AppText.HeadingText(),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          product.status,
                                          style: AppText.BodyText().copyWith(
                                            color: statusColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "Code: ${product.code}",
                                          style: AppText.BodyText().copyWith(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Price: ৳${product.price}",
                                    style: AppText.SubHeadingText().copyWith(
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Stock: ${product.stock} units",
                                    style: AppText.BodyText(),
                                  ),
                                ],
                              ),
                            ),
                            if (product.deleted)
                              Container(
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Product Information Section
                  Text(
                    "Product Details",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  if (product.description != null && product.description!.isNotEmpty)
                    InfoCard(
                      icon: Icons.description_outlined,
                      title: "Description",
                      value: product.description!,
                    ),
                  const SizedBox(height: 12),

                  if (product.brandName != null && product.brandName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.branding_watermark_outlined,
                      title: "Brand",
                      value: product.brandName!,
                    ),
                  const SizedBox(height: 12),

                  if (product.categoryName != null && product.categoryName!.isNotEmpty)
                    InfoCard(
                      icon: Icons.category_outlined,
                      title: "Category",
                      value: product.categoryName!,
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
                    value: "${product.created_date} at ${product.created_time}",
                  ),
                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.update_outlined,
                    title: "Last Updated",
                    value: "${product.updated_date} at ${product.updated_time}",
                  ),

                  if (product.created_by_id != null && product.created_by_id!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.person_outlined,
                          title: "Created By",
                          value: product.created_by_id!,
                        ),
                      ],
                    ),

                  if (product.updated_by_id != null && product.updated_by_id!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        InfoCard(
                          icon: Icons.update_outlined,
                          title: "Last Updated By",
                          value: product.updated_by_id!,
                        ),
                      ],
                    ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Delete Product',
                          onPressed: () {
                            context.read<ProductBloc>().add(DeleteProduct(product.id));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Update Product',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProductScreen(
                                  productId: product.id,
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

          if (state is ProductError) {
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
                    "Error Loading Product",
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
                      context.read<ProductBloc>().add(LoadProductById(widget.productId));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text("No product information available"),
          );
        },
      ),
    );
  }
}