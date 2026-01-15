import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Bloc/Product/ProductBloc.dart';
import '../../Bloc/Product/ProductEvent.dart';
import '../../Bloc/Product/ProductState.dart';
import '../../Bloc/Brand/BrandBloc.dart';
import '../../Bloc/Brand/BrandEvent.dart';
import '../../Bloc/Brand/BrandState.dart';
import '../../Bloc/ProductCategory/ProductCategoryBloc.dart';
import '../../Bloc/ProductCategory/ProductCategoryEvent.dart';
import '../../Bloc/ProductCategory/ProductCategoryState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Model/Brand/BrandModel.dart';
import '../../Model/ProductCategory/ProductCategoryModel.dart';
import 'ViewProductScreen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  List<BrandModel> _brands = [];
  List<ProductCategoryModel> _categories = [];
  bool _loadingBrands = true;
  bool _loadingCategories = true;

  final List<String> _statusOptions = ['AVAILABLE', 'OUT_OF_STOCK', 'LOW_STOCK'];
  String _selectedStatus = 'AVAILABLE';

  String? _selectedBrandId;
  String? _selectedBrandName;
  String? _selectedCategoryId;
  String? _selectedCategoryName;

  late final List<DropdownMenuItem<String>> statusMenuItems = _statusOptions
      .map((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(value),
  ))
      .toList();

  @override
  void initState() {
    super.initState();
    context.read<BrandBloc>().add(LoadBrand());
    context.read<ProductCategoryBloc>().add(LoadProductCategory());
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add New Product",
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductCreated) {
            SuccessSnackBar.show(context, message: "Product Created Successfully!");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewProductScreen(),
                ),
                    (route) => false,
              );
            });
          }

          if (state is ProductError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return MultiBlocListener(
            listeners: [
              BlocListener<BrandBloc, BrandState>(
                listener: (context, brandState) {
                  if (brandState is BrandLoaded) {
                    setState(() {
                      _brands = brandState.brands;
                      _loadingBrands = false;
                    });
                  }
                  if (brandState is BrandError) {
                    setState(() {
                      _loadingBrands = false;
                    });
                    WarningSnackBar.show(context, message: "Failed to load brands");
                  }
                },
              ),
              BlocListener<ProductCategoryBloc, ProductCategoryState>(
                listener: (context, categoryState) {
                  if (categoryState is ProductCategoryLoaded) {
                    setState(() {
                      _categories = categoryState.productCategories;
                      _loadingCategories = false;
                    });
                  }
                  if (categoryState is ProductCategoryError) {
                    setState(() {
                      _loadingCategories = false;
                    });
                    WarningSnackBar.show(context, message: "Failed to load categories");
                  }
                },
              ),
            ],
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Information",
                    style: AppText.SubHeadingText(),
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _nameController,
                    label: 'Product Name *',
                  ),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _codeController,
                    label: 'Product Code *',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Note: Product code must be unique",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: TextInputField(
                          controller: _priceController,
                          label: 'Price *',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextInputField(
                          controller: _stockController,
                          label: 'Stock *',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DropDownInputField<String>(
                    value: _selectedStatus,
                    label: 'Status *',
                    items: statusMenuItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedStatus = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildBrandDropdown(),
                  const SizedBox(height: 16),

                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),

                  TextInputField(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryButton(
                      onPressed: _isLoading ? null : _createProduct,
                      text: _isLoading ? 'Creating...' : 'Create Product',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandDropdown() {
    if (_loadingBrands) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand',
          style: AppText.BodyText(),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedBrandId,
          decoration: InputDecoration(
            labelText: 'Select Brand (Optional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('No Brand'),
            ),
            ..._brands.map((brand) {
              return DropdownMenuItem<String>(
                value: brand.id,
                child: Text(brand.name),
              );
            }).toList(),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedBrandId = newValue;
              if (newValue != null) {
                final selected = _brands.firstWhere((b) => b.id == newValue);
                _selectedBrandName = selected.name;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    if (_loadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppText.BodyText(),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategoryId,
          decoration: InputDecoration(
            labelText: 'Select Category (Optional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('No Category'),
            ),
            ..._categories.map((category) {
              return DropdownMenuItem<String>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
          ],
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategoryId = newValue;
              if (newValue != null) {
                final selected = _categories.firstWhere((c) => c.id == newValue);
                _selectedCategoryName = selected.name;
              }
            });
          },
        ),
      ],
    );
  }

  Future<void> _createProduct() async {
    if (_nameController.text.isEmpty || _codeController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please fill all required fields");
      return;
    }

    if (_codeController.text.trim().isEmpty) {
      WarningSnackBar.show(context, message: "Product code cannot be empty");
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price < 0) {
      WarningSnackBar.show(context, message: "Please enter a valid price");
      return;
    }

    final stock = double.tryParse(_stockController.text);
    if (stock == null || stock < 0) {
      WarningSnackBar.show(context, message: "Please enter a valid stock quantity");
      return;
    }

    setState(() => _isLoading = true);

    final now = DateTime.now();
    final productData = {
      "name": _nameController.text.trim(),
      "code": _codeController.text.trim(),
      "price": price,
      "stock": stock,
      "description": _descriptionController.text.trim(),
      "status": _selectedStatus,
      "brandId": _selectedBrandId,
      "categoryId": _selectedCategoryId,
      "created_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "created_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      "updated_date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      "updated_time": "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
    };

    try {
      context.read<ProductBloc>().add(CreateProduct(productData));
    } catch (e) {
      WarningSnackBar.show(context, message: "Error: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}