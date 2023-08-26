import 'package:flutter/material.dart';
import 'package:ftf/authentication/account_type.dart';
import 'package:ftf/authentication/login.dart';
import 'package:ftf/authentication/register_fan.dart';
import 'package:ftf/styles/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              color: Colors.white,
            ),
            bodySmall: TextStyle(
              color: Colors.white,
            ),
            labelLarge: TextStyle(
              color: Colors.white,
            ),
          ),
          fontFamily: 'Roboto',
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                overlayColor:
                    MaterialStatePropertyAll(Colors.red.withOpacity(0.2)),
                backgroundColor:
                    const MaterialStatePropertyAll(Color(lighterBlack)),
                foregroundColor: const MaterialStatePropertyAll(Colors.white)),
          ),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.white)),
      routes: {
        // '/fighterHome': (context) =>  FighterHomePage(),
// '/fanHome':(context) => FanHomePage(),
        'accountType': (context) => const AccountType(),
        // 'registerFighter':(context) => RegisterFighter(),
        'registerFan': (context) => const RegisterFan(),
        'loginPage': (context) => const LoginPage()
      },
      home: const LoginPage(),
    );
  }
}
