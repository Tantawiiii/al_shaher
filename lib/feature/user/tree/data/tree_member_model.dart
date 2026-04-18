import 'package:flutter/foundation.dart';

/// Media record returned on tree members when an uploaded image exists.
@immutable
class TreeMemberImageModel {
  const TreeMemberImageModel({
    required this.id,
    this.name,
    this.mimeType,
    this.size,
    this.authorId,
    this.previewUrl,
    this.fullUrl,
    this.createdAt,
  });

  final int id;
  final String? name;
  final String? mimeType;
  final int? size;
  final int? authorId;
  final String? previewUrl;
  final String? fullUrl;
  final String? createdAt;

  factory TreeMemberImageModel.fromJson(Map<String, dynamic> json) {
    return TreeMemberImageModel(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString(),
      mimeType: json['mimeType']?.toString(),
      size: (json['size'] as num?)?.toInt(),
      authorId: (json['authorId'] as num?)?.toInt(),
      previewUrl: json['previewUrl']?.toString(),
      fullUrl: json['fullUrl']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}

/// Collapses duplicate slashes in the URL path (e.g. `/storage//images/...`).
String? normalizeTreeMediaUrl(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final schemeIdx = trimmed.indexOf('://');
  if (schemeIdx == -1) return trimmed.replaceAll(RegExp(r'/+'), '/');
  final beforePath = trimmed.substring(0, schemeIdx + 3);
  var rest = trimmed.substring(schemeIdx + 3);
  final slash = rest.indexOf('/');
  if (slash == -1) return trimmed;
  final authority = rest.substring(0, slash);
  var path = rest.substring(slash);
  while (path.contains('//')) {
    path = path.replaceAll('//', '/');
  }
  return '$beforePath$authority$path';
}

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
    this.imageUrl,
    this.image,
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
  final String? imageUrl;
  final TreeMemberImageModel? image;
  final TreeBranch? branch;
  final List<TreeMemberModel> children;

  /// Dead members have `active == false`.
  bool get isDead => !active;

  /// Extract year from date_of_birth (e.g. "1980-01-01" → "1980").
  String? get birthYear {
    if (dateOfBirth == null || dateOfBirth!.length < 4) return null;
    return dateOfBirth!.substring(0, 4);
  }

  /// Best URL for avatar: [image.fullUrl] when present, otherwise [imageUrl].
  String? get avatarUrl {
    final fromImage = normalizeTreeMediaUrl(image?.fullUrl);
    if (fromImage != null) return fromImage;
    return normalizeTreeMediaUrl(imageUrl);
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

    TreeMemberImageModel? image;
    final rawImage = json['image'];
    if (rawImage is Map<String, dynamic>) {
      image = TreeMemberImageModel.fromJson(rawImage);
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
      imageUrl: json['imageUrl']?.toString(),
      image: image,
      branch: branch,
      children: childList,
    );
  }
}
