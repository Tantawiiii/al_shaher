import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constant/app_assets.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_texts.dart';
import '../../core/routing/app_routes.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnBoardingModel> _onBoardingData = [
    OnBoardingModel(
      image: AppAssets.onboard1,
      title: AppTexts.onboarding1Title,
      description: AppTexts.onboarding1Description,
    ),
    OnBoardingModel(
      image: AppAssets.onboard2,
      title: AppTexts.onboarding2Title,
      description: AppTexts.onboarding2Description,
    ),
    OnBoardingModel(
      image: AppAssets.onboard3,
      title: AppTexts.onboarding3Title,
      description: AppTexts.onboarding3Description,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.onbordingBack,
              fit: BoxFit.cover,
            ),
          ),

          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onBoardingData.length,
                  itemBuilder: (context, index) {
                    return OnBoardingPage(model: _onBoardingData[index]);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _onBoardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: _currentPage == index ? 24.w : 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: _currentPage == index 
                                ? AppColors.primaryColor600 
                                : AppColors.neutral300,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 48.h),
                     Bounce(
                        onTap: () {
                          if (_currentPage < _onBoardingData.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.pushReplacementNamed(context, AppRoutes.welcome);
                          }
                        },
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor900,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final OnBoardingModel model;

  const OnBoardingPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 4),
          SvgPicture.asset(
            model.image,
            height: 240.h,
          ),
          const Spacer(),
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor900,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            model.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              color: AppColors.neutral600,
            ),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}

class OnBoardingModel {
  final String image;
  final String title;
  final String description;

  OnBoardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}
