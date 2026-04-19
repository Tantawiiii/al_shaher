import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/routing/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppTexts.settingsComingSoon)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.neutral100,
        body: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                children: [
                  _sectionLabel(AppTexts.settingsAccountSection),
                  8.verticalSpace,
                  _card(
                    children: [
                      _tile(
                        icon: Icons.badge_outlined,
                        title: AppTexts.settingsPersonalInfo,
                        onTap: () => _soon(context),
                      ),
                      _divider(),
                      _notificationsRow(),
                      _divider(),
                      _photoVisibilityTile(),
                      _divider(),
                      _tile(
                        icon: Icons.shield_outlined,
                        title: AppTexts.settingsPrivacyPolicy,
                        onTap: () => _soon(context),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  _sectionLabel(AppTexts.settingsAppSection),
                  8.verticalSpace,
                  _card(
                    children: [
                      _tile(
                        icon: Icons.info_outline,
                        title: AppTexts.aboutApp,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.aboutAppDetail,
                        ),
                      ),
                      _divider(),
                      _tile(
                        icon: Icons.share_outlined,
                        title: AppTexts.settingsShareApp,
                        onTap: () => _soon(context),
                      ),
                      _divider(),
                      _tile(
                        icon: Icons.support_agent_outlined,
                        title: AppTexts.settingsSupport,
                        onTap: () => _soon(context),
                      ),
                      _divider(),
                      _tile(
                        icon: Icons.verified_user_outlined,
                        title: AppTexts.settingsDeveloperCompany,
                        onTap: () => _soon(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      child: Row(
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 22.sp,
            color: AppColors.primaryColor600,
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              AppTexts.notificationsTitle,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.neutral800,
              ),
            ),
          ),
          Switch.adaptive(
            value: _notificationsEnabled,
            activeColor: AppColors.success600,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
        ],
      ),
    );
  }

  Widget _photoVisibilityTile() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _soon(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 22.sp,
                color: AppColors.primaryColor600,
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  AppTexts.settingsWhoSeesPhoto,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral800,
                  ),
                ),
              ),
              Text(
                AppTexts.settingsPhotoVisibilityManagement,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.neutral500,
                ),
              ),
              4.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: AppColors.neutral400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.neutral700,
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56.w,
      color: AppColors.neutral200,
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final chevron = Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16.sp,
      color: AppColors.neutral400,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(icon, size: 22.sp, color: AppColors.primaryColor600),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutral800,
                  ),
                ),
              ),
              if (trailing != null) trailing else chevron,
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
        bottom: 16.h,
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
            AppTexts.setting,
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
}
