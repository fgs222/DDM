import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcial_2/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:parcial_2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:parcial_2/features/posts/presentation/bloc/entry_bloc.dart';
import 'package:parcial_2/init_dependencies.dart';

import 'core/router/app_router.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers:[
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<EntryBloc>(),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'App',
      theme: AppTheme.darkThemeMode,
      routerConfig: appRouter,
    );
  }
}
