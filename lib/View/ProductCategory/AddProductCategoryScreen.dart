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
import 'ViewProductCategoryScreen.dart';

class AddProductCategoryScreen extends StatefulWidget {
  const AddProductCategoryScreen({super.key});

  @override
  State<AddProductCategoryScreen> createState() => _AddProductCategoryScreenState();
}

class _AddProductCategoryScreenState extends State<AddProductCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add Product Category",
      body: BlocConsumer<ProductCategoryBloc, ProductCategoryState>(
        listener: (context, state) {
          if (state is ProductCategoryCreated) {
            SuccessSnackBar.show(context, message: "Product Category Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProductCategoryScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is ProductCategoryError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
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
                    onPressed: _isLoading ? null : _createProductCategory,
                    text: _isLoading ? 'Creating...' : 'Create Category',
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

  Future<void> _createProductCategory() async {
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
    final categoryData = {
      "name": _nameController.text.trim(),
      "code": _codeController.text.trim(),
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<ProductCategoryBloc>().add(CreateProductCategory(categoryData));
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