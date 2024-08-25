import 'package:flutter/material.dart';
import 'package:musicshop_mobile/pages/login_page.dart';
import 'package:musicshop_mobile/pages/my_home_page.dart';
import 'package:musicshop_mobile/providers/api_provider.dart';
import 'package:musicshop_mobile/utils/util.dart';

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
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await _checkLogin();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  Future<bool> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    return Authorization.username != null && Authorization.password != null;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn
        ? const MyHomePage(title: 'Recommended for you!!')
        : const LoginPage();
  }
}
