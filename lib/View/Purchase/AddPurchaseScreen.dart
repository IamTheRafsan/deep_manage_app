import 'package:deep_manage_app/Model/Purchase/PurchaseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/Purchase/PurchaseBloc.dart';
import '../../Bloc/Purchase/PurchaseEvent.dart';
import '../../Bloc/Purchase/PurchaseState.dart';
import '../../Bloc/User/UserBlock.dart';
import '../../Bloc/Warehouse/WarehouseBloc.dart';
import '../../Bloc/Warehouse/WarehouseEvent.dart';
import '../../Bloc/Warehouse/WarehouseState.dart';
import '../../Bloc/Product/ProductBloc.dart';
import '../../Bloc/Product/ProductEvent.dart';
import '../../Bloc/Product/ProductState.dart';
import '../../Bloc/PaymentType/PaymentTypeBloc.dart';
import '../../Bloc/PaymentType/PaymentTypeEvent.dart';
import '../../Bloc/PaymentType/PaymentTypeState.dart';
import '../../Bloc/User/UserEvent.dart';
import '../../Bloc/User/UserState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';

class AddPurchaseScreen extends StatefulWidget {
  const AddPurchaseScreen({super.key});

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final TextEditingController _referenceController = TextEditingController();

  String? warehouseId;
  String? warehouseName;
  String? supplierId;
  String? supplierName;
  String? paymentTypeId;
  String? paymentTypeName;

  List<Map<String, dynamic>> purchaseItems = [];

  bool isLoading = false;
  String currentUserId = '';
  String currentUserName = '';

  @override
  void initState() {
    super.initState();
    _loadUser();

    context.read<WarehouseBloc>().add(LoadWarehouse(showDeleted: false));
    context.read<ProductBloc>().add(LoadProduct());
    context.read<PaymentTypeBloc>().add(LoadPaymentTypes());
    context.read<UserBloc>().add(LoadUser());
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId') ?? '';
      currentUserName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add Purchase",
      body: BlocConsumer<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseCreated) {
            SuccessSnackBar.show(context, message: "Purchase created successfully");
            Navigator.pop(context);
          }
          if (state is PurchaseError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => isLoading = false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Reference
                TextInputField(
                  controller: _referenceController,
                  label: 'Reference *',
                  hintText: 'Enter purchase reference',
                ),
                const SizedBox(height: 16),

                /// Warehouse
                BlocBuilder<WarehouseBloc, WarehouseState>(
                  builder: (context, state) {
                    if (state is WarehouseLoaded) {
                      return DropDownInputField<String>(
                        label: 'Warehouse *',
                        value: warehouseId,
                        items: state.warehouses
                            .where((w) => !w.deleted) // Filter out deleted
                            .map((w) => DropdownMenuItem<String>(
                          value: w.id,
                          child: Text(w.name),
                        ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            final selectedWarehouse = state.warehouses
                                .firstWhere((w) => w.id == v);
                            setState(() {
                              warehouseId = v;
                              warehouseName = selectedWarehouse.name;
                            });
                          }
                        },
                      );
                    }
                    if (state is WarehouseLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Text("Error loading warehouses");
                  },
                ),
                const SizedBox(height: 16),

                /// Supplier
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoaded) {
                      return DropDownInputField<String>(
                        label: 'Supplier',
                        value: supplierId,
                        items: state.users
                            .where((u) => !u.deleted) // Filter out deleted
                            .map((u) => DropdownMenuItem<String>(
                          value: u.userId,
                          child: Text("${u.firstName} ${u.lastName}"),
                        ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            final selectedUser = state.users
                                .firstWhere((u) => u.userId == v);
                            setState(() {
                              supplierId = v;
                              supplierName = "${selectedUser.firstName} ${selectedUser.lastName}";
                            });
                          }
                        },
                      );
                    }
                    if (state is UserLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Text("Error loading suppliers");
                  },
                ),
                const SizedBox(height: 16),

