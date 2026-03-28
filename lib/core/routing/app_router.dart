import 'package:flutter/material.dart';
import '../../feature/user/auth/register/register_screen.dart';
import '../../feature/utils/welcome_screen.dart';
import '../../../feature/utils/onBoarding_screen.dart';
import '../../../feature/utils/splash_screen.dart';
import 'app_routes.dart';


Route<dynamic> onGenerateAppRoute(RouteSettings settings) {
  switch (settings.name) {

    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());

    case AppRoutes.onBoarding:
      return MaterialPageRoute(builder: (_) => const OnBoardingScreen());

    case AppRoutes.welcome:
      return MaterialPageRoute(builder: (_) => const WelcomeScreen());

    case AppRoutes.register:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route not found'))),
      );
  }
}
