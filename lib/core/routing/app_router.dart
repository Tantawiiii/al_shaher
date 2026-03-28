import 'package:flutter/material.dart';
import '../../../feature/user/auth/login/ui/login_screen.dart';
import '../../../feature/utils/onBoarding_screen.dart';
import '../../../feature/utils/splash_screen.dart';
import 'app_routes.dart';


Route<dynamic> onGenerateAppRoute(RouteSettings settings) {
  switch (settings.name) {

    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    case AppRoutes.onBoarding:
      return MaterialPageRoute(builder: (_) => const OnBoardingScreen());

    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route not found'))),
      );
  }
}