                /// Payment Type
                BlocBuilder<PaymentTypeBloc, PaymentTypeState>(
                  builder: (context, state) {
                    if (state is PaymentTypeLoaded) {
                      return DropDownInputField<String>(
                        label: 'Payment Type',
                        value: paymentTypeId,
                        items: state.paymentTypes
                            .where((p) => !p.deleted) // Filter out deleted
                            .map((p) => DropdownMenuItem<String>(
                          value: p.id,
                          child: Text(p.name),
                        ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            final selectedPaymentType = state.paymentTypes
                                .firstWhere((p) => p.id == v);
                            setState(() {
                              paymentTypeId = v;
                              paymentTypeName = selectedPaymentType.name;
                            });
                          }
                        },
                      );
                    }
                    if (state is PaymentTypeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Text("Error loading payment types");
                  },
                ),

                const SizedBox(height: 24),

                /// Purchase Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Purchase Items", style: AppText.SubHeadingText()),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _addItem,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),

                if (purchaseItems.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "No items added. Click the + button to add items.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                ...purchaseItems.asMap().entries.map(
                      (e) => _itemCard(e.key, e.value),
                ),

                // Display total
                if (purchaseItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Items:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          Text(
                            purchaseItems.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Amount:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          Text(
                            "\$${_calculateTotalAmount().toStringAsFixed(2)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                PrimaryButton(
                  text: isLoading ? "Saving..." : "Create Purchase",
                  onPressed: isLoading ? null : _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ITEM CARD WITH EDIT + DELETE
  Widget _itemCard(int index, Map<String, dynamic> item) {
    final productName = item['productName'] ?? 'Unknown Product';
    final productCode = item['productCode'] ?? '';
    final quantity = item['quantity'] ?? 0.0;
    final price = item['purchasePrice'] ?? 0.0;
    final total = quantity * price;
    final unit = item['productUnit'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '$productName ${productCode.isNotEmpty ? '($productCode)' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: () => _editItem(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _deleteItem(index),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Quantity: $quantity $unit',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Price: \$${price.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() => purchaseItems.removeAt(index));
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (_) => _ProductDialog(
        existingItem: purchaseItems[index],
        onSave: (item) {
          setState(() => purchaseItems[index] = item);
        },
      ),
    );
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (_) => _ProductDialog(
        onSave: (item) {
          setState(() => purchaseItems.add(item));
        },
      ),
    );
  }

  double _calculateTotalAmount() {
    return purchaseItems.fold(0.0, (sum, item) {
      final quantity = item['quantity'] ?? 0.0;
      final price = item['purchasePrice'] ?? 0.0;
      return sum + (quantity * price);
    });
  }

  /// SUBMIT - FIXED
  void _submit() {
    // Validation
    if (_referenceController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please enter reference number");
      return;
    }

    if (warehouseId == null) {
      WarningSnackBar.show(context, message: "Please select a warehouse");
      return;
    }

    if (purchaseItems.isEmpty) {
      WarningSnackBar.show(context, message: "Please add at least one item");
      return;
    }

    if (currentUserId.isEmpty) {
      WarningSnackBar.show(context, message: "User not authenticated");
      return;
    }

    setState(() => isLoading = true);

    final now = DateTime.now();

    // Create PurchaseModel object
    final purchase = PurchaseModel(
      id: '',
      supplierId: supplierId,
      purchasedById: currentUserId,
      warehouseId: warehouseId!,
      reference: _referenceController.text.trim(),
      purchaseDate: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      paymentTypeId: paymentTypeId,
      purchaseItems: purchaseItems,
    );

    // Pass PurchaseModel to the event
    context.read<PurchaseBloc>().add(CreatePurchase(purchase));
  }

  @override
  void dispose() {
    _referenceController.dispose();
    super.dispose();
  }
}

/// ================= PRODUCT DIALOG =================

class _ProductDialog extends StatefulWidget {
  final Map<String, dynamic>? existingItem;
  final Function(Map<String, dynamic>) onSave;

  const _ProductDialog({this.existingItem, required this.onSave});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  String? productId;
  String? productName;
  String? productCode;
  String? productUnit;
  double quantity = 1;
  double price = 0;

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      productId = widget.existingItem!['productId'].toString();
      productName = widget.existingItem!['productName']?.toString();
      productCode = widget.existingItem!['productCode']?.toString();
      productUnit = widget.existingItem!['productUnit']?.toString();
      quantity = (widget.existingItem!['quantity'] as num).toDouble();
      price = (widget.existingItem!['purchasePrice'] as num).toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const AlertDialog(
            content: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProductError) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(state.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        }

        if (state is ProductLoaded) {
          final products = state.products.where((p) => !p.deleted).toList();

          if (products.isEmpty) {
            return AlertDialog(
              title: const Text("No Products"),
              content: const Text("No products available. Please add products first."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          }

          // Auto-select first product if not selected
          if (productId == null && products.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                productId = products[0].id;
                productName = products[0].name;
                productCode = products[0].code;
               // productUnit = products[0].unit;
                //price = products[0].purchasePrice ?? 0.0;
              });
            });
          }

          return AlertDialog(
            title: Text(widget.existingItem == null ? "Add Product" : "Edit Product"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropDownInputField<String>(
                    label: "Product *",
                    value: productId,
                    items: products
                        .map((p) => DropdownMenuItem<String>(
                      value: p.id,
                      child: Text("${p.name} (${p.code ?? 'No Code'})"),
                    ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        final selectedProduct = products.firstWhere((p) => p.id == v);
                        setState(() {
                          productId = v;
                          productName = selectedProduct.name;
                          productCode = selectedProduct.code;
                          // productUnit = selectedProduct.unit;
                          // price = selectedProduct.purchasePrice ?? 0.0;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextInputField(
                    label: "Quantity *",
                    keyboardType: TextInputType.number,
                    hintText: quantity.toString(),
                    onChanged: (v) {
                      final parsed = double.tryParse(v) ?? 1.0;
                      if (parsed > 0) {
                        setState(() => quantity = parsed);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextInputField(
                    label: "Price *",
                    keyboardType: TextInputType.number,
                    hintText: price.toString(),
                    onChanged: (v) {
                      final parsed = double.tryParse(v) ?? 0.0;
                      if (parsed >= 0) {
                        setState(() => price = parsed);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (productId == null || productId!.isEmpty) {
                    WarningSnackBar.show(context, message: "Please select a product");
                    return;
                  }

                  if (quantity <= 0) {
                    WarningSnackBar.show(context, message: "Quantity must be greater than 0");
                    return;
                  }

                  if (price < 0) {
                    WarningSnackBar.show(context, message: "Price cannot be negative");
                    return;
                  }

                  widget.onSave({
                    'productId': productId!,
                    'productName': productName ?? 'Unknown Product',
                    'productCode': productCode,
                    'productUnit': productUnit,
                    'quantity': quantity,
                    'purchasePrice': price,
                  });

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          );
        }

        return const AlertDialog(
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}