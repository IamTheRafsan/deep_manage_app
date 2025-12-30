class RoleModel {
  final String role_id;
  final String name;

  final String? created_by_id;
  final String? created_by_name;

  final String? updated_by_id;
  final String? updated_by_name;

  final List<String> permission;

  final String? created_date;
  final String? created_time;

  final String? updated_date;
  final String? updated_time;

  final bool deleted;
  final String? deletedById;
  final String? deletedByName;
  final String? deletedDate;
  final String? deletedTime;

  RoleModel({
    required this.role_id,
    required this.name,
    this.created_by_id,
    this.created_by_name,
    this.updated_by_id,
    this.updated_by_name,
    required this.permission,
    this.created_date,
    this.created_time,
    this.updated_date,
    this.updated_time,
    required this.deleted,
    this.deletedById,
    this.deletedByName,
    this.deletedDate,
    this.deletedTime,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      role_id: json['role_id'] ?? '',
      name: json['name'] ?? '',
      created_by_id: json['created_by_id'],
      created_by_name: json['created_by_name'],
      updated_by_id: json['updated_by_id'],
      updated_by_name: json['updated_by_name'],
      permission: List<String>.from(json['permission'] ?? []),
      created_date: json['created_date'],
      created_time: json['created_time'],
      updated_date: json['updated_date'],
      updated_time: json['updated_time'],
      deleted: json['deleted'] ?? false,
      deletedById: json['deletedById'],
      deletedByName: json['deletedByName'],
      deletedDate: json['deletedDate'],
      deletedTime: json['deletedTime'],
    );
  }
}
