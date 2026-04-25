import 'dart:async';

import 'package:al_shaher/core/di/injection_container.dart';
import 'package:al_shaher/core/storage/auth_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constant/app_assets.dart';
import '../../core/routing/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_bootstrap());
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final authStorage = sl<AuthLocalStorage>();
    final hasToken = authStorage.hasToken;
    final isAdmin = authStorage.getAuthType() == 'admin';
    final next = hasToken
        ? (isAdmin ? AppRoutes.adminHome : AppRoutes.home)
        : AppRoutes.onBoarding;

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.splashBack,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1500),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                AppAssets.appLogoImg,
                width: 220.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
