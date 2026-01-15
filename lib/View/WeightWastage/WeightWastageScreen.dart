import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Bloc/WeightWastage/WeightWastageBloc.dart';
import '../../Bloc/WeightWastage/WeightWastageEvent.dart';
import '../../Bloc/WeightWastage/WeightWastageState.dart';
import '../../Bloc/Purchase/PurchaseBloc.dart';
import '../../Bloc/Purchase/PurchaseEvent.dart';
import '../../Bloc/Purchase/PurchaseState.dart';
import '../../Component/Buttons/PrimaryButton.dart';
import '../../Component/GlobalScaffold/GlobalScaffold.dart';
import '../../Component/Inputs/DropDownInputField.dart';
import '../../Component/Inputs/TextInputField.dart';
import '../../Component/SnackBar/SuccessSnackBar.dart';
import '../../Component/SnackBar/WarningSnackBar.dart';
import '../../Model/WeightWastage/WeightWastageItemModel.dart';
import '../../Styles/AppText.dart';
import '../../Model/WeightWastage/WeightWastageModel.dart';
import '../../Model/Purchase/PurchaseModel.dart';

class AddWeightWastageScreen extends StatefulWidget {
  const AddWeightWastageScreen({super.key});

  @override
  State<AddWeightWastageScreen> createState() => _AddWeightWastageScreenState();
}

class _AddWeightWastageScreenState extends State<AddWeightWastageScreen> {
  final TextEditingController _reasonController = TextEditingController();

  String? _selectedPurchaseId;
  String? _selectedPurchaseReference;
  PurchaseModel? _selectedPurchase;
  List<Map<String, dynamic>> _weightWastageItems = [];

