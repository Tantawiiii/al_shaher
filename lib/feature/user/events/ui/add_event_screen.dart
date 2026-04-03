import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';
import '../data/event_model.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key, this.event});

  /// If non-null we are editing, otherwise creating.
  final EventModel? event;

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _timeController;
  DateTime? _selectedDate;

  bool get isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.event?.description ?? '');
    _locationController =
        TextEditingController(text: widget.event?.location ?? '');
    _timeController = TextEditingController(text: widget.event?.time ?? '');
    _selectedDate = widget.event?.date;
    context.read<EventsCubit>().resetFormState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<EventsCubit, EventsState>(
        listenWhen: (p, c) => p.formStatus != c.formStatus,
        listener: (context, state) {
          if (state.formStatus == EventFormStatus.success) {
            Fluttertoast.showToast(
              msg: isEditing
                  ? AppTexts.eventsUpdated
                  : AppTexts.eventsAdded,
              backgroundColor: AppColors.success600,
            );
            Navigator.pop(context);
          } else if (state.formStatus == EventFormStatus.error) {
            Fluttertoast.showToast(
              msg: state.formError ?? 'حدث خطأ',
              backgroundColor: AppColors.error600,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.neutral50,
          body: Column(
            children: [
              _buildAppBar(context),
              Expanded(child: _buildForm()),
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
        bottom: 12.h,
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
            isEditing ? AppTexts.eventsEdit : AppTexts.eventsAdd,
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

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              _buildLabel(AppTexts.eventsName),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _nameController,
                hint: AppTexts.eventsNameHint,
                validator: (v) =>
                    v == null || v.isEmpty ? AppTexts.eventsRequired : null,
              ),
              SizedBox(height: 16.h),

              // Description
              _buildLabel(AppTexts.eventsDescription),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _descriptionController,
                hint: AppTexts.eventsDescriptionHint,
                maxLines: 3,
              ),
              SizedBox(height: 16.h),

              // Date
              _buildLabel(AppTexts.eventsDate),
              SizedBox(height: 8.h),
              _buildDatePicker(),
              SizedBox(height: 16.h),

              // Time
              _buildLabel(AppTexts.eventsTime),
              SizedBox(height: 8.h),
              _buildTimePicker(),
              SizedBox(height: 16.h),

              // Location
              _buildLabel(AppTexts.eventsLocation),
              SizedBox(height: 8.h),
              _buildTextField(
                controller: _locationController,
                hint: AppTexts.eventsLocationHint,
                prefixIcon: Icons.location_on_outlined,
              ),
              SizedBox(height: 32.h),

              // Submit button
              BlocBuilder<EventsCubit, EventsState>(
                buildWhen: (p, c) => p.formStatus != c.formStatus,
                builder: (context, state) {
                  final isLoading =
                      state.formStatus == EventFormStatus.submitting;
                  return SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor600,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor:
                            AppColors.primaryColor400.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 24.r,
                              height: 24.r,
                              child: const CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              isEditing
                                  ? AppTexts.eventsUpdate
                                  : AppTexts.eventsSubmit,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.neutral700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textDirection: TextDirection.rtl,
      validator: validator,
      style: TextStyle(fontSize: 14.sp, color: AppColors.neutral900),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.neutral400),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20.sp, color: AppColors.neutral400)
            : null,
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
          borderSide: const BorderSide(color: AppColors.primaryColor600),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.error600),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }

  Widget _buildDatePicker() {
    final months = [
      '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return Bounce(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (ctx, child) {
            return Theme(
              data: Theme.of(ctx).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor600,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() => _selectedDate = picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.neutral50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20.sp,
              color: AppColors.neutral400,
            ),
            SizedBox(width: 10.w),
            Text(
              _selectedDate != null
                  ? '${_selectedDate!.day} ${months[_selectedDate!.month]} ${_selectedDate!.year}'
                  : AppTexts.eventsSelectDate,
              style: TextStyle(
                fontSize: 14.sp,
                color: _selectedDate != null
                    ? AppColors.neutral900
                    : AppColors.neutral400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Bounce(
      onTap: () async {
        final initial = _timeController.text.isNotEmpty
            ? TimeOfDay(
                hour: int.tryParse(_timeController.text.split(':')[0]) ?? 20,
                minute: int.tryParse(_timeController.text.split(':')[1]) ?? 0,
              )
            : const TimeOfDay(hour: 20, minute: 0);
        final picked = await showTimePicker(
          context: context,
          initialTime: initial,
          builder: (ctx, child) {
            return Theme(
              data: Theme.of(ctx).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: AppColors.primaryColor600,
                ),
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: child!,
              ),
            );
          },
        );
        if (picked != null) {
          setState(() {
            _timeController.text =
                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.neutral50,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 20.sp,
              color: AppColors.neutral400,
            ),
            SizedBox(width: 10.w),
            Text(
              _timeController.text.isNotEmpty
                  ? _timeController.text
                  : AppTexts.eventsSelectTime,
              style: TextStyle(
                fontSize: 14.sp,
                color: _timeController.text.isNotEmpty
                    ? AppColors.neutral900
                    : AppColors.neutral400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      Fluttertoast.showToast(
        msg: AppTexts.eventsSelectDate,
        backgroundColor: AppColors.error600,
      );
      return;
    }

    final dateStr =
        '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}';

    if (isEditing) {
      context.read<EventsCubit>().updateEvent(
            eventId: widget.event!.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            date: dateStr,
            time: _timeController.text.trim(),
            location: _locationController.text.trim(),
          );
    } else {
      context.read<EventsCubit>().createEvent(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            date: dateStr,
            time: _timeController.text.trim(),
            location: _locationController.text.trim(),
          );
    }
  }
}
