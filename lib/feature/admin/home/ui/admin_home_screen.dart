import 'package:al_shaher/core/constant/app_texts.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/constant/app_colors.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor800,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        _buildGrid(context),
                        SizedBox(height: 20.h),
                        _buildStatisticsCard(),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppTexts.adminDashboardTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset(
          //     AppAssets.menuIcon,
          //     colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          //     width: 24.w,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final items = [
      {
        'title': AppTexts.adminJoinRequests,
        'icon': Icons.account_tree_outlined,
      },
      {'title': AppTexts.familyTree, 'icon': Icons.account_tree_rounded},
      // {'title': AppTexts.adminUpdateStatus, 'icon': Icons.layers_outlined},
      {'title': AppTexts.news, 'icon': Icons.description_outlined},
      {'title': AppTexts.events, 'icon': Icons.edit_note_rounded},
      {'title': AppTexts.members, 'icon': Icons.people_outline_rounded},
      {'title': AppTexts.adminPermissions, 'icon': Icons.lock_person_outlined},
      // {'title': AppTexts.adminActivityLog, 'icon': Icons.manage_search_rounded},
       {'title': AppTexts.notificationsTitle, 'icon': Icons.notifications_active_outlined},
      {'title': AppTexts.setting, 'icon': Icons.settings_outlined},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15.w,
        mainAxisSpacing: 15.h,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final title = items[index]['title'] as String;
        return _buildGridItem(
          title,
          items[index]['icon'] as IconData,
          () => _onGridItemTap(context, title),
        );
      },
    );
  }

  void _onGridItemTap(BuildContext context, String title) {
    if (title == AppTexts.news) {
      Navigator.pushNamed(context, AppRoutes.adminNews);
    } else if (title == AppTexts.events) {
      Navigator.pushNamed(context, AppRoutes.adminEvents);
    }
    // else if (title == AppTexts.adminUpdateStatus) {
    //   Navigator.pushNamed(context, AppRoutes.adminOrders);
    // }
    else if (title == AppTexts.adminJoinRequests) {
      Navigator.pushNamed(context, AppRoutes.adminOrders);
    } else if (title == AppTexts.familyTree) {
      Navigator.pushNamed(context, AppRoutes.familyTree);
    } else if (title == AppTexts.members) {
      Navigator.pushNamed(context, AppRoutes.adminMembers);
    } else if (title == AppTexts.setting) {
      Navigator.pushNamed(context, AppRoutes.adminSettings);
    } else if (title == AppTexts.adminPermissions) {
      Navigator.pushNamed(context, AppRoutes.adminPermissions);
    }
  }

  Widget _buildGridItem(String title, IconData icon, VoidCallback onClick) {
    return Bounce(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.accentGold600, size: 35.sp),
            SizedBox(height: 10.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor500,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppTexts.adminStatistics,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "${AppTexts.adminRegisteredThisMonth} 124 مستخدم",
                style: TextStyle(
                  color: AppColors.accentGold400,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 150.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(10, (index) {
                final height1 = (index + 2) * 10.0;
                final height2 = (index + 1) * 8.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 8.w,
                          height: height1.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff157A7A),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Container(
                          width: 8.w,
                          height: height2.h,
                          decoration: BoxDecoration(
                            color: AppColors.accentGold400,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      (10 - index).toString().padLeft(2, '0'),
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
