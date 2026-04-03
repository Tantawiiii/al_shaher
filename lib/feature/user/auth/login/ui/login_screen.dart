
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import '../../../../../core/widgets/app_form_text_field.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget phoneCountryPrefix() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '+966',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.neutral700,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          width: 1,
          height: 22.h,
          color: AppColors.neutral300,
        ),
        SizedBox(width: 10.w),
        SvgPicture.asset(
          AppAssets.saudiArabia,
          width: 26.w,
          height: 22.h,
        ),
        SizedBox(width: 6.w),
      ],
    );
  }

  Future<void> _onLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    if (phone.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: AppTexts.registerValidationError);
      return;
    }
    await context.read<LoginCubit>().submit(
          phoneDigits: phone,
          password: password,
        );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.home,
            (route) => false,
          );
        } else if (state.status == LoginStatus.failure &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          Fluttertoast.showToast(msg: state.errorMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(
                      Icons.chevron_left,
                      size: 22.sp,
                      color: AppColors.primaryColor700,
                    ),
                    label: Text(
                      AppTexts.registerBack,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Center(
                  child: Image.asset(
                    AppAssets.greenLogo,
                    height: 106.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 26.h),
                Text(
                  "${AppTexts.loginWelcomeTitle}  ${AppTexts.loginWelcomeEmoji}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor700,
                  ),
                ),
                SizedBox(height: 24.h),
                AppFormTextField(
                  controller: _phoneController,
                  hintText: AppTexts.registerPhone,
                  leadingIcon: const Icon(Icons.smartphone_outlined),
                  trailing: phoneCountryPrefix(),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                AppFormTextField(
                  controller: _passwordController,
                  hintText: AppTexts.registerPassword,
                  leadingIcon: const Icon(Icons.lock_outline_rounded),
                  obscureText: true,
                  showPasswordToggle: true,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 42.h),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    final loading = state.status == LoginStatus.loading;
                    return AppBounceButton.elevated(
                      onPressed: loading ? null : _onLogin,
                      label: loading
                          ? AppTexts.relationSubmitting
                          : AppTexts.loginSignIn,
                      backgroundColor: AppColors.primaryColor700,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
