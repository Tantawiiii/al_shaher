import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/routing/app_routes.dart';
import '../../auth/register/data/models/member_model.dart';
import '../../members/cubit/members_cubit.dart';
import '../../members/cubit/members_state.dart';

class RecentlyAddedSection extends StatelessWidget {
  const RecentlyAddedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersCubit, MembersState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                AppTexts.newComers,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            _buildContent(state),
          ],
        );
      },
    );
  }

  Widget _buildContent(MembersState state) {
    switch (state.status) {
      case MembersStatus.initial:
      case MembersStatus.loading:
        return const _RecentlyAddedShimmer();
      case MembersStatus.error:
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Center(
            child: Text(
              state.errorMessage ?? 'حدث خطأ',
              style: TextStyle(fontSize: 13.sp, color: AppColors.neutral400),
            ),
          ),
        );
      case MembersStatus.loaded:
        if (state.members.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Center(
              child: Text(
                'لا يوجد أعضاء',
                style: TextStyle(fontSize: 13.sp, color: AppColors.neutral400),
              ),
            ),
          );
        }
        return SizedBox(
          height: 60.r,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            scrollDirection: Axis.horizontal,
            itemCount: state.members.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              if (index == 0) return _buildShareButton();
              return _MemberAvatar(member: state.members[index - 1]);
            },
          ),
        );
    }
  }

  Widget _buildShareButton() {
    return Bounce(
      onTap: () {},
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor700,
        ),
        child: Icon(
          Icons.ios_share_rounded,
          color: AppColors.white,
          size: 28.sp,
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({required this.member});

  final MemberModel member;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.memberProfile,
        arguments: member.id,
      ),
      child: Container(
        width: 60.r,
        height: 60.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor200,
          border: Border.all(color: AppColors.white, width: 2.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral900.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: member.imageUrl != null && member.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: member.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _placeholderIcon(),
                errorWidget: (_, __, ___) => _placeholderIcon(),
              )
            : _placeholderIcon(),
      ),
    );
  }

  Widget _placeholderIcon() {
    return Center(
      child: Text(
        member.name.isNotEmpty ? member.name[0] : '؟',
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _RecentlyAddedShimmer extends StatelessWidget {
  const _RecentlyAddedShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.r,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.primaryColor900.withOpacity(0.35),
          highlightColor: AppColors.white.withOpacity(0.4),
          child: Container(
            width: 60.r,
            height: 60.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neutral200,
            ),
          ),
        ),
      ),
    );
  }
}
