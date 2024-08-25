import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/abstract/product.dart';
import 'package:musicshop_admin/models/customer/customer.dart';
import 'package:musicshop_admin/models/order/order_insert_request.dart';
import 'package:musicshop_admin/models/shipping_info/shipping_info.dart';
import 'package:musicshop_admin/providers/customer/customer_provider.dart';
import 'package:musicshop_admin/providers/order_provider/order_provider.dart';
import 'package:musicshop_admin/providers/shipping_info/shipping_info_provider.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  final Product product;

  OrderPage({Key? key, required this.product}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  ShippingInfo? _selectedShippingInfo;
  String? _selectedCustomerName;
  int? _selectedCustomerId;
  Future<List<Customer>>? _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture =
        Provider.of<CustomerProvider>(context, listen: false).get();
  }

  Future<void> _selectCustomer() async {
    final customers = await _customersFuture;

    if (customers == null || customers.isEmpty) return;

    final selectedCustomer = await showDialog<Customer>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Customer',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    childAspectRatio: 2 / 1,
                  ),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(customer);
                      },
                      child: Card(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white, width: 1.5),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.username ?? 'No username',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '${customer.firstName ?? 'No First Name'} ${customer.lastName ?? 'No Last Name'}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (selectedCustomer != null) {
      setState(() {
        _selectedCustomerId = selectedCustomer.id;
        _selectedCustomerName =
            '${selectedCustomer.firstName ?? 'No First Name'} ${selectedCustomer.lastName ?? 'No Last Name'}';
        _fetchShippingInfo(selectedCustomer.id ?? 0);
      });
    }
  }

  Future<void> _fetchShippingInfo(int customerId) async {
    try {
      final shippingInfoProvider =
          Provider.of<ShippingInfoProvider>(context, listen: false);
      final shippingInfo =
          await shippingInfoProvider.getByCustomerId(customerId);
      setState(() {
        _selectedShippingInfo = shippingInfo;
      });
    } catch (e) {
      print('Error fetching shipping info: $e');
    }
  }

  Future<void> _submitOrder() async {
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a customer.')),
      );
      return;
    }

    if (_selectedShippingInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No shipping info available.')),
      );
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final OrderRequest = OrderInsertRequest()
      ..shippingInfoId = _selectedShippingInfo!.id
      ..productId = widget.product.id;

    try {
      await orderProvider.insert(OrderRequest);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order submitted successfully!')),
      );
    } catch (e) {
      print('Error submitting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit order.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageSection(),
                    SizedBox(width: 16),
                    SizedBox(
                      width: 500,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Model: ${widget.product.model ?? 'N/A'}'),
                          SizedBox(height: 8),
                          Text(
                              'Brand: ${widget.product.brand?.name ?? 'Unknown'}'),
                          SizedBox(height: 8),
                          Text(
                              'Price: \$${widget.product.price?.toStringAsFixed(2) ?? 'N/A'}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _selectCustomer,
                            child: Text('Select Customer'),
                          ),
                          SizedBox(height: 8),
                          if (_selectedCustomerName != null)
                            Text('Selected Customer: $_selectedCustomerName'),
                          SizedBox(height: 16),
                          if (_selectedShippingInfo != null) ...[
                            Text(
                                'Street Address: ${_selectedShippingInfo!.streetAddress ?? 'N/A'}'),
                            SizedBox(height: 8),
                            Text(
                                'City: ${_selectedShippingInfo!.city ?? 'N/A'}'),
                            SizedBox(height: 8),
                            Text(
                                'State/Province: ${_selectedShippingInfo!.stateOrProvince ?? 'N/A'}'),
                            SizedBox(height: 8),
                            Text(
                                'Zip Code: ${_selectedShippingInfo!.zipCode ?? 'N/A'}'),
                            SizedBox(height: 8),
                            Text(
                                'Country: ${_selectedShippingInfo!.country ?? 'N/A'}'),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _submitOrder,
                        child: Text('Submit Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    Uint8List? _imageBytes;
    if (widget.product.productImage != null) {
      try {
        _imageBytes = base64Decode(widget.product.productImage!);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return GestureDetector(
      onTap: () {},
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 300,
          maxHeight: 300,
        ),
        child: _imageBytes != null
            ? Image.memory(
                _imageBytes,
                fit: BoxFit.cover,
              )
            : Placeholder(),
      ),
    );
  }
}
