import 'package:flutter/foundation.dart';

import '../data/news_model.dart';

enum NewsStatus { initial, loading, loaded, error }

enum NewsDetailStatus { initial, loading, loaded, error }

enum NewsFormStatus { initial, submitting, uploadingImages, success, error }

@immutable
class NewsState {
  const NewsState({
    this.status = NewsStatus.initial,
    this.newsList = const [],
    this.errorMessage,
    this.detailStatus = NewsDetailStatus.initial,
    this.selectedNews,
    this.detailError,
    this.formStatus = NewsFormStatus.initial,
    this.formError,
    this.uploadedImageIds = const [],
    this.uploadProgress = 0,
    this.totalUploads = 0,
  });

  final NewsStatus status;
  final List<NewsModel> newsList;
  final String? errorMessage;

  final NewsDetailStatus detailStatus;
  final NewsModel? selectedNews;
  final String? detailError;

  final NewsFormStatus formStatus;
  final String? formError;
  final List<int> uploadedImageIds;
  final int uploadProgress;
  final int totalUploads;

  NewsState copyWith({
    NewsStatus? status,
    List<NewsModel>? newsList,
    String? errorMessage,
    NewsDetailStatus? detailStatus,
    NewsModel? selectedNews,
    String? detailError,
    NewsFormStatus? formStatus,
    String? formError,
    List<int>? uploadedImageIds,
    int? uploadProgress,
    int? totalUploads,
    bool clearError = false,
    bool clearDetailError = false,
    bool clearFormError = false,
    bool clearSelectedNews = false,
  }) {
    return NewsState(
      status: status ?? this.status,
      newsList: newsList ?? this.newsList,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      detailStatus: detailStatus ?? this.detailStatus,
      selectedNews:
          clearSelectedNews ? null : (selectedNews ?? this.selectedNews),
      detailError:
          clearDetailError ? null : (detailError ?? this.detailError),
      formStatus: formStatus ?? this.formStatus,
      formError: clearFormError ? null : (formError ?? this.formError),
      uploadedImageIds: uploadedImageIds ?? this.uploadedImageIds,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      totalUploads: totalUploads ?? this.totalUploads,
    );
  }
}
