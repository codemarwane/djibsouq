/// Point d’entrée : initialise le stockage session / invité et précharge le catalogue avant [runApp].
library;

import 'package:dj/demarrage_screen.dart';
import 'package:dj/data/api/auth_store.dart';
import 'package:dj/data/api/guest_token_store.dart';
import 'package:dj/data/product_repository.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthStore.instance.init();
  await GuestTokenStore.instance.init();
  await ProductRepository.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const DemarrageScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
