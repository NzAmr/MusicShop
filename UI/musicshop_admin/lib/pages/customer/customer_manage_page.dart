import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/customer/customer.dart';
import 'package:musicshop_admin/providers/customer/customer_provider.dart';
import 'package:musicshop_admin/models/shipping_info/shipping_info.dart';
import 'package:musicshop_admin/models/shipping_info/shipping_info_update_request.dart';
import 'package:musicshop_admin/providers/shipping_info/shipping_info_provider.dart';

class ManageCustomersPage extends StatefulWidget {
  const ManageCustomersPage({super.key});

  @override
  State<ManageCustomersPage> createState() => _ManageCustomersPageState();
}

class _ManageCustomersPageState extends State<ManageCustomersPage> {
  final CustomerProvider _customerProvider = CustomerProvider();
  final ShippingInfoProvider _shippingInfoProvider = ShippingInfoProvider();
  Future<List<Customer>>? _customersFuture;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchCustomers);
    _searchCustomers();
  }

  void _searchCustomers() {
    setState(() {
      _customersFuture =
          _customerProvider.get(filter: {"name": _searchController.text});
    });
  }

  void _deleteCustomer(int id) async {
    try {
      await _customerProvider.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer deleted successfully!')),
      );
      _searchCustomers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete customer: $e')),
      );
    }
  }

  Future<void> _showShippingInfoDialog(Customer customer) async {
    ShippingInfo? shippingInfo;
    bool isLoading = true;

    try {
      shippingInfo = await _shippingInfoProvider.getByCustomerId(customer.id!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load shipping info: $e')),
      );
      shippingInfo = null;
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    final TextEditingController countryController = TextEditingController(
      text: shippingInfo?.country,
    );
    final TextEditingController stateController = TextEditingController(
      text: shippingInfo?.stateOrProvince,
    );
    final TextEditingController cityController = TextEditingController(
      text: shippingInfo?.city,
    );
    final TextEditingController zipCodeController = TextEditingController(
      text: shippingInfo?.zipCode,
    );
    final TextEditingController streetAddressController = TextEditingController(
      text: shippingInfo?.streetAddress,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Shipping Info for ${customer.username}'),
        content: isLoading
            ? const Center(child: CircularProgressIndicator())
            : shippingInfo == null
                ? const Text('No shipping info available.')
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: countryController,
                          decoration:
                              const InputDecoration(labelText: 'Country'),
                        ),
                        TextField(
                          controller: stateController,
                          decoration: const InputDecoration(
                              labelText: 'State/Province'),
                        ),
                        TextField(
                          controller: cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                        ),
                        TextField(
                          controller: zipCodeController,
                          decoration:
                              const InputDecoration(labelText: 'Zip Code'),
                        ),
                        TextField(
                          controller: streetAddressController,
                          decoration: const InputDecoration(
                              labelText: 'Street Address'),
                        ),
                      ],
                    ),
                  ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (shippingInfo != null) {
                try {
                  await _shippingInfoProvider.update(
                    shippingInfo.id!,
                    ShippingInfoUpdateRequest()
                      ..country = countryController.text
                      ..stateOrProvince = stateController.text
                      ..city = cityController.text
                      ..zipCode = zipCodeController.text
                      ..streetAddress = streetAddressController.text
                      ..customerId = shippingInfo.customer?.id,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Shipping info updated successfully!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to update shipping info: $e')),
                  );
                }
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Manage Customers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Customer>>(
                future: _customersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No customers available.'));
                  }
                  final customers = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 2 / 1,
                    ),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return GestureDetector(
                        onTap: () => _showShippingInfoDialog(customer),
                        child: Card(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          margin: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer.username ?? 'No username',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      '${customer.firstName ?? 'No First Name'} ${customer.lastName ?? 'No Last Name'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      customer.email ?? 'No email',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      customer.phoneNumber ?? 'No phone number',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 4.0,
                                right: 4.0,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      _deleteCustomer(customer.id!),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
