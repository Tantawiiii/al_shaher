import 'package:al_shaher/feature/user/auth/login/cubit/login_cubit.dart';
import 'package:al_shaher/feature/user/auth/login/ui/login_screen.dart';
import 'package:al_shaher/feature/user/home/home_screen.dart';
import 'package:al_shaher/feature/user/tree/cubit/tree_cubit.dart';
import 'package:al_shaher/feature/user/tree/ui/tree_screen.dart';
import 'package:al_shaher/feature/user/events/cubit/events_cubit.dart';
import 'package:al_shaher/feature/user/events/ui/events_screen.dart';
import 'package:al_shaher/feature/user/events/ui/event_details_screen.dart';
import 'package:al_shaher/feature/user/events/ui/add_event_screen.dart';
import 'package:al_shaher/feature/user/events/data/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/user/auth/register/cubit/register_cubit.dart';
import '../../feature/user/auth/register/ui/register_screen.dart';
import '../../feature/utils/onBoarding_screen.dart';
import '../../feature/utils/splash_screen.dart';
import '../../feature/utils/welcome_screen.dart';
import '../di/injection_container.dart';
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
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<RegisterCubit>(),
          child: const RegisterScreen(),
        ),
      );

    case AppRoutes.login:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<LoginCubit>(),
          child: const LoginScreen(),
        ),
      );

    case AppRoutes.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());

    case AppRoutes.familyTree:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<TreeCubit>()..loadTree(),
          child: const TreeScreen(),
        ),
      );

    case AppRoutes.events:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<EventsCubit>()..loadEvents(),
          child: const EventsScreen(),
        ),
      );

    case AppRoutes.eventDetails:
      final eventId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<EventsCubit>(),
          child: EventDetailsScreen(eventId: eventId),
        ),
      );

    case AppRoutes.addEvent:
      final event = settings.arguments as EventModel?;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<EventsCubit>(),
          child: AddEventScreen(event: event),
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route not found'))),
      );
  }
}
