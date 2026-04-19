import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../cubit/members_cubit.dart';
import '../cubit/members_state.dart';
import '../data/member_detail_model.dart';

class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen({super.key, required this.memberId});

  final int memberId;

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MembersCubit>().loadMemberDetails(widget.memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral50,
        body: BlocBuilder<MembersCubit, MembersState>(
          builder: (context, state) {
            switch (state.detailStatus) {
              case MemberDetailStatus.initial:
              case MemberDetailStatus.loading:
                return const _ProfileShimmer();
              case MemberDetailStatus.error:
                return _buildError(state.detailError);
              case MemberDetailStatus.loaded:
                if (state.selectedMember == null) {
                  return _buildError(null);
                }
                return _buildContent(context, state.selectedMember!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildError(String? error) {
    return SafeArea(
      child: Column(
        children: [
          _BackRow(),
          Expanded(
            child: Center(
              child: Text(
                error ?? 'حدث خطأ',
                style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, MemberDetailModel member) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context, member),
          SizedBox(height: 24.h),
          _buildInfoSection(member),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, MemberDetailModel member) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryColor700, AppColors.primaryColor600],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _BackRow(),
            SizedBox(height: 8.h),
            _buildAvatar(member),
            SizedBox(height: 16.h),
            Text(
              member.name,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            if (member.branch != null) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor700,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  member.branch!.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(MemberDetailModel member) {
    return Container(
      width: 100.r,
      height: 100.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor200,
        border: Border.all(color: AppColors.white, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: member.imageUrl != null && member.imageUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: member.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => _avatarPlaceholder(member),
              errorWidget: (_, __, ___) => _avatarPlaceholder(member),
            )
          : _avatarPlaceholder(member),
    );
  }

  Widget _avatarPlaceholder(MemberDetailModel member) {
    return Center(
      child: Text(
        member.name.isNotEmpty ? member.name[0] : '؟',
        style: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildInfoSection(MemberDetailModel member) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (member.father != null)
            _InfoRow(
              label: AppTexts.fatherName,
              value: member.father!.name,
              icon: Icons.person_outline,
            ),
          if (member.motherName != null && member.motherName!.isNotEmpty)
            _InfoRow(
              label: AppTexts.motherName,
              value: member.motherName!,
              icon: Icons.person_outline,
              iconColor: AppColors.primaryColor400,
            ),
          if (member.dateOfBirth != null && member.dateOfBirth!.isNotEmpty)
            _InfoRow(
              label: AppTexts.birthdate,
              value: _formatDate(member.dateOfBirth!),
              icon: Icons.groups_outlined,
            ),
          if (member.dead)
            _InfoRow(
              label: AppTexts.death,
              value:
                  (member.dateOfDeath != null && member.dateOfDeath!.isNotEmpty)
                  ? _formatDate(member.dateOfDeath!)
                  : 'نعم',
              icon: Icons.groups_outlined,
            ),
          if (member.wifeName != null && member.wifeName!.isNotEmpty)
            _InfoRow(
              label: AppTexts.wife,
              value: member.wifeName!,
              icon: Icons.person_outline,
              iconColor: AppColors.primaryColor400,
            ),
          if (member.city != null && member.city!.isNotEmpty)
            _InfoRow(
              label: AppTexts.city,
              value: member.city!,
              icon: Icons.location_on_outlined,
            ),
          if (member.children.isNotEmpty) _buildChildrenRow(member.children),
        ],
      ),
    );
  }

  Widget _buildChildrenRow(List<MemberDetailModel> children) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppTexts.children,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.neutral500,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${children.length} ${AppTexts.children}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedBox(
                      height: 36.r,
                      child: _buildChildrenAvatars(children),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.groups_outlined,
              color: AppColors.primaryColor600,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenAvatars(List<MemberDetailModel> children) {
    final display = children.take(4).toList();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(display.length, (i) {
        return Transform.translate(
          offset: Offset(i * 10.0.w, 0),
          child: Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor200,
              border: Border.all(color: AppColors.white, width: 2.w),
            ),
            clipBehavior: Clip.antiAlias,
            child:
                display[i].imageUrl != null && display[i].imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: display[i].imageUrl!,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Text(
                      display[i].name.isNotEmpty ? display[i].name[0] : '؟',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
          ),
        );
      }),
    );
  }

  String _formatDate(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return AppTexts.formatDateArabicDayMonthYear(dt);
  }
}

class _BackRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Align(
        alignment: Alignment.centerRight,
        child: Bounce(
          onTap: () => Navigator.pop(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_outlined,
                color: AppColors.white,
                size: 18.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                AppTexts.registerBack,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.neutral500,
                  ),
                ),
                if (value.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primaryColor600,
              size: 22.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.primaryColor900.withOpacity(0.35),
            highlightColor: AppColors.white.withOpacity(0.4),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 60.h,
                bottom: 24.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryColor100,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32.r),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 110.r,
                    height: 110.r,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neutral200,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 20.h,
                    width: 160.w,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    height: 32.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: AppColors.neutral200,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: List.generate(
                5,
                (i) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Shimmer.fromColors(
                    baseColor: AppColors.primaryColor900.withOpacity(0.35),
                    highlightColor: AppColors.white.withOpacity(0.4),
                    child: Container(
                      height: 72.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
