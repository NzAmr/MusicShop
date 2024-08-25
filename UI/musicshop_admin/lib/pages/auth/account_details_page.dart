import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/employee/employee.dart';
import 'package:musicshop_admin/models/employee/employee_upsert_request.dart';
import 'package:musicshop_admin/providers/employee/employee_provider.dart';

class AccountDetailsPage extends StatefulWidget {
  final Employee employee;

  const AccountDetailsPage({super.key, required this.employee});

  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late Employee employee;

  @override
  void initState() {
    super.initState();
    employee = widget.employee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Employee Information',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                _buildInfoCard(context, 'First Name', employee.firstName),
                _buildInfoCard(context, 'Last Name', employee.lastName),
                _buildInfoCard(context, 'Username', employee.username),
                _buildInfoCard(context, 'Email', employee.email),
                _buildInfoCard(context, 'Phone Number', employee.phoneNumber),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showUpdateDialog(context),
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String? value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final _firstNameController =
        TextEditingController(text: employee.firstName);
    final _lastNameController = TextEditingController(text: employee.lastName);
    final _usernameController = TextEditingController(text: employee.username);
    final _emailController = TextEditingController(text: employee.email);
    final _phoneNumberController =
        TextEditingController(text: employee.phoneNumber);
    final _passwordController = TextEditingController();
    final _passwordConfirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Account'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_firstNameController, 'First Name'),
              _buildTextField(_lastNameController, 'Last Name'),
              _buildTextField(_usernameController, 'Username'),
              _buildTextField(_emailController, 'Email',
                  keyboardType: TextInputType.emailAddress),
              _buildTextField(_phoneNumberController, 'Phone Number',
                  keyboardType: TextInputType.phone),
              _buildTextField(_passwordController, 'Password',
                  obscureText: true),
              _buildTextField(_passwordConfirmController, 'Confirm Password',
                  obscureText: true),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final firstName = _firstNameController.text;
              final lastName = _lastNameController.text;
              final username = _usernameController.text;
              final email = _emailController.text;
              final phoneNumber = _phoneNumberController.text;
              final password = _passwordController.text.isEmpty
                  ? null
                  : _passwordController.text;
              final passwordConfirm = _passwordConfirmController.text.isEmpty
                  ? null
                  : _passwordConfirmController.text;

              if ((password != null && passwordConfirm == null) ||
                  (password == null && passwordConfirm != null)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Both password fields must be filled or both must be empty')),
                );
                return;
              }

              if (password != null && password != passwordConfirm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              if (firstName.isEmpty ||
                  lastName.isEmpty ||
                  username.isEmpty ||
                  email.isEmpty ||
                  phoneNumber.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }

              final updatedEmployee = EmployeeUpsertRequest()
                ..firstName = firstName
                ..lastName = lastName
                ..username = username
                ..email = email
                ..phoneNumber = phoneNumber;

              if (password != null) {
                updatedEmployee.password = password;
                updatedEmployee.passwordConfirm = passwordConfirm;
              }

              final employeeProvider =
                  Provider.of<EmployeeProvider>(context, listen: false);

              try {
                final updatedEmployeeData = await employeeProvider.update(
                    employee.id!, updatedEmployee);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Employee updated successfully')),
                );

                setState(() {
                  employee.firstName = updatedEmployeeData.firstName;
                  employee.lastName = updatedEmployeeData.lastName;
                  employee.username = updatedEmployeeData.username;
                  employee.email = updatedEmployeeData.email;
                  employee.phoneNumber = updatedEmployeeData.phoneNumber;
                });

                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update employee: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
