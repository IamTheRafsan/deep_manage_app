class ExpenseModel {
  final String id;
  final String name;
  final double amount;
  final String description;
  final String status;
  final String? categoryId;
  final String? categoryName;
  final String? paymentTypeId;
  final String? paymentTypeName;
  final String? warehouseId;
  final String? warehouseName;
  final String? outletId;
  final String? outletName;
  final String? userId;
  final String? userName;
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

  ExpenseModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.description,
    required this.status,
    this.categoryId,
    this.categoryName,
    this.paymentTypeId,
    this.paymentTypeName,
    this.warehouseId,
    this.warehouseName,
    this.outletId,
    this.outletName,
    this.userId,
    this.userName,
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

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      status: json['status'] ?? 'PENDING',
      categoryId: json['category_id']?.toString(),
      categoryName: json['category_name'] ?? json['category']?['name'],
      paymentTypeId: json['payment_type_id']?.toString(),
      paymentTypeName: json['payment_type_name'] ?? json['paymentType']?['name'],
      warehouseId: json['warehouse_id']?.toString(),
      warehouseName: json['warehouse_name'] ?? json['warehouse']?['name'],
      outletId: json['outlet_id']?.toString(),
      outletName: json['outlet_name'] ?? json['outlet']?['name'],
      userId: json['user_id']?.toString(),
      userName: json['user_name'] ?? json['user']?['name'],
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
      'amount': amount,
      'description': description,
      'status': status,
      'category_id': categoryId,
      'payment_type_id': paymentTypeId,
      'warehouse_id': warehouseId,
      'outlet_id': outletId,
      'user_id': userId,
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