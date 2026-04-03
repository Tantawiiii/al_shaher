import 'package:flutter/foundation.dart';

@immutable
class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.name,
    this.gender,
    this.phone,
    this.nationalId,
    this.dateOfBirth,
    this.city,
    this.motherName,
    this.wifeName,
    required this.active,
    this.imageUrl,
    required this.dead,
    this.branchId,
    this.branchName,
    this.fatherId,
    this.fatherName,
  });

  final int id;
  final String name;
  final String? gender;
  final String? phone;
  final String? nationalId;
  final String? dateOfBirth;
  final String? city;
  final String? motherName;
  final String? wifeName;
  final bool active;
  final String? imageUrl;
  final bool dead;
  final int? branchId;
  final String? branchName;
  final int? fatherId;
  final String? fatherName;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final branch = json['branch'];
    final father = json['father'];

    return AuthUserModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      city: json['city']?.toString(),
      motherName: json['mother_name']?.toString(),
      wifeName: json['wife_name']?.toString(),
      active: json['active'] == true,
      imageUrl: json['imageUrl']?.toString(),
      dead: json['dead'] == true,
      branchId: branch is Map ? (branch['id'] as num?)?.toInt() : null,
      branchName: branch is Map ? branch['name']?.toString() : null,
      fatherId: father is Map ? (father['id'] as num?)?.toInt() : null,
      fatherName: father is Map ? father['name']?.toString() : null,
    );
  }
}
