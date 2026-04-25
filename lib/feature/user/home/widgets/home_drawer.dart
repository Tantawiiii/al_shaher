import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:al_shaher/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/storage/auth_local_storage.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        width: 300.w,
        backgroundColor: AppColors.white,
        child: SafeArea(
          child: Column(
            children: [
              _buildCloseButton(context),
              _buildLogo(),
              14.verticalSpace,
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      icon: Icons.home_outlined,
                      title: AppTexts.home,
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: AppTexts.myProfile,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.myProfile);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.assignment_outlined,
                      title: AppTexts.orderRequest,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.submitRequest);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.flutter_dash_outlined,
                      title: AppTexts.myRequests,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.myRequests);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.people_outline,
                      title: AppTexts.treeTitle,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.familyTree);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.article_outlined,
                      title: AppTexts.familyNews,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.news);
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.calendar_today_outlined,
                      title: AppTexts.events,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.events);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: AppTexts.aboutApp,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.aboutAppDetail);
                },
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: AppTexts.setting,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                },
              ),
              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: AppTexts.logout,
                iconColor: AppColors.error600,
                titleColor: AppColors.error600,
                onTap: () => _onLogout(context),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onLogout(BuildContext context) async {
    final navigator = Navigator.of(context);
    navigator.pop();
    await sl<AuthLocalStorage>().clear();
    navigator.pushNamedAndRemoveUntil(AppRoutes.welcome, (_) => false);
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.neutral100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 20.sp, color: AppColors.neutral400),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Image.asset(
        AppAssets.greenLogo,
        height: 70.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primaryColor500,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppColors.neutral700,
        ),
      ),
      onTap: onTap,
    );
  }
}
