class ProductModel {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String status;
  final double price;
  final double stock;
  final String? brandId;
  final String? brandName;
  final String? categoryId;
  final String? categoryName;
  final bool deleted;
  final String? created_date;
  final String? created_time;
  final String? created_by_id;
  final String? updated_date;
  final String? updated_time;
  final String? updated_by_id;
  final String? deletedById;
  final String? deletedByName;
  final String? deletedDate;
  final String? deletedTime;

  ProductModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.status,
    required this.price,
    required this.stock,
    this.brandId,
    this.brandName,
    this.categoryId,
    this.categoryName,
    this.deleted = false,
    this.created_date,
    this.created_time,
    this.created_by_id,
    this.updated_date,
    this.updated_time,
    this.updated_by_id,
    this.deletedById,
    this.deletedByName,
    this.deletedDate,
    this.deletedTime,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'ACTIVE',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: (json['stock'] ?? 0.0).toDouble(),
      brandId: json['brand_id']?.toString(),
      brandName: json['brand_name'] ?? json['brand']?['name'],
      categoryId: json['category_id']?.toString(),
      categoryName: json['category_name'] ?? json['category']?['name'],
      deleted: json['deleted'] ?? false,
      created_date: json['created_date'] ?? '',
      created_time: json['created_time'] ?? '',
      created_by_id: json['created_by_id'] ?? '',
      updated_date: json['updated_date'] ?? '',
      updated_time: json['updated_time'] ?? '',
      updated_by_id: json['updated_by_id'] ?? '',
      deletedById: json['deletedById'] ?? '',
      deletedByName: json['deletedByName'] ?? '',
      deletedDate: json['deletedDate'] ?? '',
      deletedTime: json['deletedTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'status': status,
      'price': price,
      'stock': stock,
      'brand_id': brandId,
      'category_id': categoryId,
      'deleted': deleted,
      'created_date': created_date,
      'created_time': created_time,
      'created_by_id': created_by_id,
      'updated_date': updated_date,
      'updated_time': updated_time,
      'updated_by_id': updated_by_id,
      'deletedById': deletedById,
      'deletedByName': deletedByName,
      'deletedDate': deletedDate,
      'deletedTime': deletedTime,
    };
  }
}