import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/news_remote_data_source.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(this._remote) : super(const NewsState());

  final NewsRemoteDataSource _remote;

  Future<void> loadNews() async {
    if (isClosed) return;
    emit(state.copyWith(status: NewsStatus.loading, clearError: true));
    try {
      final news = await _remote.fetchNews();
      if (!isClosed) {
        emit(state.copyWith(status: NewsStatus.loaded, newsList: news));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          status: NewsStatus.error,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> loadNewsDetails(int newsId) async {
    if (isClosed) return;
    emit(state.copyWith(
      detailStatus: NewsDetailStatus.loading,
      clearDetailError: true,
      clearSelectedNews: true,
    ));
    try {
      final news = await _remote.fetchNewsDetails(newsId);
      if (!isClosed) {
        emit(state.copyWith(
          detailStatus: NewsDetailStatus.loaded,
          selectedNews: news,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          detailStatus: NewsDetailStatus.error,
          detailError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> uploadImages(List<String> filePaths) async {
    if (isClosed) return;
    emit(state.copyWith(
      formStatus: NewsFormStatus.uploadingImages,
      uploadedImageIds: [],
      uploadProgress: 0,
      totalUploads: filePaths.length,
    ));
    final ids = <int>[];
    try {
      for (int i = 0; i < filePaths.length; i++) {
        final id = await _remote.uploadMedia(filePaths[i]);
        ids.add(id);
        if (!isClosed) {
          emit(state.copyWith(
            uploadedImageIds: List.from(ids),
            uploadProgress: i + 1,
          ));
        }
      }
      if (!isClosed) {
        emit(state.copyWith(
          formStatus: NewsFormStatus.initial,
          uploadedImageIds: ids,
        ));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          formStatus: NewsFormStatus.error,
          formError: e.toString().replaceFirst('Exception: ', ''),
          uploadedImageIds: ids,
        ));
      }
    }
  }

  Future<void> createNews({
    required String title,
    required String summary,
    required String content,
    required List<int> galleryIds,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
        formStatus: NewsFormStatus.submitting, clearFormError: true));
    try {
      await _remote.createNews(
        title: title,
        summary: summary,
        content: content,
        galleryIds: galleryIds,
      );
      if (!isClosed) {
        emit(state.copyWith(formStatus: NewsFormStatus.success));
      }
      await loadNews();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          formStatus: NewsFormStatus.error,
          formError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> updateNews({
    required int newsId,
    required String title,
    required String summary,
    required String content,
    required List<int> galleryIds,
  }) async {
    if (isClosed) return;
    emit(state.copyWith(
        formStatus: NewsFormStatus.submitting, clearFormError: true));
    try {
      await _remote.updateNews(
        newsId: newsId,
        title: title,
        summary: summary,
        content: content,
        galleryIds: galleryIds,
      );
      if (!isClosed) {
        emit(state.copyWith(formStatus: NewsFormStatus.success));
      }
      await loadNews();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          formStatus: NewsFormStatus.error,
          formError: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  Future<void> deleteNews(int newsId) async {
    try {
      await _remote.deleteNews([newsId]);
      await loadNews();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ));
      }
    }
  }

  void resetFormState() {
    emit(state.copyWith(
      formStatus: NewsFormStatus.initial,
      clearFormError: true,
      uploadedImageIds: [],
      uploadProgress: 0,
      totalUploads: 0,
    ));
  }
}
