import 'package:flutter/foundation.dart';

import '../../../../core/utils/media_url.dart';
import '../../tree/data/tree_member_model.dart';

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
    this.dateOfDeath,
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
  final String? dateOfDeath;
  final String? city;
  final String? motherName;
  final String? wifeName;
  final bool active;
  final String? personalRelationships;
  final String? imageUrl;
  final TreeMemberImageModel? image;
  final BranchInfo? branch;
  final FatherInfo? father;
  final bool dead;
  final List<MemberDetailModel> children;

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
        if (item is Map) {
          childrenList.add(
            MemberDetailModel.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    TreeMemberImageModel? imageModel;
    final rawImage = json['image'];
    if (rawImage is Map<String, dynamic>) {
      imageModel = TreeMemberImageModel.fromJson(rawImage);
    } else if (rawImage is Map) {
      imageModel = TreeMemberImageModel.fromJson(
        Map<String, dynamic>.from(rawImage),
      );
    }

    final top = json['imageUrl']?.toString().trim();
    final topNorm =
        (top != null && top.isNotEmpty) ? normalizeMediaUrl(top) : null;
    final fromNested =
        galleryImageUrl(imageModel?.fullUrl, imageModel?.previewUrl);
    final resolvedImageUrl = (topNorm != null && topNorm.isNotEmpty)
        ? topNorm
        : fromNested;

    return MemberDetailModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? '',
      gender: json['gender']?.toString(),
      phone: json['phone']?.toString(),
      nationalId: json['national_id']?.toString(),
      dateOfBirth: json['date_of_birth']?.toString(),
      dateOfDeath: json['date_of_death']?.toString(),
      city: json['city']?.toString(),
      motherName: json['mother_name']?.toString(),
      wifeName: json['wife_name']?.toString(),
      active: json['active'] == true,
      personalRelationships: json['personal_relationships']?.toString(),
      imageUrl: resolvedImageUrl,
      image: imageModel,
      branch: branch,
      father: father,
      dead: json['dead'] == true,
      children: childrenList,
    );
  }
}
