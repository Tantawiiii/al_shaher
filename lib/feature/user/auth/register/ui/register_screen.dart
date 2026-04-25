import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/app_bounce_button.dart';
import '../../../../../core/widgets/app_form_text_field.dart';
import '../../relation/cubit/branch_cubit.dart';
import '../../relation/cubit/father_cubit.dart';
import '../../relation/ui/relation_screen.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  final _nationalIdFocus = FocusNode();

  XFile? _pickedImage;
  String? _gender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _nationalIdFocus.dispose();
    super.dispose();
  }

  String _birthDateToIso(String display) {
    final parts = display.split('/');
    if (parts.length != 3) return display;
    final y = parts[0].trim();
    final m = parts[1].trim().padLeft(2, '0');
    final d = parts[2].trim().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _pickedImage = file);
    }
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1940),
      lastDate: now,
      locale: const Locale('ar'),
    );
    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() {
        _birthController.text = '$y/$m/$d';
      });
    }
  }

  Future<void> _onContinue() async {
    final name = _firstNameController.text.trim();
    final nationalId = _nationalIdController.text.trim();
    final phone = _phoneController.text.trim();
    final birth = _birthController.text.trim();
    final city = _cityController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty ||
        nationalId.isEmpty ||
        phone.isEmpty ||
        city.isEmpty ||
        password.isEmpty) {
      Fluttertoast.showToast(msg: AppTexts.registerValidationError);
      return;
    }
    if (_pickedImage == null) {
      Fluttertoast.showToast(msg: AppTexts.registerImageRequired);
      return;
    }

    final cubit = context.read<RegisterCubit>();
    await cubit.completeRegisterStep(
      name: name,
      nationalId: nationalId,
      phoneDigits: phone,
      dateOfBirthIso: birth.isEmpty ? null : _birthDateToIso(birth),
      city: city,
      password: password,
      gender: _gender,
      imageFilePath: _pickedImage!.path,
    );

    if (!mounted) return;
    final s = cubit.state;
    if (s.imageId == null) {
      return;
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: cubit),
            BlocProvider(
              create: (_) => sl<BranchCubit>()..fetchBranches(),
            ),
            BlocProvider(
              create: (_) => sl<FatherCubit>(),
            ),
          ],
          child: const RelationScreen(),
        ),
      ),
    );
  }

  Widget _phoneCountryPrefix() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Text(
        //   '+966',
        //   style: TextStyle(
        //     fontSize: 15.sp,
        //     fontWeight: FontWeight.w600,
        //     color: AppColors.neutral700,
        //   ),
        // ),
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

  Widget _genderField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _gender,
          hint: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              AppTexts.fieldOptional,
              style: TextStyle(fontSize: 15.sp, color: AppColors.neutral500),
            ),
          ),
          isExpanded: true,
          alignment: AlignmentDirectional.centerEnd,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.neutral500,
          ),
          items: [
            DropdownMenuItem(
              value: 'male',
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  AppTexts.registerGenderMale,
                  style: TextStyle(fontSize: 15.sp, color: AppColors.neutral900),
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'female',
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  AppTexts.registerGenderFemale,
                  style: TextStyle(fontSize: 15.sp, color: AppColors.neutral900),
                ),
              ),
            ),
          ],
          onChanged: (v) {
            if (v != null) setState(() => _gender = v);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (p, c) => p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.isNotEmpty &&
            state.status == RegisterStatus.failure) {
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
                SizedBox(height: 8.h),
                Center(
                  child: Image.asset(
                    AppAssets.greenLogo,
                    height: 56.h,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20.h),
                Center(child: _buildAvatarPicker()),
                SizedBox(height: 20.h),
                Text(
                  AppTexts.registerTitle,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor700,
                  ),
                ),
                SizedBox(height: 24.h),
                AppFormTextField(
                  controller: _firstNameController,
                  hintText: AppTexts.registerFirstName,
                  leadingIcon: const Icon(Icons.person_outline_rounded),
                  helperText: AppTexts.registerFirstNameHelper,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                AppFormTextField(
                  controller: _nationalIdController,
                  hintText: AppTexts.registerNationalId,
                  leadingIcon: const Icon(Icons.badge_outlined),
                  focusNode: _nationalIdFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                AppFormTextField(
                  controller: _phoneController,
                  hintText: AppTexts.registerPhone,
                  leadingIcon: const Icon(Icons.smartphone_outlined),
                  trailing: _phoneCountryPrefix(),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                AppFormTextField(
                  controller: _birthController,
                  hintText: AppTexts.registerBirthDate,
                  leadingIcon: const Icon(Icons.calendar_today_outlined),
                  readOnly: true,
                  onTap: _pickBirthDate,
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                AppFormTextField(
                  controller: _cityController,
                  hintText: AppTexts.registerCity,
                  leadingIcon: const Icon(Icons.location_on_outlined),
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppTexts.registerGender,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral700,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _genderField(),
                SizedBox(height: 16.h),
                AppFormTextField(
                  controller: _passwordController,
                  hintText: AppTexts.registerPassword,
                  leadingIcon: const Icon(Icons.lock_outline_rounded),
                  obscureText: true,
                  showPasswordToggle: true,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: 32.h),
                BlocBuilder<RegisterCubit, RegisterState>(
                  buildWhen: (p, c) => p.status != c.status,
                  builder: (context, state) {
                    final loading =
                        state.status == RegisterStatus.uploadingImage;
                    return AppBounceButton.elevated(
                      onPressed: loading ? null : _onContinue,
                      label: loading
                          ? AppTexts.registerUploading
                          : AppTexts.registerSubmit,
                      backgroundColor: AppColors.primaryColor700,
                    );
                  },
                ),
                SizedBox(height: 16.h),
                _PrivacyFooter(
                  onPrivacyTap: () {},
                ),
                SizedBox(height: 12.h),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.neutral500,
                        ),
                        children: [
                          TextSpan(text: AppTexts.registerHaveAccount),
                          TextSpan(
                            text: AppTexts.registerSignIn,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPicker() {
    final size = 104.r;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickImage,
        customBorder: const CircleBorder(),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.neutral100,
            border: Border.all(
              color: AppColors.primaryColor300,
              width: 2,
            ),
          ),
          child: _pickedImage != null
              ? ClipOval(
                  child: Image.file(
                    File(_pickedImage!.path),
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                  ),
                )
              : Icon(
                  Icons.photo_camera_outlined,
                  size: 40.sp,
                  color: AppColors.primaryColor500,
                ),
        ),
      ),
    );
  }
}

class _PrivacyFooter extends StatefulWidget {
  const _PrivacyFooter({required this.onPrivacyTap});

  final VoidCallback onPrivacyTap;

  @override
  State<_PrivacyFooter> createState() => _PrivacyFooterState();
}

class _PrivacyFooterState extends State<_PrivacyFooter> {
  late final TapGestureRecognizer _linkTap;

  @override
  void initState() {
    super.initState();
    _linkTap = TapGestureRecognizer()..onTap = widget.onPrivacyTap;
  }

  @override
  void dispose() {
    _linkTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      fontSize: 12.sp,
      color: AppColors.neutral400,
      height: 1.4,
    );
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(
            text: AppTexts.registerPrivacyPrefix,
          ),
          TextSpan(
            text: AppTexts.registerPrivacyLink,
            style: base.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.neutral600,
            ),
            recognizer: _linkTap,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
