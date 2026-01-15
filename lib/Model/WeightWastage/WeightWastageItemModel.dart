class WeightWastageItemModel {
  final String id;
  final String weightWastageId;
  final String purchaseItemId;
  final double quantity;
  final String? reason;
  final String? productName;
  final String? productCode;
  final double? originalQuantity;

  WeightWastageItemModel({
    required this.id,
    required this.weightWastageId,
    required this.purchaseItemId,
    required this.quantity,
    this.reason,
    this.productName,
    this.productCode,
    this.originalQuantity,
  });

  factory WeightWastageItemModel.fromJson(Map<String, dynamic> json) {
    // Parse purchase item info
    final purchaseItem = json['purchaseItem'];
    final String purchaseItemId = purchaseItem != null ? purchaseItem['id']?.toString() ?? '' : '';

    String? productName;
    String? productCode;
    double? originalQuantity;

    if (purchaseItem != null && purchaseItem['product'] != null) {
      final product = purchaseItem['product'];
      productName = product['name']?.toString();
      productCode = product['code']?.toString();
      originalQuantity = purchaseItem['quantity'] != null ?
      double.tryParse(purchaseItem['quantity'].toString()) : null;
    }

    return WeightWastageItemModel(
      id: json['id']?.toString() ?? '',
      weightWastageId: json['weightWastage'] != null ?
      json['weightWastage']['id']?.toString() ?? '' : '',
      purchaseItemId: purchaseItemId,
      quantity: json['quantity'] != null ?
      double.tryParse(json['quantity'].toString()) ?? 0.0 : 0.0,
      reason: json['reason']?.toString(),
      productName: productName,
      productCode: productCode,
      originalQuantity: originalQuantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weightWastageId': weightWastageId,
      'purchaseItemId': purchaseItemId,
      'quantity': quantity,
      if (reason != null) 'reason': reason,
      if (productName != null) 'productName': productName,
      if (productCode != null) 'productCode': productCode,
      if (originalQuantity != null) 'originalQuantity': originalQuantity,
    };
  }

  Map<String, dynamic> toApiJson() {
    return {
      'purchaseItem': {
        'id': int.tryParse(purchaseItemId) ?? 0,
      },
      'quantity': quantity,
      if (reason != null && reason!.isNotEmpty) 'reason': reason,
    };
  }
}