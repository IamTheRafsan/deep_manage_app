class ExpenseCategoryModel {
  final String id;
  final String name;
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

  ExpenseCategoryModel({
    required this.id,
    required this.name,
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

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
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