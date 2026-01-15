import 'dart:convert';

import 'WeightLessItemModel.dart';

class WeightLessModel {
  final String id;
  final String purchaseId;
  final String? purchaseReference;
  final String userId;
  final String? userName;
  final String reason;
  final List<WeightLessItemModel> weightLessItems;
  final String? createdDate;
  final String? createdTime;
  final String? updatedDate;
  final String? updatedTime;
  final bool deleted;
  final String? deletedById;
  final String? deletedByName;
  final String? deletedDate;
  final String? deletedTime;

  WeightLessModel({
    required this.id,
    required this.purchaseId,
    this.purchaseReference,
    required this.userId,
    this.userName,
    required this.reason,
    required this.weightLessItems,
    this.createdDate,
    this.createdTime,
    this.updatedDate,
    this.updatedTime,
    this.deleted = false,
    this.deletedById,
    this.deletedByName,
    this.deletedDate,
    this.deletedTime,
  });

  factory WeightLessModel.fromJson(Map<String, dynamic> json) {
    // Parse purchase info
    final purchase = json['purchase'];
    final String purchaseId = purchase != null ? purchase['id']?.toString() ?? '' : '';
    final String? purchaseReference = purchase != null ? purchase['reference']?.toString() : '';

    // Parse user info
    final user = json['user'];
    final String userId = user != null ? user['user_id']?.toString() ?? '' : '';
    final String? userName = user != null
        ? "${user['firstName'] ?? ''} ${user['lastName'] ?? ''}".trim()
        : null;

    // Parse weight less items
    List<WeightLessItemModel> items = [];
    if (json['weightLessItem'] != null && json['weightLessItem'] is List) {
      items = (json['weightLessItem'] as List).map((item) {
        return WeightLessItemModel.fromJson(item);
      }).toList();
    }

    return WeightLessModel(
      id: json['id']?.toString() ?? '',
      purchaseId: purchaseId,
      purchaseReference: purchaseReference,
      userId: userId,
      userName: userName,
      reason: json['reason']?.toString() ?? '',
      weightLessItems: items,
      createdDate: json['created_date']?.toString(),
      createdTime: json['created_time']?.toString(),
      updatedDate: json['updated_date']?.toString(),
      updatedTime: json['updated_time']?.toString(),
      deleted: json['deleted'] == true || json['deleted'] == 'true',
      deletedById: json['deletedById']?.toString(),
      deletedByName: json['deletedByName']?.toString(),
      deletedDate: json['deletedDate']?.toString(),
      deletedTime: json['deletedTime']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'purchaseId': purchaseId,
      'userId': userId,
      'reason': reason,
      'weightLessItem': weightLessItems.map((item) => item.toJson()).toList(),
      if (createdDate != null) 'created_date': createdDate,
      if (createdTime != null) 'created_time': createdTime,
      if (updatedDate != null) 'updated_date': updatedDate,
      if (updatedTime != null) 'updated_time': updatedTime,
      'deleted': deleted,
      if (deletedById != null) 'deletedById': deletedById,
      if (deletedByName != null) 'deletedByName': deletedByName,
      if (deletedDate != null) 'deletedDate': deletedDate,
      if (deletedTime != null) 'deletedTime': deletedTime,
    };
  }

  // Method to create JSON for API requests
  Map<String, dynamic> toApiJson() {
    return {
      'purchaseId': int.tryParse(purchaseId) ?? 0,
      'userId': userId,
      'reason': reason,
      'weightLessItem': weightLessItems.map((item) => item.toApiJson()).toList(),
    };
  }
}