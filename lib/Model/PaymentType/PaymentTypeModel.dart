import 'dart:convert';

class PaymentTypeModel {
  final String id;
  final String name;
  final String? createdDate;
  final String? createdTime;
  final String? createdById;
  final String? createdByName;
  final String? updatedDate;
  final String? updatedTime;
  final String? updatedById;
  final String? updatedByName;
  final bool deleted;
  final String? deletedById;
  final String? deletedByName;
  final String? deletedDate;
  final String? deletedTime;

  PaymentTypeModel({
    required this.id,
    required this.name,
    this.createdDate,
    this.createdTime,
    this.createdById,
    this.createdByName,
    this.updatedDate,
    this.updatedTime,
    this.updatedById,
    this.updatedByName,
    this.deleted = false,
    this.deletedById,
    this.deletedByName,
    this.deletedDate,
    this.deletedTime,
  });

  factory PaymentTypeModel.fromJson(Map<String, dynamic> json) {
    return PaymentTypeModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      createdDate: json['created_date']?.toString(),
      createdTime: json['created_time']?.toString(),
      createdById: json['created_by_id']?.toString(),
      createdByName: json['created_by_name']?.toString(),
      updatedDate: json['updated_date']?.toString(),
      updatedTime: json['updated_time']?.toString(),
      updatedById: json['updated_by_id']?.toString(),
      updatedByName: json['updated_by_name']?.toString(),
      deleted: json['deleted'] == true || json['deleted'] == 'true',
      deletedById: json['deletedById']?.toString(),
      deletedByName: json['deletedByName']?.toString(),
      deletedDate: json['deletedDate']?.toString(),
      deletedTime: json['deletedTime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_date': createdDate,
      'created_time': createdTime,
      'created_by_id': createdById,
      'created_by_name': createdByName,
      'updated_date': updatedDate,
      'updated_time': updatedTime,
      'updated_by_id': updatedById,
      'updated_by_name': updatedByName,
      'deleted': deleted,
      'deletedById': deletedById,
      'deletedByName': deletedByName,
      'deletedDate': deletedDate,
      'deletedTime': deletedTime,
    };
  }

  PaymentTypeModel copyWith({
    String? id,
    String? name,
    String? createdDate,
    String? createdTime,
    String? createdById,
    String? createdByName,
    String? updatedDate,
    String? updatedTime,
    String? updatedById,
    String? updatedByName,
    bool? deleted,
    String? deletedById,
    String? deletedByName,
    String? deletedDate,
    String? deletedTime,
  }) {
    return PaymentTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      updatedDate: updatedDate ?? this.updatedDate,
      updatedTime: updatedTime ?? this.updatedTime,
      updatedById: updatedById ?? this.updatedById,
      updatedByName: updatedByName ?? this.updatedByName,
      deleted: deleted ?? this.deleted,
      deletedById: deletedById ?? this.deletedById,
      deletedByName: deletedByName ?? this.deletedByName,
      deletedDate: deletedDate ?? this.deletedDate,
      deletedTime: deletedTime ?? this.deletedTime,
    );
  }
}