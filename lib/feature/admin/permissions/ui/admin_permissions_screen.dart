import 'package:al_shaher/core/constant/app_colors.dart';
import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/feature/admin/permissions/cubit/admin_permissions_cubit.dart';
import 'package:al_shaher/feature/admin/permissions/cubit/admin_permissions_state.dart';
import 'package:al_shaher/feature/admin/permissions/data/admin_permission_model.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminPermissionsScreen extends StatefulWidget {
  const AdminPermissionsScreen({super.key});

  @override
  State<AdminPermissionsScreen> createState() => _AdminPermissionsScreenState();
}

class _AdminPermissionsScreenState extends State<AdminPermissionsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<AdminPermissionsCubit>().loadAdmins();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.9) {
      context.read<AdminPermissionsCubit>().loadAdmins();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.primaryColor700,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    _buildAddSection(),
                    SizedBox(height: 30.h),
                    Text(
                      AppTexts.adminPermissionsUsersWithPermissions,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.neutral700,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Expanded(child: _buildAdminsList()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10.h,
        bottom: 30.h,
        left: 20.w,
        right: 20.w,
      ),
      child: Row(
        children: [
          Bounce(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: AppColors.white, size: 16.sp),
                SizedBox(width: 5.w),
                Text(
                  AppTexts.registerBack,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            AppTexts.adminPermissionsTitle,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          SizedBox(width: 50.w), 
        ],
      ),
    );
  }

  Widget _buildAddSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اضافة صلاحيات الادارة والمشرفين',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.neutral700,
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          hintText: AppTexts.adminPermissionsSearchHint,
                          hintStyle: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.neutral400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Container(
                      height: 25.h,
                      width: 1,
                      color: AppColors.neutral300,
                      margin: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                    Row(
                      children: [
                        Text(
                          AppTexts.adminPermissionsSupervisor,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.neutral700,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: AppColors.neutral700, size: 20.sp),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Bounce(
              onTap: () {}, 
              child: Container(
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor600,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Center(
                  child: Text(
                    AppTexts.adminPermissionsAssign,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminsList() {
    return BlocBuilder<AdminPermissionsCubit, AdminPermissionsState>(
      builder: (context, state) {
        if (state.status == AdminPermissionsStatus.loading && state.admins.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor600));
        }
        if (state.status == AdminPermissionsStatus.error && state.admins.isEmpty) {
          return Center(child: Text(state.errorMessage ?? 'Error'));
        }
        if (state.admins.isEmpty && state.status == AdminPermissionsStatus.loaded) {
          return const Center(child: Text('لا يوجد مشرفين'));
        }

        return ListView.separated(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 20.h),
          itemCount: state.admins.length + (state.isLoadingMore ? 1 : 0),
          separatorBuilder: (_, __) => Divider(color: AppColors.neutral100, height: 30.h),
          itemBuilder: (context, index) {
            if (index >= state.admins.length) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: AppColors.primaryColor600),
              ));
            }
            return _buildAdminItem(state.admins[index]);
          },
        );
      },
    );
  }

  Widget _buildAdminItem(AdminPermissionModel admin) {
    return Row(
      children: [
        ClipOval(
          child: admin.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: admin.imageUrl!,
                  width: 50.w,
                  height: 50.w,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 50.w,
                  height: 50.w,
                  color: AppColors.neutral200,
                  child: Icon(Icons.person, color: AppColors.neutral400),
                ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                admin.name,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                admin.email,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<bool>(
              value: admin.superAdmin,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.neutral500, size: 18.sp),
              isDense: true,
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(15.r),
              items: [
                DropdownMenuItem(
                  value: true,
                  child: Text(
                    AppTexts.adminPermissionsManagement,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text(
                    AppTexts.adminPermissionsSupervisor,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral500,
                    ),
                  ),
                ),
              ],
              onChanged: (val) {
                if (val != null && val != admin.superAdmin) {
                  context.read<AdminPermissionsCubit>().toggleSuperAdmin(admin.id);
                }
              },
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Icon(Icons.more_vert, color: AppColors.neutral400, size: 24.sp),
      ],
    );
  }
}
