class WarehouseModel {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String country;
  final String city;
  final String area;
  final String status;
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

  WarehouseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.country,
    required this.city,
    required this.area,
    required this.status,
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

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'].toString(),
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      area: json['area'] ?? '',
      status: json['status'] ?? 'ACTIVE',
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
      'email': email,
      'mobile': mobile,
      'country': country,
      'city': city,
      'area': area,
      'status': status,
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