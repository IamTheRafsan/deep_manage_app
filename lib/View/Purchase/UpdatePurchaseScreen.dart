import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/PaymentType/PaymentTypeEvent.dart';
import '../../Bloc/Product/ProductEvent.dart';
import '../../Bloc/Purchase/PurchaseBloc.dart';
import '../../Bloc/Purchase/PurchaseEvent.dart';
import '../../Bloc/Purchase/PurchaseState.dart';
import '../../Bloc/Product/ProductBloc.dart';
import '../../Bloc/Product/ProductState.dart';
import '../../Bloc/User/UserBlock.dart';
import '../../Bloc/User/UserEvent.dart';
import '../../Bloc/User/UserState.dart';
import '../../Bloc/Warehouse/WarehouseBloc.dart';
import '../../Bloc/Warehouse/WarehouseEvent.dart';
import '../../Bloc/Warehouse/WarehouseState.dart';
import '../../Bloc/PaymentType/PaymentTypeBloc.dart';
import '../../Bloc/PaymentType/PaymentTypeState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Styles/AppText.dart';
import '../../Model/Purchase/PurchaseModel.dart';

class UpdatePurchaseScreen extends StatefulWidget {
  final String purchaseId;

  const UpdatePurchaseScreen({super.key, required this.purchaseId});

  @override
  State<UpdatePurchaseScreen> createState() => _UpdatePurchaseScreenState();
}

class _UpdatePurchaseScreenState extends State<UpdatePurchaseScreen> {
  final TextEditingController _referenceController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();

  String? _selectedWarehouseId;
  String? _selectedWarehouseName;
  String? _selectedSupplierId;
  String? _selectedSupplierName;
  String? _selectedPaymentTypeId;
  String? _selectedPaymentTypeName;
  List<Map<String, dynamic>> _purchaseItems = [];

