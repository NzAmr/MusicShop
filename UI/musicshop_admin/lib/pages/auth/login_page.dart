import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/employee/login.dart';
import 'package:musicshop_admin/pages/my_home_page.dart';
import 'package:musicshop_admin/providers/employee/employee_provider.dart';
import 'package:musicshop_admin/models/employee/employee_upsert_request.dart';
import 'package:musicshop_admin/utils/util.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _signUpUsernameController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) return;

    final username = _usernameController.text;
    final password = _passwordController.text;

    final loginRequest = Login(username: username, password: password);
    final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);

    try {
      await employeeProvider.employeeLogin(loginRequest);
      Authorization.username = username;
      Authorization.password = password;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Music Shop Admin')),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Login failed: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Up'),
        content: SingleChildScrollView(
          child: Form(
            key: _signUpFormKey,
            child: Column(
              children: [
                _buildField(controller: _firstNameController, label: 'First Name'),
                _buildField(controller: _lastNameController, label: 'Last Name'),
                _buildField(controller: _signUpUsernameController, label: 'Username'),
                _buildField(
                  controller: _signUpPasswordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v.length < 4) return 'Min 4 characters';
                    return null;
                  },
                ),
                _buildField(
                  controller: _signUpConfirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: true,
                  validator: (v) {
                    if (v != _signUpPasswordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                _buildField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final emailRegex = RegExp(r'\S+@\S+\.\S+');
                    return emailRegex.hasMatch(v) ? null : 'Invalid email';
                  },
                ),
                _buildField(
                  controller: _phoneNumberController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (!_signUpFormKey.currentState!.validate()) return;

              final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
              final newEmployee = EmployeeUpsertRequest()
                ..firstName = _firstNameController.text
                ..lastName = _lastNameController.text
                ..username = _signUpUsernameController.text
                ..password = _signUpPasswordController.text
                ..passwordConfirm = _signUpConfirmPasswordController.text
                ..email = _emailController.text
                ..phoneNumber = _phoneNumberController.text;

              try {
                await employeeProvider.insert(newEmployee);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account created successfully!')),
                );
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text('Sign up failed: ${e.toString()}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Sign Up'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator ??
            (v) {
              if (v == null || v.isEmpty) return 'Required';
              return null;
            },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _loginFormKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _showSignUpDialog,
                            child: const Text('Sign Up'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
