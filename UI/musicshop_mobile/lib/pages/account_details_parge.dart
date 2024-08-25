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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Personal Info'),
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

              final updatedCustomer = CustomerUpsertRequest()
                ..firstName = firstName
                ..lastName = lastName
                ..username = username
                ..email = email
                ..phoneNumber = phoneNumber;

              if (password != null) {
                updatedCustomer.password = password;
                updatedCustomer.passwordConfirm = passwordConfirm;
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
    final _countryController =
        TextEditingController(text: shippingInfo?.country);
    final _stateOrProvinceController =
        TextEditingController(text: shippingInfo?.stateOrProvince);
    final _cityController = TextEditingController(text: shippingInfo?.city);
    final _zipCodeController =
        TextEditingController(text: shippingInfo?.zipCode);
    final _streetAddressController =
        TextEditingController(text: shippingInfo?.streetAddress);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Shipping Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_countryController, 'Country'),
              _buildTextField(_stateOrProvinceController, 'State/Province'),
              _buildTextField(_cityController, 'City'),
              _buildTextField(_zipCodeController, 'Zip Code'),
              _buildTextField(_streetAddressController, 'Street Address'),
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
              final country = _countryController.text;
              final stateOrProvince = _stateOrProvinceController.text;
              final city = _cityController.text;
              final zipCode = _zipCodeController.text;
              final streetAddress = _streetAddressController.text;

              if (country.isEmpty ||
                  stateOrProvince.isEmpty ||
                  city.isEmpty ||
                  zipCode.isEmpty ||
                  streetAddress.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }

              final shippingInfoId = shippingInfo?.id;
              if (shippingInfoId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shipping info ID is missing')),
                );
                return;
              }

              final updatedShippingInfo = ShippingInfoUpdateRequest()
                ..country = country
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
                    ..country = country
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
