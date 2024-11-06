import 'package:flutter/material.dart';
import 'package:flutter_application_app/src/screens/screens.dart';
import 'package:flutter_application_app/src/service/service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PlacesService(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomeScreen(),
        'perfil': (context) => const PerfilScreen(),
        'login': (context) => const LoginScreen(),
        'details': (context) => const PlaceDetailScreen2(
              place: null,
            ),
        'favorite': (context) => const FavoriteScreen(),
      },
    );
  }
}
