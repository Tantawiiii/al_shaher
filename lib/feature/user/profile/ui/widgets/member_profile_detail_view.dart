import 'package:bounce/bounce.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../members/data/member_detail_model.dart';

/// Shared scrollable body for member profile (tree member or `/check-auth` user).
class MemberProfileDetailScrollView extends StatelessWidget {
  const MemberProfileDetailScrollView({super.key, required this.member});

  final MemberDetailModel member;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _MemberProfileHeader(member: member),
          SizedBox(height: 24.h),
          _MemberProfileInfoSection(member: member),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}

class _MemberProfileHeader extends StatelessWidget {
  const _MemberProfileHeader({required this.member});

  final MemberDetailModel member;

  @override
  Widget build(BuildContext context) {
    final bannerH = 220.h;
    final avatarR = 52.r;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: bannerH + avatarR,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: bannerH,
                child: _BannerCover(member: member, height: bannerH),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(bottom: false, child: ProfileBackRow()),
              ),
              Positioned(bottom: 0, child: _Avatar(member: member)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
          child: Column(
            children: [
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
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
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
}

class _BannerCover extends StatelessWidget {
  const _BannerCover({required this.member, required this.height});

  final MemberDetailModel member;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = member.imageUrl;
    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        placeholder: (_, __) => _BannerPlaceholderGradient(height: height),
        errorWidget: (_, __, ___) =>
            _BannerPlaceholderGradient(height: height),
      );
    }
    return _BannerPlaceholderGradient(height: height);
  }
}

class _BannerPlaceholderGradient extends StatelessWidget {
  const _BannerPlaceholderGradient({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryColor700, AppColors.primaryColor600],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.member});

  final MemberDetailModel member;

  @override
  Widget build(BuildContext context) {
    final size = 104.r;
    return Container(
      width: size,
      height: size,
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
      child: ClipOval(
        clipBehavior: Clip.antiAlias,
        child: member.imageUrl != null && member.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: member.imageUrl!,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: size,
                height: size,
                placeholder: (_, __) => _AvatarPlaceholder(member: member),
                errorWidget: (_, __, ___) => _AvatarPlaceholder(member: member),
              )
            : _AvatarPlaceholder(member: member),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.member});

  final MemberDetailModel member;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: AppColors.primaryColor600,
        child: Center(
          child: Text(
            member.name.isNotEmpty ? member.name[0] : '؟',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberProfileInfoSection extends StatelessWidget {
  const _MemberProfileInfoSection({required this.member});

  final MemberDetailModel member;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (member.father != null)
            ProfileInfoRow(
              label: AppTexts.fatherName,
              value: member.father!.name,
              icon: Icons.person_outline,
            ),
          if (member.motherName != null && member.motherName!.isNotEmpty)
            ProfileInfoRow(
              label: AppTexts.motherName,
              value: member.motherName!,
              icon: Icons.person_outline,
              iconColor: AppColors.primaryColor400,
            ),
          if (member.dateOfBirth != null && member.dateOfBirth!.isNotEmpty)
            ProfileInfoRow(
              label: AppTexts.birthdate,
              value: _formatDate(member.dateOfBirth!),
              icon: Icons.groups_outlined,
            ),
          if (member.dead)
            ProfileInfoRow(
              label: AppTexts.death,
              value:
                  (member.dateOfDeath != null && member.dateOfDeath!.isNotEmpty)
                  ? _formatDate(member.dateOfDeath!)
                  : 'نعم',
              icon: Icons.groups_outlined,
            ),
          if (member.wifeName != null && member.wifeName!.isNotEmpty)
            ProfileInfoRow(
              label: AppTexts.wife,
              value: member.wifeName!,
              icon: Icons.person_outline,
              iconColor: AppColors.primaryColor400,
            ),
          if (member.city != null && member.city!.isNotEmpty)
            ProfileInfoRow(
              label: AppTexts.city,
              value: member.city!,
              icon: Icons.location_on_outlined,
            ),
          if (member.children.isNotEmpty)
            _ChildrenRow(children: member.children),
        ],
      ),
    );
  }

  String _formatDate(String raw) {
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return AppTexts.formatDateArabicDayMonthYear(dt);
  }
}

class _ChildrenRow extends StatelessWidget {
  const _ChildrenRow({required this.children});

  final List<MemberDetailModel> children;

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
                      child: _ChildrenAvatars(children: children),
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
}

class _ChildrenAvatars extends StatelessWidget {
  const _ChildrenAvatars({required this.children});

  final List<MemberDetailModel> children;

  @override
  Widget build(BuildContext context) {
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
}

/// Back button on gradient / banner (white text).
class ProfileBackRow extends StatelessWidget {
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

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
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
