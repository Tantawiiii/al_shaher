import 'package:flutter/foundation.dart';

@immutable
class AdminPermissionModel {
  const AdminPermissionModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.superAdmin,
    this.imageUrl,
  });

  final int id;
  final String name;
  final String phone;
  final String email;
  final bool superAdmin;
  final String? imageUrl;

  factory AdminPermissionModel.fromJson(Map<String, dynamic> json) {
    return AdminPermissionModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      superAdmin: json['superAdmin'] == true,
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  AdminPermissionModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    bool? superAdmin,
    String? imageUrl,
  }) {
    return AdminPermissionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      superAdmin: superAdmin ?? this.superAdmin,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class AdminPermissionsPaginatedResponse {
  final List<AdminPermissionModel> admins;
  final int currentPage;
  final int lastPage;
  final int total;

  AdminPermissionsPaginatedResponse({
    required this.admins,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}
