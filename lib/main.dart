import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycv/theme/theme.dart';
import 'router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: ThemeListener(
        child: BlocBuilder<ThemeBloc, ThemeState>(
          buildWhen: (previous, current) => previous.themeData != current.themeData,
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Ahmed AlaaEldin Atia - Portfolio',
              theme: state.themeData ?? state.createThemeData(),
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
