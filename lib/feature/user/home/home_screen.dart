import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_colors.dart';
import 'widgets/home_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                const HomeHeader(),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 70.h,
                  left: 20.w,
                  right: 20.w,
                  child: const QuickLinksCard(),
                ),
              ],
            ),

            SizedBox(height: 70.h),
            const RecentlyAddedSection(),
            SizedBox(height: 24.h),
            const FamilyNewsSection(),
            SizedBox(height: 24.h),
            const EventsSection(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
