import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'core/navigation/manager.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'theme.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(const ProfileInitialState()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorKey: NavigationManager.navigatorKey,
        initialRoute: Routes.main,
        theme: lightTheme,
      ),
    );
  }
}
