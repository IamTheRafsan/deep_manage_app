import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/ProductCategory/ProductCategoryBloc.dart';
import '../../Bloc/ProductCategory/ProductCategoryEvent.dart';
import '../../Bloc/ProductCategory/ProductCategoryState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';

class UpdateProductCategoryScreen extends StatefulWidget {
  final String productCategoryId;

  const UpdateProductCategoryScreen({super.key, required this.productCategoryId});

  @override
  State<UpdateProductCategoryScreen> createState() => _UpdateProductCategoryScreenState();
}

class _UpdateProductCategoryScreenState extends State<UpdateProductCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductCategoryBloc>().add(LoadProductCategoryById(widget.productCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update Product Category",
      body: BlocConsumer<ProductCategoryBloc, ProductCategoryState>(
        listener: (context, state) {
          if (state is ProductCategoryLoadedSingle && !_initialDataLoaded) {
            final category = state.productCategory;
            _nameController.text = category.name;
            _codeController.text = category.code;
            _initialDataLoaded = true;
          }

          if (state is ProductCategoryUpdated) {
            SuccessSnackBar.show(context, message: "Product Category Updated Successfully!");
            Navigator.pop(context);
          }

          if (state is ProductCategoryError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is ProductCategoryLoading && !_initialDataLoaded) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Loading category data...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Category Information",
                  style: AppText.SubHeadingText(),
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _nameController,
                  label: 'Category Name *',
                ),
                const SizedBox(height: 16),

                TextInputField(
                  controller: _codeController,
                  label: 'Category Code *',
                ),
                const SizedBox(height: 8),
                Text(
                  "Note: Category code must be unique",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    onPressed: _isLoading ? null : _updateProductCategory,
                    text: _isLoading ? 'Updating...' : 'Update Category',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateProductCategory() async {
    if (_nameController.text.isEmpty || _codeController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please fill all required fields");
      return;
    }

    if (_codeController.text.trim().isEmpty) {
      WarningSnackBar.show(context, message: "Category code cannot be empty");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final updatedData = {
      "name": _nameController.text.trim(),
      "code": _codeController.text.trim(),
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<ProductCategoryBloc>().add(UpdateProductCategory(widget.productCategoryId, updatedData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }
}