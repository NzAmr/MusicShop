import 'package:flutter/material.dart';
import 'package:musicshop_admin/pages/my_home_page.dart';
import 'package:musicshop_admin/pages/auth/login_page.dart';
import 'package:musicshop_admin/providers/api_provider.dart';

void main() {
  runApp(
    const ApiProvider(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkBlue,
          brightness: Brightness.light,
          primary: _blue,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent,
          onSecondary: Colors.white,
          surface: _darkGray,
          onSurface: _lightGray,
          error: Colors.red,
          onError: Colors.white,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: _darkGray,
          titleTextStyle: const TextStyle(
            color: _lightGray,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: _bodyTextStyle,
          bodyMedium: _bodyTextStyle,
          titleLarge: _bodyTextStyle,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

const Color _darkBlue = Color.fromARGB(255, 3, 13, 95);
const Color _blue = Color.fromARGB(255, 75, 89, 194);
const Color _darkGray = Color.fromARGB(255, 39, 35, 35);
const Color _lightGray = Color.fromARGB(255, 228, 226, 226);

const TextStyle _bodyTextStyle = TextStyle(
  color: _lightGray,
);

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isAuthenticated
        ? const MyHomePage(title: 'Flutter Demo Home Page')
        : const LoginPage();
  }
}
