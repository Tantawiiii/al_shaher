import 'package:flutter/foundation.dart';

@immutable
class AdminMemberModel {
  const AdminMemberModel({
    required this.id,
    required this.name,
    this.gender,
    this.phone,
    this.nationalId,
    this.dateOfBirth,
    this.dateOfDeath,
    this.city,
    this.imageUrl,
    this.branchName,
    this.fatherName,
    this.active = false,
    this.dead = false,
  });

  final int id;
  final String name;
  final String? gender;
  final String? phone;
  final String? nationalId;
  final String? dateOfBirth;
  final String? dateOfDeath;
  final String? city;
  final String? imageUrl;
  final String? branchName;
  final String? fatherName;
  final bool active;
  final bool dead;

  factory AdminMemberModel.fromJson(Map<String, dynamic> json) {
    final branch = json['branch'];
    final father = json['father'];
    return AdminMemberModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      dateOfDeath: json['date_of_death']?.toString(),
      city: json['city']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      branchName:
          branch is Map<String, dynamic> ? branch['name']?.toString() : null,
      fatherName:
          father is Map<String, dynamic> ? father['name']?.toString() : null,
      active: json['active'] == true,
      dead: json['dead'] == true,
    );
  }
}
