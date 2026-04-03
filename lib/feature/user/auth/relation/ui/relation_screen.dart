import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_colors.dart';
import '../../../../../core/constant/app_texts.dart';
import '../../../../../core/widgets/app_bounce_button.dart';

import '../../register/cubit/register_cubit.dart';
import '../../register/cubit/register_state.dart';
import '../../register/data/models/application_form_summary.dart';
import '../../register/data/models/branch_model.dart';
import '../../register/data/models/member_model.dart';
import 'relation_success_screen.dart';
import '../widgets/relation_widgets.dart';

class RelationScreen extends StatefulWidget {
  const RelationScreen({super.key});

  @override
  State<RelationScreen> createState() => _RelationScreenState();
}

class _RelationScreenState extends State<RelationScreen> {
  int currentStep = 1;
  String? selectedRelationship;
  String? selectedBranch;
  String? selectedFather;
  int? _selectedBranchId;

  void _nextStep() {
    setState(() {
      if (currentStep < 4) {
        currentStep++;
      }
    });
  }

  Future<void> _submitApplication() async {
    await context.read<RegisterCubit>().submitApplication();
  }

  void _goToSuccess(RegisterState state) {
    final summary = ApplicationFormSummary.fromRegisterAndLabels(
      register: state,
      relationshipLabel:
          selectedRelationship ?? AppTexts.relationRelationshipDefault,
      branchName: selectedBranch ?? AppTexts.relationBranchDefault,
      fatherName: selectedFather ?? AppTexts.relationFatherDefault,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => RelationSuccessScreen(summary: summary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (p, c) =>
          p.status != c.status || p.errorMessage != c.errorMessage,
      listener: (context, state) {
        if (state.status == RegisterStatus.success) {
          _goToSuccess(state);
        } else if (state.status == RegisterStatus.failure &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          Fluttertoast.showToast(msg: state.errorMessage!);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppAssets.relationBack, fit: BoxFit.cover),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppTexts.relationHeader,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (currentStep > 1) {
                              setState(() {
                                currentStep--;
                              });
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                AppTexts.registerBack,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.white,
                                size: 24.sp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        children: [
                          _buildStepContent(1),
                          if (currentStep > 1) SizedBox(height: 16.h),
                          if (currentStep >= 2) _buildStepContent(2),
                          if (currentStep > 2) SizedBox(height: 16.h),
                          if (currentStep >= 3) _buildStepContent(3),
                          if (currentStep > 3) SizedBox(height: 16.h),
                          if (currentStep >= 4) _buildStepContent(4),
                          if (currentStep == 4) ...[
                            SizedBox(height: 32.h),
                            BlocBuilder<RegisterCubit, RegisterState>(
                              buildWhen: (p, c) =>
                                  p.status != c.status,
                              builder: (context, state) {
                                final loading = state.status ==
                                    RegisterStatus.submittingApplication;
                                return AppBounceButton.elevated(
                                  onPressed: loading ? null : _submitApplication,
                                  label: loading
                                      ? AppTexts.relationSubmitting
                                      : AppTexts.relationContinue,
                                  backgroundColor: AppColors.white,
                                  foregroundColor: AppColors.primaryColor700,
                                );
                              },
                            ),
                          ],
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(int step) {
    final bool isCompleted = currentStep > step;

    if (step == 1) {
      return RelationStepCard(
        stepNumber: '01',
        title: AppTexts.relationStep1Title,
        subtitle: AppTexts.relationStep1Subtitle,
        isCompleted: isCompleted,
        showLine: currentStep >= 2,
        onEdit: () => setState(() => currentStep = 1),
        child: isCompleted
            ? _CompletedView(
                text: selectedRelationship ??
                    AppTexts.relationRelationshipDefault,
              )
            : RelationshipSelectionStep(
                onSelected: (val) {
                  context.read<RegisterCubit>().setPersonalRelationships([val]);
                  setState(() => selectedRelationship = val);
                  _nextStep();
                },
              ),
      );
    }

    if (step == 2) {
      return RelationStepCard(
        stepNumber: '02',
        title: AppTexts.relationStep2Title,
        subtitle: AppTexts.relationStep2Subtitle,
        isCompleted: isCompleted,
        showLine: currentStep >= 3,
        onEdit: () => setState(() {
          currentStep = 2;
          selectedFather = null;
        }),
        child: isCompleted
            ? _CompletedView(
                text: selectedBranch ?? AppTexts.relationBranchDefault,
              )
            : BranchSelectionStep(
                onConfirmed: (BranchModel b) {
                  context.read<RegisterCubit>().setBranchId(b.id);
                  setState(() {
                    selectedBranch = b.name;
                    _selectedBranchId = b.id;
                    selectedFather = null;
                  });
                  _nextStep();
                },
              ),
      );
    }

    if (step == 3) {
      final bid = _selectedBranchId;
      return RelationStepCard(
        stepNumber: '03',
        title: AppTexts.relationStep3Title,
        subtitle: AppTexts.relationStep3Subtitle,
        isCompleted: isCompleted,
        showLine: currentStep >= 4,
        onEdit: () => setState(() => currentStep = 3),
        child: isCompleted
            ? _CompletedView(
                text: selectedFather ?? AppTexts.relationFatherDefault,
              )
            : bid == null
                ? Text(
                    AppTexts.relationSelectBranchFirst,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  )
                : FatherSearchStep(
                    branchId: bid,
                    onConfirmed: (MemberModel m) {
                      context.read<RegisterCubit>().setFatherId(m.id);
                      setState(() => selectedFather = m.name);
                      _nextStep();
                    },
                  ),
      );
    }

    return RelationStepCard(
      stepNumber: '04',
      title: AppTexts.relationStep4Title,
      subtitle: AppTexts.relationStep4Subtitle,
      isCompleted: false,
      showLine: false,
      child: VerificationStep(
        relationship:
            selectedRelationship ?? AppTexts.relationRelationshipDefault,
        branch: selectedBranch ?? AppTexts.relationBranchDefault,
        fatherName: selectedFather ?? AppTexts.relationFatherDefault,
      ),
    );
  }
}

class _CompletedView extends StatelessWidget {
  const _CompletedView({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor900.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
