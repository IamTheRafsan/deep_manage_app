class PurchaseItemModel {
  final String id;
  final String purchaseId;
  final String productId;
  final double quantity;
  final double? price;

  PurchaseItemModel({
    required this.id,
    required this.purchaseId,
    required this.productId,
    required this.quantity,
    required this.price
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      id: json['id']?.toString() ?? '',
      purchaseId: json['purchaseId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      quantity: json['quantity'] != null ? double.tryParse(json['quantity'].toString()) ?? 0.0 : 0.0,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseId': purchaseId,
      'productId': productId,
      'quantity': quantity,
      'purchasePrice': price,
    };
  }
}