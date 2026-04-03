import 'package:flutter/foundation.dart';

@immutable
class TreeBranch {
  const TreeBranch({required this.id, required this.name});

  final int id;
  final String name;

  factory TreeBranch.fromJson(Map<String, dynamic> json) {
    return TreeBranch(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
    );
  }
}

@immutable
class TreeMemberModel {
  const TreeMemberModel({
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
    this.branch,
    required this.children,
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
  final TreeBranch? branch;
  final List<TreeMemberModel> children;

  /// Dead members have `active == false`.
  bool get isDead => !active;

  /// Extract year from date_of_birth (e.g. "1980-01-01" → "1980").
  String? get birthYear {
    if (dateOfBirth == null || dateOfBirth!.length < 4) return null;
    return dateOfBirth!.substring(0, 4);
  }

  factory TreeMemberModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];
    final childList = <TreeMemberModel>[];
    if (rawChildren is List) {
      for (final child in rawChildren) {
        if (child is Map<String, dynamic>) {
          childList.add(TreeMemberModel.fromJson(child));
        }
      }
    }

    TreeBranch? branch;
    final rawBranch = json['branch'];
    if (rawBranch is Map<String, dynamic>) {
      branch = TreeBranch.fromJson(rawBranch);
    }

    return TreeMemberModel(
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
      branch: branch,
      children: childList,
    );
  }
}
