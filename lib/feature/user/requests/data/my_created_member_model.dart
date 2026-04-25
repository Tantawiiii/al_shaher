import 'package:flutter/foundation.dart';

@immutable
class MyCreatedMemberModel {
  const MyCreatedMemberModel({
    required this.id,
    required this.name,
    required this.applicationNumber,
    this.nationalId,
    this.phone,
    this.dateOfBirth,
    this.createdAt,
    this.active = false,
    this.dead = false,
    this.branchName,
  });

  final int id;
  final String name;
  final String applicationNumber;
  final String? nationalId;
  final String? phone;
  final String? dateOfBirth;
  final String? createdAt;
  final bool active;
  final bool dead;
  final String? branchName;

  factory MyCreatedMemberModel.fromJson(Map<String, dynamic> json) {
    final rawBranch = json['branch'];
    final branchMap = rawBranch is Map
        ? Map<String, dynamic>.from(rawBranch)
        : null;

    return MyCreatedMemberModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      applicationNumber: json['application_number']?.toString() ?? '-',
      nationalId: json['national_id']?.toString(),
      phone: json['phone']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      createdAt: json['created_at']?.toString(),
      active: json['active'] == true,
      dead: json['dead'] == true,
      branchName: branchMap?['name']?.toString(),
    );
  }
}
