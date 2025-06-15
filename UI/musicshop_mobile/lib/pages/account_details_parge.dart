import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/shipping_info/shipping_info_update_request.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_mobile/models/customer/customer.dart';
import 'package:musicshop_mobile/models/customer/customer_upsert_request.dart';
import 'package:musicshop_mobile/providers/customer/customer_provider.dart';
import 'package:musicshop_mobile/models/shipping_info/shipping_info.dart';
import 'package:musicshop_mobile/providers/shipping_info/shipping_info_provider.dart';

class AccountDetailsPage extends StatefulWidget {
  final Customer customer;

  const AccountDetailsPage({super.key, required this.customer});

  @override
  _AccountDetailsPageState createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends State<AccountDetailsPage> {
  late Customer customer;
  ShippingInfo? shippingInfo;

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
    _fetchShippingInfo();
  }

  Future<void> _fetchShippingInfo() async {
    final shippingInfoProvider =
        Provider.of<ShippingInfoProvider>(context, listen: false);
    try {
      final info = await shippingInfoProvider.getByCustomerId();
      setState(() {
        shippingInfo = info;
      });
    } catch (e) {
      print('Error fetching shipping info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoSection(context, 'Personal Information',
                _buildPersonalInfoDisplay(context)),
            const SizedBox(height: 20),
            _buildInfoSection(context, 'Shipping Information',
                _buildShippingInfoDisplay(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, Widget content) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildPersonalInfoDisplay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadOnlyTextField('First Name', customer.firstName),
        _buildReadOnlyTextField('Last Name', customer.lastName),
        _buildReadOnlyTextField('Username', customer.username),
        _buildReadOnlyTextField('Email', customer.email),
        _buildReadOnlyTextField('Phone Number', customer.phoneNumber),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showUpdatePersonalInfoDialog(context),
          child: const Text('Update Personal Info'),
        ),
      ],
    );
  }

  Widget _buildShippingInfoDisplay(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReadOnlyTextField('Country', shippingInfo?.country),
        _buildReadOnlyTextField(
            'State/Province', shippingInfo?.stateOrProvince),
        _buildReadOnlyTextField('City', shippingInfo?.city),
        _buildReadOnlyTextField('Zip Code', shippingInfo?.zipCode),
        _buildReadOnlyTextField('Street Address', shippingInfo?.streetAddress),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _showUpdateShippingInfoDialog(context),
          child: const Text('Update Shipping Info'),
        ),
      ],
    );
  }

  Widget _buildReadOnlyTextField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        readOnly: true,
      ),
    );
  }

  final List<Map<String, String>> countryCodes = [
    {'code': 'US', 'name': 'United States'},
    {'code': 'BA', 'name': 'Bosnia and Herzegovina'},
    {'code': 'HR', 'name': 'Croatia'},
    {'code': 'RS', 'name': 'Serbia'},
    {'code': 'DE', 'name': 'Germany'},
    {'code': 'GB', 'name': 'United Kingdom'},
    {'code': 'FR', 'name': 'France'},
    {'code': 'IT', 'name': 'Italy'},
    {'code': 'ES', 'name': 'Spain'},
    {'code': 'NL', 'name': 'Netherlands'},
    {'code': 'SE', 'name': 'Sweden'},
    {'code': 'CH', 'name': 'Switzerland'},
    {'code': 'NO', 'name': 'Norway'},
    {'code': 'FI', 'name': 'Finland'},
    {'code': 'PL', 'name': 'Poland'},
    {'code': 'CZ', 'name': 'Czech Republic'},
    {'code': 'AT', 'name': 'Austria'},
    {'code': 'HU', 'name': 'Hungary'},
  ];

  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  void _showUpdatePersonalInfoDialog(BuildContext context) {
    final _firstNameController =
        TextEditingController(text: customer.firstName);
    final _lastNameController = TextEditingController(text: customer.lastName);
    final _usernameController = TextEditingController(text: customer.username);
    final _emailController = TextEditingController(text: customer.email);
    final _phoneNumberController =
        TextEditingController(text: customer.phoneNumber);
    final _passwordController = TextEditingController();
    final _passwordConfirmController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Personal Info'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormTextField(
                  _firstNameController,
                  'First Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'First Name is required';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _lastNameController,
                  'Last Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Name is required';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _usernameController,
                  'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _emailController,
                  'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!emailRegex.hasMatch(value)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _phoneNumberController,
                  'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number is required';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _passwordController,
                  'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (value.length < 4)
                        return 'Password must be at least 4 characters';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _passwordConfirmController,
                  'Confirm Password',
                  obscureText: true,
                  validator: (value) {
                    if (_passwordController.text.isNotEmpty) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
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

              final updatedCustomer = CustomerUpsertRequest()
                ..firstName = firstName
                ..lastName = lastName
                ..username = username
                ..email = email
                ..phoneNumber = phoneNumber;

              if (_passwordController.text.isNotEmpty) {
                updatedCustomer.password = _passwordController.text;
                updatedCustomer.passwordConfirm =
                    _passwordConfirmController.text;
              }

              final customerProvider =
                  Provider.of<CustomerProvider>(context, listen: false);

              try {
                final updatedCustomerData = await customerProvider.update(
                    customer.id!, updatedCustomer);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Personal info updated successfully')),
                );

                setState(() {
                  customer.firstName = updatedCustomerData.firstName;
                  customer.lastName = updatedCustomerData.lastName;
                  customer.username = updatedCustomerData.username;
                  customer.email = updatedCustomerData.email;
                  customer.phoneNumber = updatedCustomerData.phoneNumber;
                });

                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update personal info: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showUpdateShippingInfoDialog(BuildContext context) {
    String selectedCountry = shippingInfo?.country ?? 'US';
    final _stateOrProvinceController =
        TextEditingController(text: shippingInfo?.stateOrProvince);
    final _cityController = TextEditingController(text: shippingInfo?.city);
    final _zipCodeController =
        TextEditingController(text: shippingInfo?.zipCode);
    final _streetAddressController =
        TextEditingController(text: shippingInfo?.streetAddress);
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Shipping Info'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCountry,
                  items: countryCodes
                      .map((country) => DropdownMenuItem<String>(
                            value: country['code'],
                            child:
                                Text('${country['name']} (${country['code']})'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedCountry = value;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildFormTextField(
                  _stateOrProvinceController,
                  'State/Province',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'State/Province is required';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _cityController,
                  'City',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'City is required';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _zipCodeController,
                  'Zip Code',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Zip Code is required';
                    }
                    return null;
                  },
                ),
                _buildFormTextField(
                  _streetAddressController,
                  'Street Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Street Address is required';
                    }
                    return null;
                  },
                ),
              ],
            ),
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
              if (!_formKey.currentState!.validate()) return;

              final stateOrProvince = _stateOrProvinceController.text;
              final city = _cityController.text;
              final zipCode = _zipCodeController.text;
              final streetAddress = _streetAddressController.text;

              final shippingInfoId = shippingInfo?.id;
              if (shippingInfoId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shipping info ID is missing')),
                );
                return;
              }

              final updatedShippingInfo = ShippingInfoUpdateRequest()
                ..country = selectedCountry
                ..stateOrProvince = stateOrProvince
                ..city = city
                ..zipCode = zipCode
                ..streetAddress = streetAddress
                ..id = shippingInfoId;

              final shippingInfoProvider =
                  Provider.of<ShippingInfoProvider>(context, listen: false);

              try {
                await shippingInfoProvider.update(
                    shippingInfoId, updatedShippingInfo);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Shipping info updated successfully')),
                );

                setState(() {
                  shippingInfo = ShippingInfo()
                    ..country = selectedCountry
                    ..stateOrProvince = stateOrProvince
                    ..city = city
                    ..zipCode = zipCode
                    ..streetAddress = streetAddress
                    ..id = shippingInfoId;
                });

                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update shipping info: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormTextField(
    TextEditingController controller,
    String label, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        validator: validator,
      ),
    );
  }
}