  bool _isLoading = false;
  bool _initialDataLoaded = false;
  String _currentUserId = '';
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    context.read<PurchaseBloc>().add(LoadPurchaseById(widget.purchaseId));
    context.read<ProductBloc>().add(LoadProduct());
    context.read<WarehouseBloc>().add(LoadWarehouse(showDeleted: false));
    context.read<PaymentTypeBloc>().add(LoadPaymentTypes());
    context.read<UserBloc>().add(LoadUser());
  }

  Future<void> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId') ?? '';
      _currentUserName = prefs.getString('userName') ?? '';
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Update Purchase",
      body: BlocConsumer<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseLoadedSingle && !_initialDataLoaded) {
            final purchase = state.purchase;
            _referenceController.text = purchase.reference;
            _purchaseDateController.text = purchase.purchaseDate ?? _formatDate(DateTime.now());
            _selectedWarehouseId = purchase.warehouseId;
            _selectedWarehouseName = purchase.warehouseName;
            _selectedSupplierId = purchase.supplierId;
            _selectedSupplierName = purchase.supplierName;
            _selectedPaymentTypeId = purchase.paymentTypeId;
            _selectedPaymentTypeName = purchase.paymentTypeName;
            _purchaseItems = purchase.purchaseItems.map((item) {
              return {
                'productId': item['productId'],
                'productName': item['productName'],
                'productCode': item['productCode'] ?? '',
                'productUnit': item['productUnit'] ?? '',
                'quantity': item['quantity'] ?? 1.0,
                'purchasePrice': item['purchasePrice'] ?? 0.0,
              };
            }).toList();
            _initialDataLoaded = true;
          }
          if (state is PurchaseUpdated) {
            SuccessSnackBar.show(context, message: "Purchase Updated Successfully!");
            Navigator.pop(context);
          }
          if (state is PurchaseError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          if (state is PurchaseLoading && !_initialDataLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PurchaseLoadedSingle && state.purchase.deleted) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.block, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Purchase is Deleted",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.red, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text("This purchase has been deleted and cannot be updated.",
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Go Back")),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Purchase Information", style: AppText.SubHeadingText()),
                const SizedBox(height: 16),
                TextInputField(
                  controller: _referenceController,
                  label: 'Reference Number *',
                  hintText: 'Enter purchase reference',
                ),
                const SizedBox(height: 16),
                TextInputField(
                  controller: _purchaseDateController,
                  label: 'Purchase Date *',
                  hintText: 'YYYY-MM-DD',
                ),
                const SizedBox(height: 16),
                BlocBuilder<WarehouseBloc, WarehouseState>(
                  builder: (context, state) {
                    if (state is WarehouseLoaded) {
                      return DropDownInputField<String>(
                        label: 'Warehouse *',
                        value: _selectedWarehouseId,
                        items: state.warehouses
                            .where((w) => !w.deleted)
                            .map((w) => DropdownMenuItem(value: w.id, child: Text(w.name)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            final wh = state.warehouses.firstWhere((w) => w.id == v);
                            setState(() {
                              _selectedWarehouseId = v;
                              _selectedWarehouseName = wh.name;
                            });
                          }
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoaded) {
                      return DropDownInputField<String>(
                        label: 'Supplier',
                        value: _selectedSupplierId,
                        items: state.users
                            .where((u) => !u.deleted)
                            .map((u) => DropdownMenuItem(
                          value: u.userId,
                          child: Text("${u.firstName} ${u.lastName}"),
                        ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            final user = state.users.firstWhere((u) => u.userId == v);
                            setState(() {
                              _selectedSupplierId = v;
                              _selectedSupplierName = "${user.firstName} ${user.lastName}";
                            });
                          }
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<PaymentTypeBloc, PaymentTypeState>(
                  builder: (context, state) {
                    if (state is PaymentTypeLoaded) {
                      return DropDownInputField<String>(
                        label: 'Payment Type',
                        value: _selectedPaymentTypeId,
                        items: state.paymentTypes
                            .where((p) => !p.deleted)
                            .map((p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            final pt = state.paymentTypes.firstWhere((p) => p.id == v);
                            setState(() {
                              _selectedPaymentTypeId = v;
                              _selectedPaymentTypeName = pt.name;
                            });
                          }
                        },
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Purchase Items", style: AppText.SubHeadingText()),
                    IconButton(
                        onPressed: _addPurchaseItem,
                        icon: Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor)),
                  ],
                ),
                const SizedBox(height: 16),
                if (_purchaseItems.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text("No items added. Click the + button to add items.", style: TextStyle(color: Colors.grey.shade600))),
                  ),
                ..._purchaseItems.asMap().entries.map((e) => _buildPurchaseItemCard(e.key, e.value)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    text: _isLoading ? 'Updating...' : 'Update Purchase',
                    onPressed: _isLoading ? null : _updatePurchase,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPurchaseItemCard(int index, Map<String, dynamic> item) {
    final productName = item['productName'] ?? 'Unknown Product';
    final productCode = item['productCode'] ?? '';
    final quantity = item['quantity'] ?? 0.0;
    final price = item['purchasePrice'] ?? 0.0;
    final total = quantity * price;

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
                Expanded(child: Text('$productName ${productCode.isNotEmpty ? '($productCode)' : ''}', style: const TextStyle(fontWeight: FontWeight.bold))),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue, size: 20), onPressed: () => _editPurchaseItem(index)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => _removePurchaseItem(index)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('Quantity: $quantity', style: TextStyle(color: Colors.grey.shade600))),
                Expanded(child: Text('Price: \$${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey.shade600))),
                Expanded(child: Text('Total: \$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addPurchaseItem() {
    showDialog(
      context: context,
      builder: (_) => _ProductDialog(
        onSave: (item) {
          setState(() => _purchaseItems.add(item));
        },
      ),
    );
  }

  void _editPurchaseItem(int index) {
    showDialog(
      context: context,
      builder: (_) => _ProductDialog(
        existingItem: _purchaseItems[index],
        onSave: (item) {
          setState(() => _purchaseItems[index] = item);
        },
      ),
    );
  }

  void _removePurchaseItem(int index) {
    setState(() => _purchaseItems.removeAt(index));
  }

  Future<void> _updatePurchase() async {
    if (_referenceController.text.isEmpty || _selectedWarehouseId == null || _purchaseItems.isEmpty || _currentUserId.isEmpty) {
      WarningSnackBar.show(context, message: "Please complete all required fields");
      return;
    }
    setState(() => _isLoading = true);
    final now = DateTime.now();
    final purchase = PurchaseModel(
      id: widget.purchaseId,
      supplierId: _selectedSupplierId,
      supplierName: _selectedSupplierName,
      purchasedById: _currentUserId,
      purchasedByName: _currentUserName,
      warehouseId: _selectedWarehouseId!,
      warehouseName: _selectedWarehouseName ?? '',
      reference: _referenceController.text.trim(),
      purchaseDate: _purchaseDateController.text.trim(),
      paymentTypeId: _selectedPaymentTypeId,
      paymentTypeName: _selectedPaymentTypeName,
      purchaseItems: _purchaseItems,
      updatedDate: _formatDate(now),
      updatedTime: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
      updatedById: _currentUserId,
    );
    context.read<PurchaseBloc>().add(UpdatePurchase(widget.purchaseId, purchase));
  }

  @override
  void dispose() {
    _referenceController.dispose();
    _purchaseDateController.dispose();
    super.dispose();
  }
}

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
          return const AlertDialog(content: Center(child: CircularProgressIndicator()));
        }
        if (state is ProductError) {
          return AlertDialog(title: const Text("Error"), content: Text(state.message), actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
          ]);
        }
        if (state is ProductLoaded) {
          final products = state.products.where((p) => !p.deleted).toList();
          if (products.isEmpty) {
            return AlertDialog(title: const Text("No Products"), content: const Text("No products available."), actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
            ]);
          }
          if (productId == null && products.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                productId = products[0].id;
                productName = products[0].name;
                productCode = products[0].code;
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
                    items: products.map((p) => DropdownMenuItem(value: p.id, child: Text("${p.name} (${p.code ?? 'No Code'})"))).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        final p = products.firstWhere((p) => p.id == v);
                        setState(() {
                          productId = v;
                          productName = p.name;
                          productCode = p.code;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextInputField(label: "Quantity *", keyboardType: TextInputType.number, hintText: quantity.toString(), onChanged: (v) {
                    final parsed = double.tryParse(v) ?? 1.0;
                    if (parsed > 0) setState(() => quantity = parsed);
                  }),
                  const SizedBox(height: 16),
                  TextInputField(label: "Price *", keyboardType: TextInputType.number, hintText: price.toString(), onChanged: (v) {
                    final parsed = double.tryParse(v) ?? 0.0;
                    if (parsed >= 0) setState(() => price = parsed);
                  }),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  if (productId == null || quantity <= 0 || price < 0) return;
                  widget.onSave({
                    'productId': productId!,
                    'productName': productName ?? 'Unknown Product',
                    'productCode': productCode ?? '',
                    'productUnit': productUnit ?? '',
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
        return const AlertDialog(content: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
