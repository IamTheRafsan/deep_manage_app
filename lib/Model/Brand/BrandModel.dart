class BrandModel {
  final String id;
  final String name;
  final String code;
  final String? created_date;
  final String? created_time;
  final String? updated_date;
  final String? updated_time;

  BrandModel({
    required this.id,
    required this.name,
    required this.code,
    this.created_date,
    this.created_time,
    this.updated_date,
    this.updated_time,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      created_date: json['created_date'] ?? '',
      created_time: json['created_time'] ?? '',
      updated_date: json['updated_date'] ?? '',
      updated_time: json['updated_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'created_date': created_date,
      'created_time': created_time,
      'updated_date': updated_date,
      'updated_time': updated_time,
    };
  }
}