  bool _isLoading = false;
  String _currentUserId = '';
  String _currentUserName = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
    context.read<PurchaseBloc>().add(LoadPurchases(showDeleted: false));
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUserId = prefs.getString('userId') ?? '';
      _currentUserName = prefs.getString('userName') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      title: "Add Weight Wastage",
      body: BlocConsumer<WeightWastageBloc, WeightWastageState>(
        listener: (context, state) {
          if (state is WeightWastageCreated) {
            SuccessSnackBar.show(context, message: "Weight wastage recorded successfully");
            Navigator.pop(context);
          }
          if (state is WeightWastageError) {
            WarningSnackBar.show(context, message: state.message);
            setState(() => _isLoading = false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Purchase Selection
                BlocBuilder<PurchaseBloc, PurchaseState>(
                  builder: (context, state) {
                    if (state is PurchaseLoaded) {
                      return DropDownInputField<String>(
                        label: 'Purchase *',
                        value: _selectedPurchaseId,
                        items: state.purchases
                            .where((p) => !p.deleted)
                            .map((p) => DropdownMenuItem<String>(
                          value: p.id,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              "${p.reference} - ${p.purchaseDate ?? ''}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            final selectedPurchase = state.purchases
                                .firstWhere((p) => p.id == v);
                            setState(() {
                              _selectedPurchaseId = v;
                              _selectedPurchaseReference = selectedPurchase.reference;
                              _selectedPurchase = selectedPurchase;
                              _weightWastageItems.clear(); // Clear items when purchase changes
                            });
                          }
                        },
                      );
                    }
                    if (state is PurchaseLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return const Text("Error loading purchases");
                  },
                ),
                const SizedBox(height: 16),

                /// Reason
                TextInputField(
                  controller: _reasonController,
                  label: 'Reason *',
                  hintText: 'Enter reason for weight wastage',
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                /// Weight Wastage Items
                if (_selectedPurchase != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Weight Wastage Items", style: AppText.SubHeadingText()),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: _addItem,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),

                  if (_selectedPurchase!.purchaseItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "No items available in this purchase",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                  if (_selectedPurchase!.purchaseItems.isNotEmpty && _weightWastageItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "No items added. Click the + button to add weight wastage items.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                  ..._weightWastageItems.asMap().entries.map(
                        (e) => _itemCard(e.key, e.value),
                  ),

                  // Display totals
                  if (_weightWastageItems.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Items:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                            Text(
                              _weightWastageItems.length.toString(),
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
                    Card(
                      color: Colors.orange.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Weight Wastage:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            Text(
                              "${_calculateTotalWeightWastage().toStringAsFixed(2)} units",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.orange.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],

                const SizedBox(height: 30),

                PrimaryButton(
                  text: _isLoading ? "Saving..." : "Record Weight Wastage",
                  onPressed: _isLoading ? null : _submit,
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
    final purchaseItemId = item['purchaseItemId'] ?? '';
    final quantity = item['quantity'] ?? 0.0;
    final originalQuantity = item['originalQuantity'] ?? 0.0;
    final reason = item['reason'] ?? '';
    final maxWastage = originalQuantity * 0.3; // Maximum 30% wastage allowed

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$productName ${productCode.isNotEmpty ? '($productCode)' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Purchase Item ID: $purchaseItemId',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ],
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
            Text(
              'Original Quantity: ${originalQuantity.toStringAsFixed(2)} units',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Weight Wastage: ${quantity.toStringAsFixed(2)} units',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Remaining: ${(originalQuantity - quantity).toStringAsFixed(2)} units',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (reason.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Reason: $reason',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 12,
                ),
              ),
            ],
            if (quantity > maxWastage) ...[
              const SizedBox(height: 4),
              Text(
                '⚠️ Wastage exceeds 30% of original quantity',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _deleteItem(int index) {
    setState(() => _weightWastageItems.removeAt(index));
  }

  void _editItem(int index) {
    showDialog(
      context: context,
      builder: (_) => _WeightWastageItemDialog(
        purchase: _selectedPurchase!,
        existingItem: _weightWastageItems[index],
        onSave: (item) {
          setState(() => _weightWastageItems[index] = item);
        },
      ),
    );
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (_) => _WeightWastageItemDialog(
        purchase: _selectedPurchase!,
        onSave: (item) {
          setState(() => _weightWastageItems.add(item));
        },
      ),
    );
  }

  double _calculateTotalWeightWastage() {
    return _weightWastageItems.fold(0.0, (sum, item) {
      final quantity = item['quantity'] ?? 0.0;
      return sum + quantity;
    });
  }

  /// SUBMIT
  void _submit() async {
    // Validation
    if (_selectedPurchaseId == null) {
      WarningSnackBar.show(context, message: "Please select a purchase");
      return;
    }

    if (_reasonController.text.isEmpty) {
      WarningSnackBar.show(context, message: "Please enter a reason");
      return;
    }

    if (_weightWastageItems.isEmpty) {
      WarningSnackBar.show(context, message: "Please add at least one weight wastage item");
      return;
    }

    if (_currentUserId.isEmpty) {
      WarningSnackBar.show(context, message: "User not authenticated");
      return;
    }

    // Validate weight wastage doesn't exceed 30% per item
    for (var item in _weightWastageItems) {
      final quantity = item['quantity'] ?? 0.0;
      final originalQuantity = item['originalQuantity'] ?? 0.0;
      final maxWastage = originalQuantity * 0.3;

      if (quantity > maxWastage) {
        WarningSnackBar.show(context,
            message: "Weight wastage for ${item['productName']} exceeds 30% of original quantity. Maximum allowed: ${maxWastage.toStringAsFixed(2)} units");
        return;
      }

      if (quantity <= 0) {
        WarningSnackBar.show(context,
            message: "Weight wastage for ${item['productName']} must be greater than 0");
        return;
      }
    }

    setState(() => _isLoading = true);

    // Create WeightWastageModel object
    final weightWastageItems = _weightWastageItems.map((item) {
      return WeightWastageItemModel(
        id: '',
        weightWastageId: '',
        purchaseItemId: item['purchaseItemId'].toString(),
        quantity: item['quantity'],
        reason: item['reason']?.toString(),
      );
    }).toList();

    final weightWastage = WeightWastageModel(
      id: '',
      purchaseId: _selectedPurchaseId!,
      userId: _currentUserId,
      reason: _reasonController.text.trim(),
      weightWastageItems: weightWastageItems,
    );

    // Pass WeightWastageModel to the event
    context.read<WeightWastageBloc>().add(CreateWeightWastage(weightWastage));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}

/// ================= WEIGHT WASTAGE ITEM DIALOG =================

class _WeightWastageItemDialog extends StatefulWidget {
  final PurchaseModel purchase;
  final Map<String, dynamic>? existingItem;
  final Function(Map<String, dynamic>) onSave;

  const _WeightWastageItemDialog({
    required this.purchase,
    this.existingItem,
    required this.onSave,
  });

  @override
  State<_WeightWastageItemDialog> createState() => _WeightWastageItemDialogState();
}

class _WeightWastageItemDialogState extends State<_WeightWastageItemDialog> {
  String? _selectedPurchaseItemId;
  String? _productName;
  String? _productCode;
  double _originalQuantity = 0.0;
  double _weightWastage = 0.0;
  final TextEditingController _itemReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      _selectedPurchaseItemId = widget.existingItem!['purchaseItemId'].toString();
      _productName = widget.existingItem!['productName']?.toString();
      _productCode = widget.existingItem!['productCode']?.toString();
      _originalQuantity = widget.existingItem!['originalQuantity'] ?? 0.0;
      _weightWastage = widget.existingItem!['quantity'] ?? 0.0;
      _itemReasonController.text = widget.existingItem!['reason']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get available purchase items
    final availableItems = widget.purchase.purchaseItems;

    // Auto-select first item if not selected
    if (_selectedPurchaseItemId == null && availableItems.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final firstItem = availableItems.first;
        setState(() {
          // Use 'id' field which contains purchase item ID
          _selectedPurchaseItemId = firstItem['id']?.toString() ?? '';
          _productName = firstItem['productName'] ?? 'Unknown Product';
          _productCode = firstItem['productCode'] ?? '';
          _originalQuantity = firstItem['quantity'] ?? 0.0;
          _weightWastage = 0.0;
        });
      });
    }

    final maxWastage = _originalQuantity * 0.3;

    return AlertDialog(
      title: Text(widget.existingItem == null ? "Add Weight Wastage Item" : "Edit Weight Wastage Item"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Selection
            if (availableItems.isNotEmpty)
              DropDownInputField<String>(
                label: "Product *",
                value: _selectedPurchaseItemId,
                items: availableItems
                    .map((item) {
                  // Use 'id' field for value (purchase item ID)
                  final purchaseItemId = item['id']?.toString() ?? '';
                  final productName = item['productName'] ?? 'Unknown Product';
                  final productCode = item['productCode'] ?? '';
                  final quantity = item['quantity'] ?? 0.0;
                  final price = item['purchasePrice'] ?? 0.0;

                  return DropdownMenuItem<String>(
                    value: purchaseItemId,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${productCode.isNotEmpty ? '($productCode) ' : ''}ID: $purchaseItemId",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            "Qty: ${quantity.toStringAsFixed(2)} | Price: \$${price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                })
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    // Compare with 'id' field
                    final selectedItem = availableItems.firstWhere(
                          (item) => item['id']?.toString() == v,
                    );
                    setState(() {
                      _selectedPurchaseItemId = v;
                      _productName = selectedItem['productName'] ?? 'Unknown Product';
                      _productCode = selectedItem['productCode'] ?? '';
                      _originalQuantity = selectedItem['quantity'] ?? 0.0;
                      _weightWastage = 0.0;
                    });
                  }
                },
              ),

            if (availableItems.isEmpty)
              const Text(
                "No items available from this purchase",
                style: TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 16),

            // Original Quantity (read-only)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Original Quantity:"),
                  Text(
                    "${_originalQuantity.toStringAsFixed(2)} units",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Weight Wastage Input
            TextInputField(
              label: "Weight Wastage *",
              keyboardType: TextInputType.number,
              hintText: "Enter weight wastage amount",
              onChanged: (v) {
                final parsed = double.tryParse(v) ?? 0.0;
                setState(() => _weightWastage = parsed);
              },
            ),

            // Max wastage warning
            if (_weightWastage > maxWastage)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "⚠️ Maximum allowed wastage: ${maxWastage.toStringAsFixed(2)} units (30% of original)",
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Item-specific reason
            TextInputField(
              controller: _itemReasonController,
              label: "Item Reason (Optional)",
              hintText: "Reason for this specific item's weight wastage",
              maxLines: 2,
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
            if (_selectedPurchaseItemId == null || _selectedPurchaseItemId!.isEmpty) {
              WarningSnackBar.show(context, message: "Please select a product");
              return;
            }

            if (_weightWastage <= 0) {
              WarningSnackBar.show(context, message: "Weight wastage must be greater than 0");
              return;
            }

            if (_weightWastage > maxWastage) {
              WarningSnackBar.show(context,
                  message: "Weight wastage cannot exceed 30% of original quantity. Maximum allowed: ${maxWastage.toStringAsFixed(2)} units");
              return;
            }

            if (_weightWastage > _originalQuantity) {
              WarningSnackBar.show(context,
                  message: "Weight wastage cannot exceed original quantity");
              return;
            }

            widget.onSave({
              'purchaseItemId': _selectedPurchaseItemId!,
              'productName': _productName ?? 'Unknown Product',
              'productCode': _productCode ?? '',
              'originalQuantity': _originalQuantity,
              'quantity': _weightWastage,
              'reason': _itemReasonController.text.trim(),
            });

            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}