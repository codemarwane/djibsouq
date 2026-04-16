import 'package:dj/demarrage_screen.dart';
import 'package:flutter/material.dart';
import 'routes.dart';
import 'core/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('fr'); // ou 'en', 'ar', etc.

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
    // Commandes pour exécuter l'application Flutter sur différentes plateformes :
    // Pour exécuter sur un appareil Android ou un émulateur :
// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

    // Pour exécuter sur un appareil iOS ou un simulateur :
// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

    // Pour exécuter sur le web :  
// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

    // Pour exécuter sur le bureau (Windows, macOS, Linux) :
// flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080 