import 'dart:io';

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/widgets/app_form_text_field.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';
import '../data/news_model.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({super.key, this.news});

  final NewsModel? news;

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _summaryController;
  late final TextEditingController _contentController;

  final List<XFile> _pickedImages = [];
  List<int> _existingGalleryIds = [];

  bool get isEditing => widget.news != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.news?.title ?? '');
    _summaryController =
        TextEditingController(text: widget.news?.summary ?? '');
    _contentController =
        TextEditingController(text: widget.news?.content ?? '');

    if (widget.news != null) {
      _existingGalleryIds =
          widget.news!.gallery.map((g) => g.id).toList();
    }

    context.read<NewsCubit>().resetFormState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<NewsCubit, NewsState>(
        listenWhen: (p, c) => p.formStatus != c.formStatus,
        listener: (context, state) {
          if (state.formStatus == NewsFormStatus.success) {
            Fluttertoast.showToast(
              msg: isEditing ? AppTexts.newsUpdated : AppTexts.newsAdded,
              backgroundColor: AppColors.success600,
            );
            Navigator.pop(context);
          } else if (state.formStatus == NewsFormStatus.error) {
            Fluttertoast.showToast(
              msg: state.formError ?? 'حدث خطأ',
              backgroundColor: AppColors.error600,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.neutral50,
          body: Column(
            children: [
              _buildAppBar(context),
              Expanded(child: _buildForm()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryColor700, AppColors.primaryColor600],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor900.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Bounce(
            onTap: () => Navigator.pop(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_outlined,
                  color: AppColors.white,
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  AppTexts.registerBack,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            isEditing ? AppTexts.newsEdit : AppTexts.newsAdd,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          SizedBox(width: 60.w),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(AppTexts.newsFieldTitle),
            SizedBox(height: 8.h),
            AppFormTextField(
              controller: _titleController,
              hintText: AppTexts.newsFieldTitleHint,
              textInputAction: TextInputAction.next,
              fillColor: AppColors.neutral50,
              unfocusedBorderColor: AppColors.neutral200,
              borderRadius: 12.r,
              borderWidth: 1,
              textStyle:
                  TextStyle(fontSize: 14.sp, color: AppColors.neutral900),
              hintStyle:
                  TextStyle(fontSize: 14.sp, color: AppColors.neutral400),
            ),
            SizedBox(height: 16.h),

            _buildLabel(AppTexts.newsFieldSummary),
            SizedBox(height: 8.h),
            AppFormTextField(
              controller: _summaryController,
              hintText: AppTexts.newsFieldSummaryHint,
              maxLines: 2,
              textInputAction: TextInputAction.next,
              fillColor: AppColors.neutral50,
              unfocusedBorderColor: AppColors.neutral200,
              borderRadius: 12.r,
              borderWidth: 1,
              textStyle:
                  TextStyle(fontSize: 14.sp, color: AppColors.neutral900),
              hintStyle:
                  TextStyle(fontSize: 14.sp, color: AppColors.neutral400),
            ),
            SizedBox(height: 16.h),

            _buildLabel(AppTexts.newsFieldContent),
            SizedBox(height: 8.h),
            AppFormTextField(
              controller: _contentController,
              hintText: AppTexts.newsFieldContentHint,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              fillColor: AppColors.neutral50,
              unfocusedBorderColor: AppColors.neutral200,
              borderRadius: 12.r,
              borderWidth: 1,
              textStyle:
                  TextStyle(fontSize: 14.sp, color: AppColors.neutral900),
              hintStyle:
                  TextStyle(fontSize: 14.sp, color: AppColors.neutral400),
            ),
            SizedBox(height: 16.h),

            _buildLabel(AppTexts.newsGallery),
            SizedBox(height: 8.h),
            _buildGalleryPicker(),
            SizedBox(height: 32.h),

            BlocBuilder<NewsCubit, NewsState>(
              buildWhen: (p, c) =>
                  p.formStatus != c.formStatus ||
                  p.uploadProgress != c.uploadProgress,
              builder: (context, state) {
                final isUploading =
                    state.formStatus == NewsFormStatus.uploadingImages;
                final isSubmitting =
                    state.formStatus == NewsFormStatus.submitting;
                final isLoading = isUploading || isSubmitting;

                String buttonText;
                if (isUploading) {
                  buttonText =
                      '${AppTexts.newsUploading} (${state.uploadProgress}/${state.totalUploads})';
                } else if (isSubmitting) {
                  buttonText = 'جاري الحفظ...';
                } else {
                  buttonText =
                      isEditing ? AppTexts.eventsUpdate : AppTexts.eventsSubmit;
                }

                return SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor600,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor:
                          AppColors.primaryColor400.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 22.r,
                                height: 22.r,
                                child: const CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                buttonText,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            buttonText,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral700,
      ),
    );
  }

  Widget _buildGalleryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing && _existingGalleryIds.isNotEmpty) ...[
          Text(
            '${AppTexts.newsExistingImages}: ${_existingGalleryIds.length}',
            style: TextStyle(fontSize: 12.sp, color: AppColors.neutral500),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            height: 80.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.news!.gallery.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                final img = widget.news!.gallery[index];
                final isRemoved = !_existingGalleryIds.contains(img.id);
                return Stack(
                  children: [
                    Opacity(
                      opacity: isRemoved ? 0.3 : 1.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          img.resolvedImageUrl ?? '',
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80.w,
                            height: 80.w,
                            color: AppColors.neutral200,
                            child: const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2.r,
                      left: 2.r,
                      child: Bounce(
                        onTap: () {
                          setState(() {
                            if (isRemoved) {
                              _existingGalleryIds.add(img.id);
                            } else {
                              _existingGalleryIds.remove(img.id);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: BoxDecoration(
                            color: isRemoved
                                ? AppColors.success600
                                : AppColors.error600,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRemoved ? Icons.add : Icons.close,
                            color: AppColors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
        ],
        if (_pickedImages.isNotEmpty) ...[
          SizedBox(
            height: 80.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _pickedImages.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (_, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Image.file(
                        File(_pickedImages[index].path),
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2.r,
                      left: 2.r,
                      child: Bounce(
                        onTap: () {
                          setState(() => _pickedImages.removeAt(index));
                        },
                        child: Container(
                          padding: EdgeInsets.all(2.r),
                          decoration: const BoxDecoration(
                            color: AppColors.error600,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 12.h),
        ],
        Bounce(
          onTap: _pickImages,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.neutral200,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: AppColors.primaryColor600,
                  size: 32.sp,
                ),
                SizedBox(height: 6.h),
                Text(
                  AppTexts.newsPickImages,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primaryColor600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 85);
    if (images.isNotEmpty) {
      setState(() => _pickedImages.addAll(images));
    }
  }

  Future<void> _onSubmit() async {
    if (_titleController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: AppTexts.eventsRequired,
        backgroundColor: AppColors.error600,
      );
      return;
    }

    final cubit = context.read<NewsCubit>();
    List<int> galleryIds = List.from(_existingGalleryIds);

    if (_pickedImages.isNotEmpty) {
      final paths = _pickedImages.map((f) => f.path).toList();
      await cubit.uploadImages(paths);
      final state = cubit.state;
      if (state.formStatus == NewsFormStatus.error) return;
      galleryIds.addAll(state.uploadedImageIds);
    }

    if (isEditing) {
      cubit.updateNews(
        newsId: widget.news!.id,
        title: _titleController.text.trim(),
        summary: _summaryController.text.trim(),
        content: _contentController.text.trim(),
        galleryIds: galleryIds,
      );
    } else {
      cubit.createNews(
        title: _titleController.text.trim(),
        summary: _summaryController.text.trim(),
        content: _contentController.text.trim(),
        galleryIds: galleryIds,
      );
    }
  }
}
