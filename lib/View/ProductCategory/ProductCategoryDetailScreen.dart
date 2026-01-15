import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/ProductCategory/ProductCategoryBloc.dart';
import '../../Bloc/ProductCategory/ProductCategoryEvent.dart';
import '../../Bloc/ProductCategory/ProductCategoryState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/Buttons/RedButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Component/Cards/InfoCard.dart';
import '../../Styles/Color.dart';
import 'UpdateProductCategoryScreen.dart';

class ProductCategoryDetailScreen extends StatefulWidget {
  final String productCategoryId;

  const ProductCategoryDetailScreen({super.key, required this.productCategoryId});

  @override
  State<ProductCategoryDetailScreen> createState() => _ProductCategoryDetailScreenState();
}

class _ProductCategoryDetailScreenState extends State<ProductCategoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCategoryBloc>().add(LoadProductCategoryById(widget.productCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Product Category Details",
      onBackPressed: () {
        final bloc = context.read<ProductCategoryBloc>();
        Navigator.of(context).pop();
        bloc.add(LoadProductCategory());
      },
      body: BlocConsumer<ProductCategoryBloc, ProductCategoryState>(
        listener: (context, state) {
          if (state is ProductCategoryDeleted) {
            SuccessSnackBar.show(context, message: "Product Category Deleted Successfully!");
            context.read<ProductCategoryBloc>().add(LoadProductCategory());
            Navigator.pop(context);
          }

          if (state is ProductCategoryUpdated) {
            SuccessSnackBar.show(context, message: "Product Category Updated Successfully");
            context.read<ProductCategoryBloc>().add(LoadProductCategoryById(widget.productCategoryId));
          }

          if (state is ProductCategoryError) {
            WarningSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductCategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductCategoryLoadedSingle) {
            final category = state.productCategory;

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
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "Code: ${category.code}",
                                          style: AppText.BodyText().copyWith(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (category.deleted) ...[
                                        const SizedBox(width: 8),
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
                                    ],
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
                    icon: Icons.code_outlined,
                    title: "Category Code",
                    value: category.code,
                  ),
                  const SizedBox(height: 12),

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

                  const SizedBox(height: 28),

                  // Audit Information (if available)
                  if (category.created_by_id != null && category.created_by_id!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Audit Information",
                          style: AppText.SubHeadingText(),
                        ),
                        const SizedBox(height: 16),
                        InfoCard(
                          icon: Icons.person_outlined,
                          title: "Created By",
                          value: category.created_by_id!,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),

                  if (category.updated_by_id != null && category.updated_by_id!.isNotEmpty)
                    InfoCard(
                      icon: Icons.update_outlined,
                      title: "Last Updated By",
                      value: category.updated_by_id!,
                    ),

                  const SizedBox(height: 40),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: RedButton(
                          text: 'Delete Category',
                          onPressed: () {
                            context.read<ProductCategoryBloc>().add(DeleteProductCategory(category.id));
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
                                builder: (context) => UpdateProductCategoryScreen(
                                  productCategoryId: category.id,
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

          if (state is ProductCategoryError) {
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
                      context.read<ProductCategoryBloc>().add(LoadProductCategoryById(widget.productCategoryId));
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