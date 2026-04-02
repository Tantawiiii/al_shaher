import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_texts.dart';
import '../../../../core/widgets/app_bounce_button.dart';
import 'widgets/relation_widgets.dart';
import 'relation_success_screen.dart';

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

  void _nextStep() {
    setState(() {
      if (currentStep < 4) {
        currentStep++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppAssets.relationBack,
              fit: BoxFit.cover,
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.chevron_right, color: AppColors.white, size: 24.sp),
                        label: Text(
                          AppTexts.registerBack,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                    child: Column(
                      children: [
                        // Step 1
                        _buildStepContent(1),
                        if (currentStep > 1) SizedBox(height: 16.h),
                        
                        // Step 2
                        if (currentStep >= 2) _buildStepContent(2),
                        if (currentStep > 2) SizedBox(height: 16.h),
                        
                        // Step 3
                        if (currentStep >= 3) _buildStepContent(3),
                        if (currentStep > 3) SizedBox(height: 16.h),
                        
                        // Step 4
                        if (currentStep >= 4) _buildStepContent(4),
                        
                        if (currentStep == 4) ...[
                          SizedBox(height: 32.h),
                          AppBounceButton.elevated(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const RelationSuccessScreen()),
                              );
                            },
                            label: AppTexts.relationContinue,
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.primaryColor700,
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
        child: isCompleted
            ? _CompletedView(text: selectedRelationship ?? AppTexts.relationRelationshipDefault)
            : RelationshipSelectionStep(
                onSelected: (val) {
                  setState(() => selectedRelationship = val);
                  _nextStep();
                },
              ),
      );
    } else if (step == 2) {
      return RelationStepCard(
        stepNumber: '02',
        title: AppTexts.relationStep2Title,
        subtitle: AppTexts.relationStep2Subtitle,
        isCompleted: isCompleted,
        showLine: currentStep >= 3,
        child: isCompleted
            ? _CompletedView(text: selectedBranch ?? AppTexts.relationBranchDefault)
            : BranchSelectionStep(
                onSelected: (val) {
                  setState(() => selectedBranch = val);
                  _nextStep();
                },
              ),
      );
    } else if (step == 3) {
      return RelationStepCard(
        stepNumber: '03',
        title: AppTexts.relationStep3Title,
        subtitle: AppTexts.relationStep3Subtitle,
        isCompleted: isCompleted,
        showLine: currentStep >= 4,
        child: isCompleted
            ? _CompletedView(text: selectedFather ?? AppTexts.relationFatherDefault)
            : FatherSearchStep(
                onSelected: (val) {
                  setState(() => selectedFather = val);
                  _nextStep();
                },
              ),
      );
    } else {
      return RelationStepCard(
        stepNumber: '04',
        title: AppTexts.relationStep4Title,
        subtitle: AppTexts.relationStep4Subtitle,
        isCompleted: false,
        showLine: false,
        child: VerificationStep(
          relationship: selectedRelationship ?? AppTexts.relationRelationshipDefault,
          branch: selectedBranch ?? AppTexts.relationBranchDefault,
          fatherName: selectedFather ?? AppTexts.relationFatherDefault,
          onContinue: () {},
        ),
      );
    }
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
