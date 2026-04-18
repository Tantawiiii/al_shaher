import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/app_form_text_field.dart';
import '../../requests/cubit/request_cubit.dart';
import '../../requests/cubit/request_state.dart';
import '../data/tree_member_model.dart';

enum _AddMemberKind { son, father }

class AddChildRequestSheet extends StatefulWidget {
  const AddChildRequestSheet({super.key, required this.parent, this.onSuccess});

  final TreeMemberModel parent;
  final VoidCallback? onSuccess;

  static Future<void> show(
    BuildContext context, {
    required TreeMemberModel parent,
    VoidCallback? onSuccess,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider(
        create: (_) => sl<RequestCubit>(),
        child: AddChildRequestSheet(parent: parent, onSuccess: onSuccess),
      ),
    );
  }

  @override
  State<AddChildRequestSheet> createState() => _AddChildRequestSheetState();
}

class _AddChildRequestSheetState extends State<AddChildRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  final _dobFieldKey = GlobalKey<FormFieldState<String>>();
  final _dodFieldKey = GlobalKey<FormFieldState<String>>();
  _AddMemberKind _kind = _AddMemberKind.son;

  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _nationalId = TextEditingController();
  final _password = TextEditingController();
  final _dateOfBirth = TextEditingController();
  final _dateOfDeath = TextEditingController();

  String _gender = 'male';
  bool _dead = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _nationalId.dispose();
    _password.dispose();
    _dateOfBirth.dispose();
    _dateOfDeath.dispose();
    super.dispose();
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontSize: 13.sp, color: AppColors.neutral500),
      filled: true,
      fillColor: AppColors.neutral50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(
          color: AppColors.primaryColor600,
          width: 1.4,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
    );
  }

  Future<void> _pickDate({
    required TextEditingController controller,
    DateTime? lastDate,
    FormFieldState<String>? formField,
  }) async {
    if (!mounted) return;
    final now = DateTime.now();
    final parsed = DateTime.tryParse(controller.text);
    var initial = parsed ?? now;
    if (initial.isAfter(now)) initial = now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: lastDate ?? now,
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
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        controller.text = formatted;
      });
      formField?.didChange(formatted);
    }
  }

  Widget _calendarTrailing(bool loading, VoidCallback onTap) {
    return IconButton(
      onPressed: loading ? null : onTap,
      icon: Icon(
        Icons.calendar_today_outlined,
        color: AppColors.neutral500,
        size: 20.sp,
      ),
    );
  }

  Widget _appFormLine({
    Key? formFieldKey,
    required TextEditingController controller,
    required String hintText,
    required String? Function() validator,
    required bool loading,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    bool showPasswordToggle = false,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return FormField<String>(
      key: formFieldKey,
      validator: (_) => validator(),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFormTextField(
              controller: controller,
              hintText: hintText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              obscureText: obscureText,
              showPasswordToggle: showPasswordToggle,
              readOnly: readOnly,
              enabled: !loading,
              onTap: onTap,
              trailing: trailing,
              onChanged: (_) => field.didChange(controller.text),
              borderRadius: 12.r,
              fillColor: AppColors.neutral50,
              focusedBorderColor: AppColors.primaryColor600,
              unfocusedBorderColor: AppColors.neutral200,
              borderWidth: 1,
            ),
            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(top: 4.h, right: 4.w),
                child: Text(
                  field.errorText!,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.error600),
                ),
              ),
          ],
        );
      },
    );
  }

  void _submit() {
    if (_kind == _AddMemberKind.father &&
        _dead &&
        _dateOfDeath.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppTexts.addChildDeathDateRequired)),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<RequestCubit>();
    final pid = widget.parent.id;
    if (_kind == _AddMemberKind.son) {
      cubit.submitSonRequest(
        fatherId: pid,
        name: _name.text.trim(),
        gender: _gender,
        phone: _phone.text.trim(),
        nationalId: _nationalId.text.trim(),
        password: _password.text.trim(),
        dateOfBirth: _dateOfBirth.text.trim(),
      );
    } else {
      cubit.submitFatherRequest(
        fatherId: pid,
        name: _name.text.trim(),
        gender: _gender,
        dateOfBirth: _dateOfBirth.text.trim(),
        phone: _phone.text.trim(),
        nationalId: _nationalId.text.trim(),
        password: _password.text.trim(),
        dateOfDeath: _dateOfDeath.text.trim(),
        dead: _dead,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottom),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: BlocConsumer<RequestCubit, RequestState>(
            listener: (context, state) {
              if (state.status == RequestStatus.success) {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.of(context).pop();
                widget.onSuccess?.call();
                messenger.showSnackBar(
                  const SnackBar(content: Text(AppTexts.addChildRequestSent)),
                );
              } else if (state.status == RequestStatus.failure &&
                  state.errorMessage != null) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
            builder: (context, state) {
              final loading = state.status == RequestStatus.loading;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: loading
                              ? null
                              : () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.neutral600,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            AppTexts.treeAddChild,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.neutral900,
                            ),
                          ),
                        ),
                        SizedBox(width: 48.w),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      AppTexts.addChildTreeParentLine(widget.parent.name),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.neutral600,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SegmentedButton<_AddMemberKind>(
                      segments: [
                        ButtonSegment(
                          value: _AddMemberKind.son,
                          label: Text(AppTexts.addChildSegmentSon),
                        ),
                        ButtonSegment(
                          value: _AddMemberKind.father,
                          label: Text(AppTexts.addChildSegmentFather),
                        ),
                      ],
                      selected: {_kind},
                      onSelectionChanged: loading
                          ? null
                          : (s) {
                              setState(() => _kind = s.first);
                            },
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _appFormLine(
                              controller: _name,
                              hintText: AppTexts.addChildNameLabel,
                              loading: loading,
                              textInputAction: TextInputAction.next,
                              validator: () => _name.text.trim().isEmpty
                                  ? AppTexts.fieldRequired
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            DropdownButtonFormField<String>(
                              value: _gender,
                              decoration: _dropdownDecoration(
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
                              onChanged: loading
                                  ? null
                                  : (v) {
                                      if (v != null)
                                        setState(() => _gender = v);
                                    },
                            ),
                            SizedBox(height: 12.h),
                            _appFormLine(
                              controller: _phone,
                              hintText: AppTexts.addChildPhoneLabel,
                              loading: loading,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: () => _phone.text.trim().isEmpty
                                  ? AppTexts.fieldRequired
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            _appFormLine(
                              controller: _nationalId,
                              hintText: AppTexts.addChildNationalIdLabel,
                              loading: loading,
                              textInputAction: TextInputAction.next,
                              validator: () => _nationalId.text.trim().isEmpty
                                  ? AppTexts.fieldRequired
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            _appFormLine(
                              controller: _password,
                              hintText: AppTexts.addChildPasswordLabel,
                              loading: loading,
                              obscureText: true,
                              showPasswordToggle: true,
                              textInputAction: TextInputAction.next,
                              validator: () => _password.text.trim().isEmpty
                                  ? AppTexts.fieldRequired
                                  : null,
                            ),
                            SizedBox(height: 12.h),
                            _appFormLine(
                              formFieldKey: _dobFieldKey,
                              controller: _dateOfBirth,
                              hintText: AppTexts.registerBirthDate,
                              loading: loading,
                              readOnly: true,
                              onTap: loading
                                  ? null
                                  : () {
                                      _pickDate(
                                        controller: _dateOfBirth,
                                        formField: _dobFieldKey.currentState,
                                      );
                                    },
                              trailing: _calendarTrailing(loading, () {
                                _pickDate(
                                  controller: _dateOfBirth,
                                  formField: _dobFieldKey.currentState,
                                );
                              }),
                              validator: () => _dateOfBirth.text.trim().isEmpty
                                  ? AppTexts.fieldRequired
                                  : null,
                            ),
                            if (_kind == _AddMemberKind.father) ...[
                              SizedBox(height: 12.h),
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  AppTexts.treeDeceased,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.neutral800,
                                  ),
                                ),
                                value: _dead,
                                onChanged: loading
                                    ? null
                                    : (v) => setState(() => _dead = v),
                              ),
                              _appFormLine(
                                formFieldKey: _dodFieldKey,
                                controller: _dateOfDeath,
                                hintText: _dead
                                    ? AppTexts.addChildDeathDateRequiredLabel
                                    : AppTexts.addChildDeathDateOptionalLabel,
                                loading: loading,
                                readOnly: true,
                                onTap: loading
                                    ? null
                                    : () {
                                        _pickDate(
                                          controller: _dateOfDeath,
                                          formField: _dodFieldKey.currentState,
                                        );
                                      },
                                trailing: _calendarTrailing(loading, () {
                                  _pickDate(
                                    controller: _dateOfDeath,
                                    formField: _dodFieldKey.currentState,
                                  );
                                }),
                                validator: () {
                                  if (!_dead) return null;
                                  return _dateOfDeath.text.trim().isEmpty
                                      ? AppTexts.fieldRequired
                                      : null;
                                },
                              ),
                            ],
                            SizedBox(height: 24.h),
                            SizedBox(
                              height: 50.h,
                              child: ElevatedButton(
                                onPressed: loading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor600,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                ),
                                child: loading
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          color: AppColors.white,
                                        ),
                                      )
                                    : Text(
                                        AppTexts.addChildSubmitButton,
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
