import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../cubit/members_cubit.dart';
import '../cubit/members_state.dart';
import '../../profile/ui/widgets/member_profile_detail_view.dart';
import '../../profile/ui/widgets/profile_loading_shimmer.dart';

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
                return const ProfileLoadingShimmer();
              case MemberDetailStatus.error:
                return _buildError(state.detailError);
              case MemberDetailStatus.loaded:
                if (state.selectedMember == null) {
                  return _buildError(null);
                }
                return MemberProfileDetailScrollView(
                  member: state.selectedMember!,
                );
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 18.sp,
                  color: AppColors.primaryColor600,
                ),
                label: Text(
                  AppTexts.registerBack,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  error ?? 'حدث خطأ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
