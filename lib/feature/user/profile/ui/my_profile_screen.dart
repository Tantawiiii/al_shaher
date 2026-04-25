import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import 'widgets/member_profile_detail_view.dart';
import 'widgets/profile_loading_shimmer.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<ProfileCubit, ProfileState>(
        listenWhen: (p, c) => p.deleteAccountStatus != c.deleteAccountStatus,
        listener: (context, state) async {
          if (state.deleteAccountStatus == DeleteAccountStatus.failure &&
              state.deleteAccountMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.deleteAccountMessage!)),
            );
          }
          if (state.deleteAccountStatus == DeleteAccountStatus.success) {
            final msg = state.deleteAccountMessage ?? 'تم حذف الحساب';
            await sl<AuthLocalStorage>().clear();
            if (!mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.welcome, (_) => false);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.neutral50,
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              final deleting =
                  state.deleteAccountStatus == DeleteAccountStatus.loading;
              switch (state.status) {
                case ProfileStatus.initial:
                case ProfileStatus.loading:
                  return const ProfileLoadingShimmer();
                case ProfileStatus.failure:
                  return _buildError(state.errorMessage);
                case ProfileStatus.loaded:
                  final profile = state.profile;
                  if (profile == null) {
                    return _buildError(null);
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: MemberProfileDetailScrollView(
                          member: profile.member,
                        ),
                      ),
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton.icon(
                              onPressed: deleting
                                  ? null
                                  : () => _onDeleteAccountTapped(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error600,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                              icon: deleting
                                  ? SizedBox(
                                      width: 18.r,
                                      height: 18.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Icon(Icons.delete_outline_rounded),
                              label: Text(
                                AppTexts.deleteAccount,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onDeleteAccountTapped(BuildContext context) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(AppTexts.deleteAccountConfirmTitle),
          content: const Text(AppTexts.deleteAccountConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(AppTexts.eventsCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                AppTexts.deleteAccountConfirmAction,
                style: TextStyle(color: AppColors.error600),
              ),
            ),
          ],
        ),
      ),
    );
    if (yes == true && mounted) {
      context.read<ProfileCubit>().deleteMyAccount();
    }
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
