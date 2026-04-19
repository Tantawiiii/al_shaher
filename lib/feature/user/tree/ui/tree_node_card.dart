import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../data/tree_member_model.dart';

class TreeNodeCard extends StatelessWidget {
  const TreeNodeCard({
    super.key,
    required this.member,
    required this.isCurrentUser,
    this.onAddChild,
    this.onTap,
  });

  final TreeMemberModel member;
  final bool isCurrentUser;
  final VoidCallback? onAddChild;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCard(context),
        if (isCurrentUser && onAddChild != null) ...[
          SizedBox(height: 6.h),
          _buildAddButton(),
        ],
      ],
    );
  }

  Widget _buildCard(BuildContext context) {
    final isDead = member.isDead;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
      width: 140.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDead
            ? AppColors.neutral100.withOpacity(0.85)
            : AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.accentGold600
              : isDead
                  ? AppColors.neutral300
                  : AppColors.neutral200,
          width: isCurrentUser ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isDead
                ? Colors.transparent
                : AppColors.neutral900.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: isDead
                        ? AppColors.neutral500
                        : AppColors.neutral900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                ),
                if (member.birthYear != null) ...[
                  SizedBox(height: 3.h),
                  Text(
                    isDead
                        ? '${member.birthYear}م'
                        : '${member.birthYear} م',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: isDead
                          ? AppColors.neutral400
                          : AppColors.neutral600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
                if (member.city != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    member.city!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.neutral400,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _buildAvatar(),
        ],
      ),
      ),
    );
  }

  Widget _buildAvatar() {
    final isDead = member.isDead;
    final initials = member.name.isNotEmpty ? member.name[0] : '?';
    final photoUrl = member.avatarUrl;

    return Stack(
      children: [
        Container(
          width: 42.r,
          height: 42.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isDead
                ? const LinearGradient(
                    colors: [Color(0xFFBDBDBD), Color(0xFF9E9E9E)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF1FA5A5), Color(0xFF157A7A)],
                  ),
            border: Border.all(
              color: isDead
                  ? AppColors.neutral300
                  : AppColors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: isDead
                    ? Colors.transparent
                    : AppColors.primaryColor500.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: photoUrl != null
              ? CachedNetworkImage(
                  imageUrl: photoUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  placeholder: (_, __) => Center(
                    child: SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
        ),
        if (isDead)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                color: AppColors.neutral600,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 1.5),
              ),
              child: Icon(
                Icons.brightness_1,
                size: 8.r,
                color: AppColors.neutral300,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: onAddChild,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC4A15F), Color(0xFFD4B876)],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold600.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.add_rounded,
          color: AppColors.white,
          size: 20.sp,
        ),
      ),
    );
  }
}
