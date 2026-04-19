import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/di/injection_container.dart';
import '../../tree/data/auth_user_model.dart';
import '../../tree/data/tree_remote_data_source.dart';
import '../cubit/request_cubit.dart';
import '../cubit/request_state.dart';


class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  AuthUserModel? _currentUser;
  bool _loadingUser = true;
  String? _userError;

  String _requestKind = 'newborn';
  String _gender = 'male';
  DateTime? _pickedDate;

  static const _fillField = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await sl<TreeRemoteDataSource>().fetchCurrentUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
        _loadingUser = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _userError = e.toString().replaceFirst('Exception: ', '');
        _loadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nationalIdCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      labelStyle: TextStyle(fontSize: 14.sp, color: AppColors.neutral500),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      filled: true,
      fillColor: _fillField,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: const BorderSide(color: AppColors.primaryColor500, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: const BorderSide(color: AppColors.error600),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18.r),
        borderSide: const BorderSide(color: AppColors.error600),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = DateTime(1900);
    final picked = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? now,
      firstDate: first,
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor600,
              onPrimary: AppColors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _pickedDate = picked;
        _dateCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _submit() {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppTexts.requestUserLoadFailed)),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_requestKind != 'newborn') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppTexts.requestTypeUnavailable)),
      );
      return;
    }

    final nationalId = _nationalIdCtrl.text.trim();
    final phone = (_currentUser!.phone != null && _currentUser!.phone!.isNotEmpty)
        ? _currentUser!.phone!.trim()
        : nationalId;
    final password = nationalId.length >= 6
        ? nationalId
        : '${nationalId}000000'.substring(0, 8);

    context.read<RequestCubit>().submitSonRequest(
          fatherId: _currentUser!.id,
          name: _nameCtrl.text.trim(),
          gender: _gender,
          phone: phone,
          nationalId: nationalId,
          password: password,
          dateOfBirth: _dateCtrl.text.trim(),
        );
  }

  Future<void> _showSuccessDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72.r,
                    height: 72.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 44.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    AppTexts.requestSuccessTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral900,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    AppTexts.requestSuccessDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.45,
                      color: AppColors.neutral500,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.read<RequestCubit>().reset();
                        Navigator.of(context).maybePop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor600,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        AppTexts.relationContinue,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<RequestCubit, RequestState>(
        listener: (context, state) {
          if (state.status == RequestStatus.success) {
            _showSuccessDialog();
          } else if (state.status == RequestStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.primaryColor700,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 20.h),
                  child: SizedBox(
                    height: 48.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            AppTexts.orderRequest,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Bounce(
                            onTap: () => Navigator.of(context).maybePop(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.white,
                                    size: 18.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    AppTexts.registerBack,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: _loadingUser
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor600,
                          ),
                        )
                      : _userError != null
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(24.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _userError!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.neutral600,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _loadingUser = true;
                                          _userError = null;
                                        });
                                        _loadCurrentUser();
                                      },
                                      child: const Text(AppTexts.relationRetry),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : BlocBuilder<RequestCubit, RequestState>(
                              builder: (context, state) {
                                final submitting =
                                    state.status == RequestStatus.loading;
                                return SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(
                                    20.w,
                                    28.h,
                                    20.w,
                                    24.h,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          AppTexts.requestAddUpdateTitle,
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primaryColor700,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 8.h),
                                        Text(
                                          AppTexts.requestAddUpdateSubtitle,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            height: 1.4,
                                            color: AppColors.neutral500,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(height: 24.h),
                                        DropdownButtonFormField<String>(
                                          value: _requestKind,
                                          decoration: _fieldDecoration(
                                            AppTexts.requestModificationTypeLabel,
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: 'newborn',
                                              child: Text(AppTexts.requestTypeNewborn),
                                            ),
                                            DropdownMenuItem(
                                              value: 'update',
                                              child: Text(AppTexts.requestTypeUpdateStatus),
                                            ),
                                          ],
                                          onChanged: submitting
                                              ? null
                                              : (v) {
                                                  if (v != null) {
                                                    setState(
                                                        () => _requestKind = v);
                                                  }
                                                },
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: _nameCtrl,
                                          textInputAction: TextInputAction.next,
                                          decoration: _decoration(
                                            AppTexts.requestNewbornNameLabel,
                                          ),
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? AppTexts.fieldRequired
                                                  : null,
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: _nationalIdCtrl,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          decoration: _decoration(
                                            AppTexts.requestNewbornNationalIdLabel,
                                          ),
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? AppTexts.fieldRequired
                                                  : null,
                                        ),
                                        SizedBox(height: 16.h),
                                        TextFormField(
                                          controller: _dateCtrl,
                                          readOnly: true,
                                          onTap: submitting
                                              ? null
                                              : () => _pickDate(),
                                          decoration: _fieldDecoration(
                                            AppTexts.registerBirthDate,
                                            suffixIcon: IconButton(
                                              onPressed: submitting
                                                  ? null
                                                  : _pickDate,
                                              icon: Icon(
                                                Icons.calendar_today_outlined,
                                                color: AppColors.neutral500,
                                                size: 20.sp,
                                              ),
                                            ),
                                          ),
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? AppTexts.fieldRequired
                                                  : null,
                                        ),
                                        SizedBox(height: 16.h),
                                        DropdownButtonFormField<String>(
                                          value: _gender,
                                          decoration: _fieldDecoration(
                                            AppTexts.registerGender,
                                          ),
                                          items: [
                                            DropdownMenuItem(
                                              value: 'male',
                                              child: Text(AppTexts.registerGenderMale),
                                            ),
                                            DropdownMenuItem(
                                              value: 'female',
                                              child: Text(AppTexts.registerGenderFemale),
                                            ),
                                          ],
                                          onChanged: submitting
                                              ? null
                                              : (v) {
                                                  if (v != null) {
                                                    setState(
                                                        () => _gender = v);
                                                  }
                                                },
                                        ),
                                        SizedBox(height: 32.h),
                                        SizedBox(
                                          height: 54.h,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed:
                                                submitting ? null : _submit,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primaryColor600,
                                              foregroundColor: AppColors.white,
                                              elevation: 0,
                                              shape: const StadiumBorder(),
                                            ),
                                            child: submitting
                                                ? SizedBox(
                                                    width: 24.r,
                                                    height: 24.r,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      strokeWidth: 2.4,
                                                      color: AppColors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    AppTexts.requestSubmitButton,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return _fieldDecoration(label);
  }
}
