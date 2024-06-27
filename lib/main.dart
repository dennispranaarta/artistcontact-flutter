import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/cubit/auth/cubit/auth_cubit.dart';
import 'package:my_app/cubit/balance/cubit/balance_cubit.dart';
import 'package:my_app/cubit/counter_cubit.dart';
import 'package:my_app/cubit/dataLogin/cubit/data_login_cubit.dart';
import 'package:my_app/screens/config_screen.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/screens/navigation.dart';
import 'package:my_app/screens/navigation_admin.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit(); // Initialize sqflite ffi
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CounterCubit>(create: (context) => CounterCubit()),
        BlocProvider<BalanceCubit>(create: (context) => BalanceCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<DataLoginCubit>(create: (context) => DataLoginCubit())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        initialRoute: '/',
        routes: {
          '/config_screen': (context) => const ConfigScreen(),
          '/login': (context) => const LoginScreen(),
          '/base': (context) => const NavigationScreen(),
          '/admin': (context) => const NavigationAdminScreen(),
        },
      ),
    );
  }
}
