import 'package:al_shaher/core/constant/app_assets.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../cubit/tree_cubit.dart';
import '../cubit/tree_state.dart';
import 'tree_layout_widget.dart';

class TreeScreen extends StatefulWidget {
  const TreeScreen({super.key});

  @override
  State<TreeScreen> createState() => _TreeScreenState();
}

class _TreeScreenState extends State<TreeScreen> {
  final _searchController = TextEditingController();
  final _transformationController = TransformationController();

  @override
  void dispose() {
    _searchController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        body: Stack(
          children: [
            Column(
              children: [
                _buildAppBar(context),
                _buildSearchBar(),
                Expanded(child: _buildBody()),
              ],
            ),
            Positioned(
              bottom: 24.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold600.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(40.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentGold600.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Bounce(
                        onTap: _zoomOut,
                        child: SvgPicture.asset(
                          AppAssets.zoomOutIcon,
                          width: 28.w,
                          height: 28.h,
                        ),
                      ),
                      12.horizontalSpace,
                      Container(
                        width: 1.4,
                        height: 24.h,
                        color: AppColors.white.withOpacity(0.2),
                      ),
                      12.horizontalSpace,
                      Bounce(
                        onTap: _zoomIn,
                        child: SvgPicture.asset(
                          AppAssets.zoomInIcon,
                          width: 28.w,
                          height: 28.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _zoomIn() {
    const factor = 1.1;
    final matrix = _transformationController.value.clone()..scale(factor);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    const factor = 1 / 1.1;
    final matrix = _transformationController.value.clone()..scale(factor);
    _transformationController.value = matrix;
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
            AppTexts.treeTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
          const Spacer(),
          Bounce(
            onTap: () {
              // TODO: export/download tree
            },
            child: Icon(
              Icons.download_outlined,
              color: AppColors.white,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Icon(
              Icons.filter_list_rounded,
              color: AppColors.neutral600,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.neutral200),
              ),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 14.sp, color: AppColors.neutral900),
                decoration: InputDecoration(
                  hintText: AppTexts.treeSearchHint,
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.neutral400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.neutral400,
                    size: 22.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                ),
                onChanged: (value) {
                  context.read<TreeCubit>().search(value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<TreeCubit, TreeState>(
      builder: (context, state) {
        switch (state.status) {
          case TreeStatus.initial:
          case TreeStatus.loading:
            return _buildLoading();
          case TreeStatus.error:
            return _buildError(state.errorMessage ?? 'حدث خطأ');
          case TreeStatus.loaded:
            return _buildTree(state);
        }
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: const CircularProgressIndicator(
              color: AppColors.primaryColor600,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل الشجرة...',
            style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.error600,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(fontSize: 14.sp, color: AppColors.neutral600),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => context.read<TreeCubit>().loadTree(),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor600,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTree(TreeState state) {
    if (state.roots.isEmpty) {
      return Center(
        child: Text(
          state.searchQuery.isNotEmpty
              ? 'لا توجد نتائج للبحث'
              : 'لا توجد بيانات',
          style: TextStyle(fontSize: 16.sp, color: AppColors.neutral400),
        ),
      );
    }

    return InteractiveViewer(
      transformationController: _transformationController,
      constrained: false,
      minScale: 0.3,
      maxScale: 3.0,
      boundaryMargin: EdgeInsets.all(200.w),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            if (state.roots.isNotEmpty && state.roots.first.branch != null)
              _buildBranchBadge(state.roots.first.branch!.name),
            if (state.roots.isNotEmpty && state.roots.first.branch != null)
              SizedBox(height: 16.h),
            TreeLayoutWidget(
              roots: state.roots,
              currentUserId: state.currentUser?.id,
              onAddChild: (parent) => _showAddChildDialog(parent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchBadge(String branchName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor600, AppColors.primaryColor700],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor700.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        'فرع $branchName',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
    );
  }

  void _showAddChildDialog(dynamic parent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.neutral300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  AppTexts.treeAddChild,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.neutral900,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'سيتم إضافة هذه الميزة قريباً',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.neutral500,
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor600,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: const Text('حسناً'),
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
