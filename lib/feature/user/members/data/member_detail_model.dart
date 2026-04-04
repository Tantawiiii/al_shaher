import 'package:flutter/foundation.dart';

@immutable
class BranchInfo {
  const BranchInfo({required this.id, required this.name});

  final int id;
  final String name;

  factory BranchInfo.fromJson(Map<String, dynamic> json) {
    return BranchInfo(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
    );
  }
}

@immutable
class FatherInfo {
  const FatherInfo({required this.id, required this.name});

  final int id;
  final String name;

  factory FatherInfo.fromJson(Map<String, dynamic> json) {
    return FatherInfo(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
    );
  }
}

@immutable
class MemberDetailModel {
  const MemberDetailModel({
    required this.id,
    required this.name,
    this.gender,
    this.phone,
    this.nationalId,
    this.dateOfBirth,
    this.city,
    this.motherName,
    this.wifeName,
    this.active = true,
    this.personalRelationships,
    this.imageUrl,
    this.image,
    this.branch,
    this.father,
    this.dead = false,
    this.children = const [],
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
  final String? personalRelationships;
  final String? imageUrl;
  final int? image;
  final BranchInfo? branch;
  final FatherInfo? father;
  final bool dead;
  final List<MemberDetailModel> children;

  String? get dateOfDeath => dead ? null : null;

  factory MemberDetailModel.fromJson(Map<String, dynamic> json) {
    BranchInfo? branch;
    if (json['branch'] is Map<String, dynamic>) {
      branch = BranchInfo.fromJson(json['branch'] as Map<String, dynamic>);
    }

    FatherInfo? father;
    if (json['father'] is Map<String, dynamic>) {
      father = FatherInfo.fromJson(json['father'] as Map<String, dynamic>);
    }

    final rawChildren = json['children'];
    final childrenList = <MemberDetailModel>[];
    if (rawChildren is List) {
      for (final item in rawChildren) {
        if (item is Map<String, dynamic>) {
          childrenList.add(MemberDetailModel.fromJson(item));
        }
      }
    }

    return MemberDetailModel(
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
      personalRelationships: json['personal_relationships']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      image: (json['image'] as num?)?.toInt(),
      branch: branch,
      father: father,
      dead: json['dead'] == true,
      children: childrenList,
    );
  }
}
