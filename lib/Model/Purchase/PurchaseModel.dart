import 'dart:convert';

class PurchaseModel {
  final String id;
  final String? supplierId;
  final String? supplierName;
  final String? purchasedById;
  final String? purchasedByName;
  final String warehouseId;
  final String? warehouseName;
  final String reference;
  final String? purchaseDate;
  final String? paymentTypeId;
  final String? paymentTypeName;
  final List<Map<String, dynamic>> purchaseItems;
  final String? createdDate;
  final String? createdTime;
  final String? createdById;
  final String? updatedDate;
  final String? updatedTime;
  final String? updatedById;
  final bool deleted;
  final String? deletedById;
  final String? deletedDate;
  final String? deletedTime;

  PurchaseModel({
    required this.id,
    this.supplierId,
    this.supplierName,
    this.purchasedById,
    this.purchasedByName,
    required this.warehouseId,
    this.warehouseName,
    required this.reference,
    this.purchaseDate,
    this.paymentTypeId,
    this.paymentTypeName,
    required this.purchaseItems,
    this.createdDate,
    this.createdTime,
    this.createdById,
    this.updatedDate,
    this.updatedTime,
    this.updatedById,
    this.deleted = false,
    this.deletedById,
    this.deletedDate,
    this.deletedTime,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    // Parse purchase items safely
    List<Map<String, dynamic>> items = [];
    if (json['purchaseItem'] != null && json['purchaseItem'] is List) {
      items = (json['purchaseItem'] as List).map((item) {
        final product = item['product'] ?? {};
        return {
          'productId': product['id']?.toString() ?? '',
          'id': item['id']?.toString() ?? '',
          'productName': product['name']?.toString() ?? 'Unknown Product',
          'quantity': (item['quantity'] ?? 0).toDouble(),
          'purchasePrice': (item['price'] ?? 0).toDouble(),
        };
      }).toList().cast<Map<String, dynamic>>();
    }


    print("DEBUG: Mapped Purchase Items -> $items");

    // Supplier parsing
    final supplier = json['supplier'];
    final String? supplierId =
    supplier != null ? supplier['user_id']?.toString() : null;
    final String? supplierName =
    supplier != null
        ? "${supplier['firstName'] ?? ''} ${supplier['lastName'] ?? ''}"
        .trim()
        : null;

    // Purchased By parsing
    final purchasedBy = json['purchasedBy'];
    final String? purchasedById =
    purchasedBy != null ? purchasedBy['user_id']?.toString() : null;
    final String? purchasedByName =
    purchasedBy != null
        ? "${purchasedBy['firstName'] ?? ''} ${purchasedBy['lastName'] ?? ''}"
        .trim()
        : null;

    // Warehouse parsing
    final warehouse = json['warehouse'];
    final String warehouseId =
    warehouse != null ? warehouse['id']?.toString() ?? '' : '';
    final String? warehouseName =
    warehouse != null ? warehouse['name']?.toString() : null;

    // Payment type parsing
    final paymentType = json['paymentType'];
    final String? paymentTypeId =
    paymentType != null ? paymentType['id']?.toString() : null;
    final String? paymentTypeName =
    paymentType != null ? paymentType['name']?.toString() : null;

    return PurchaseModel(
      id: json['id']?.toString() ?? '',
      supplierId: supplierId,
      supplierName: supplierName,
      purchasedById: purchasedById,
      purchasedByName: purchasedByName,
      warehouseId: warehouseId,
      warehouseName: warehouseName,
      reference: json['reference']?.toString() ?? '',
      purchaseDate: json['purchaseDate']?.toString(),
      paymentTypeId: paymentTypeId,
      paymentTypeName: paymentTypeName,
      purchaseItems: items,
      createdDate: json['created_date']?.toString(),
      createdTime: json['created_time']?.toString(),
      createdById: json['created_by_id']?.toString(),
      updatedDate: json['updated_date']?.toString(),
      updatedTime: json['updated_time']?.toString(),
      updatedById: json['updated_by_id']?.toString(),
      deleted: json['deleted'] == true || json['deleted'] == 'true',
      deletedById: json['deletedById']?.toString(),
      deletedDate: json['deletedDate']?.toString(),
      deletedTime: json['deletedTime']?.toString(),
    );
  }




  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (supplierId != null) 'supplierId': supplierId,
      if (purchasedById != null) 'purchasedById': purchasedById,
      'warehouseId': warehouseId,
      'reference': reference,
      if (purchaseDate != null) 'purchaseDate': purchaseDate,
      if (paymentTypeId != null) 'paymentTypeId': paymentTypeId,
      'purchaseItem': purchaseItems,
      if (createdDate != null) 'created_date': createdDate,
      if (createdTime != null) 'created_time': createdTime,
      if (createdById != null) 'created_by_id': createdById,
      if (updatedDate != null) 'updated_date': updatedDate,
      if (updatedTime != null) 'updated_time': updatedTime,
      if (updatedById != null) 'updated_by_id': updatedById,
      'deleted': deleted,
      if (deletedById != null) 'deletedById': deletedById,
      if (deletedDate != null) 'deletedDate': deletedDate,
      if (deletedTime != null) 'deletedTime': deletedTime,
    };
  }

  // Method to create JSON for API requests (without unnecessary fields)
  Map<String, dynamic> toApiJson() {
    return {
      'supplier': supplierId,
      'purchasedBy': purchasedById,
      'warehouse': int.tryParse(warehouseId) ?? 0,
      'reference': reference,
      if (purchaseDate != null && purchaseDate!.isNotEmpty) 'purchaseDate': purchaseDate,
      if (paymentTypeId != null) 'paymentType': int.tryParse(paymentTypeId!),
      'purchaseItem': purchaseItems.map((item) {
        return {
          'product': {
            'id': int.tryParse(item['productId'].toString()) ?? 0
          },
          'price': item['purchasePrice'] ?? 0.0,
          'quantity': item['quantity'] ?? 0.0,
        };
      }).toList(),
    };
  }
}