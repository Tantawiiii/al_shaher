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
import 'package:al_shaher/feature/user/news/cubit/news_cubit.dart';
import 'package:al_shaher/feature/user/news/data/news_model.dart';
import 'package:al_shaher/feature/user/members/cubit/members_cubit.dart';
import 'package:al_shaher/feature/user/members/ui/member_profile_screen.dart';
import 'package:al_shaher/feature/user/requests/cubit/request_cubit.dart';
import 'package:al_shaher/feature/user/requests/ui/request_screen.dart';
import 'package:al_shaher/feature/user/news/ui/news_screen.dart';
import 'package:al_shaher/feature/user/news/ui/news_detail_screen.dart';
import 'package:al_shaher/feature/user/news/ui/add_news_screen.dart';
import 'package:al_shaher/feature/user/notifications/notifications_screen.dart';
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
      return MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<EventsCubit>()..loadEvents()),
            BlocProvider(create: (_) => sl<NewsCubit>()..loadNews()),
            BlocProvider(create: (_) => sl<MembersCubit>()..loadMembers()),
          ],
          child: const HomeScreen(),
        ),
      );

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

    case AppRoutes.memberProfile:
      final memberId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<MembersCubit>(),
          child: MemberProfileScreen(memberId: memberId),
        ),
      );

    case AppRoutes.news:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<NewsCubit>()..loadNews(),
          child: const NewsScreen(),
        ),
      );

    case AppRoutes.newsDetails:
      final newsId = settings.arguments as int;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<NewsCubit>(),
          child: NewsDetailScreen(newsId: newsId),
        ),
      );

    case AppRoutes.addNews:
      final news = settings.arguments as NewsModel?;
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<NewsCubit>(),
          child: AddNewsScreen(news: news),
        ),
      );
    case AppRoutes.notifications:
      return MaterialPageRoute(builder: (_) => const NotificationsScreen());

    case AppRoutes.submitRequest:
      return MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<RequestCubit>(),
          child: const RequestScreen(),
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (_) =>
            const Scaffold(body: Center(child: Text('Route not found'))),
      );
  }
}
