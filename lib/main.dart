import 'package:ar_dreams/screens/home.dart';
import 'package:ar_dreams/screens/log_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/ar_view.dart';
import 'screens/reportedIncidentsDisplayScreen.dart';

final kcolorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 110, 24, 248),
  background: const Color.fromARGB(255, 5, 5, 20),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: kcolorScheme.background,
  colorScheme: kcolorScheme,
  appBarTheme: const AppBarTheme().copyWith(
      centerTitle: true, backgroundColor: kcolorScheme.primary.withOpacity(.2)),
  textTheme: ThemeData().textTheme.copyWith(
        titleSmall: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 8,
            color: kcolorScheme.onSecondaryContainer),
        titleMedium: GoogleFonts.lato(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: kcolorScheme.onSecondaryContainer),
        titleLarge: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: kcolorScheme.onPrimaryContainer),
      ),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[700])),
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const Home(),
      routes: {
        ARView.routeName: (context) => const ARView(),
        LogScreen.routeName: (context) => const LogScreen(),
        ReportedIncidentsDisplayScreen.routeName: (context) =>
            const ReportedIncidentsDisplayScreen(),
      },
    );
  }
}
