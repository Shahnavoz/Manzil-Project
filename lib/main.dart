import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intetership_project/feature/bottom_bar/presentation/pages/bottom__nav_page.dart';
import 'package:intetership_project/feature/home/presentation/pages/test_page.dart';
import 'package:intetership_project/feature/profile/presentation/blocs/theme_provider.dart';
import 'package:intetership_project/feature/registration/pages/splash_screen_page.dart';
import 'package:intetership_project/feature_admin/bottom_nav_page/presentation/pages/bottom__nav_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      home: SplashScreenPage(),
    );
  }
}
