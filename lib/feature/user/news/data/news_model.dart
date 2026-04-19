import 'package:flutter/foundation.dart';

import '../../../../core/utils/media_url.dart';

@immutable
class GalleryItem {
  const GalleryItem({
    required this.id,
    this.name,
    this.mimeType,
    this.size,
    this.previewUrl,
    this.fullUrl,
    this.createdAt,
  });

  final int id;
  final String? name;
  final String? mimeType;
  final int? size;
  final String? previewUrl;
  final String? fullUrl;
  final String? createdAt;

  /// Best URL for loading the image in the app (handles slashes + relative preview).
  String? get resolvedImageUrl => galleryImageUrl(fullUrl, previewUrl);

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString(),
      mimeType: json['mimeType']?.toString(),
      size: (json['size'] as num?)?.toInt(),
      previewUrl: json['previewUrl']?.toString(),
      fullUrl: json['fullUrl']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}

@immutable
class NewsModel {
  const NewsModel({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    this.gallery = const [],
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String title;
  final String? summary;
  final String? content;
  final List<GalleryItem> gallery;
  final String? createdAt;
  final String? updatedAt;

  String? get firstImageUrl =>
      gallery.isNotEmpty ? gallery.first.resolvedImageUrl : null;

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    final rawGallery = json['gallery'];
    final galleryList = <GalleryItem>[];
    if (rawGallery is List) {
      for (final item in rawGallery) {
        if (item is Map) {
          galleryList.add(
            GalleryItem.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }

    return NewsModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString(),
      content: json['content']?.toString(),
      gallery: galleryList,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}
