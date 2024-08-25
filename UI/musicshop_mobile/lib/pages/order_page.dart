import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/order/order_insert_request.dart';
import 'package:musicshop_mobile/models/shipping_info/shipping_info.dart';
import 'package:musicshop_mobile/providers/order_provider/order_provider.dart';
import 'package:musicshop_mobile/providers/shipping_info/shipping_info_provider.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  final Product product;

  OrderPage({Key? key, required this.product}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  ShippingInfo? _shippingInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchShippingInfo();
  }

  Future<void> _fetchShippingInfo() async {
    final shippingInfoProvider =
        Provider.of<ShippingInfoProvider>(context, listen: false);

    try {
      final shippingInfo = await shippingInfoProvider.getByCustomerId();
      setState(() {
        _shippingInfo = shippingInfo;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching shipping info: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitOrder(String paymentId, BuildContext context) async {
    if (_shippingInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No shipping info available.')),
      );
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final OrderRequest = OrderInsertRequest()
      ..shippingInfoId = _shippingInfo!.id
      ..productId = widget.product.id
      ..paymentId = paymentId;

    try {
      await orderProvider.insert(OrderRequest);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order submitted successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit order.')),
      );
    }
  }

  void openPaypalCheckout(BuildContext context1) async {
    if (_shippingInfo == null) {
      ScaffoldMessenger.of(context1).showSnackBar(
        SnackBar(content: Text('Shipping information is not available.')),
      );
      return;
    }

    final product = widget.product;
    final shippingInfo = _shippingInfo!;

    Navigator.of(context1).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true,
          clientId:
              "AcBfWwnXZ0jMKDxDJt_gqDp2XzBt9N1_YjqnYlBm35NeryUJWjuWGeswYgXlepmYZLcPFRnj9aZVFMzm",
          secretKey:
              "EIuUXSQNklabUxNwfGhPrfWZ87_pUNqTwqjqSINjg6ld7hpjAqjVhPQoUZJ7moSgnug31Ub_6mjoXP6m",
          returnURL: "https://samplesite.com/return",
          cancelURL: "https://samplesite.com/cancel",
          transactions: [
            {
              "amount": {
                "total": product.price?.toStringAsFixed(2) ?? '0.00',
                "currency": "USD",
                "details": {
                  "subtotal": product.price?.toStringAsFixed(2) ?? '0.00',
                  "shipping": '0.00',
                  "shipping_discount": 0
                }
              },
              "description": product.description ?? "Product Purchase",
              "payment_options": {
                "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
              },
              "item_list": {
                "items": [
                  {
                    "name": product.model ?? "Product",
                    "quantity": 1,
                    "price": product.price?.toStringAsFixed(2) ?? '0.00',
                    "currency": "USD"
                  }
                ],
                "shipping_address": {
                  "recipient_name":
                      '${shippingInfo.customer?.firstName ?? 'Customer'} ${shippingInfo.customer?.lastName ?? ''}',
                  "line1": shippingInfo.streetAddress ?? '',
                  "line2": '',
                  "city": shippingInfo.city ?? '',
                  "country_code": shippingInfo.country ?? '',
                  "postal_code": shippingInfo.zipCode ?? '',
                  "phone": shippingInfo.customer?.phoneNumber ?? '',
                  "state": shippingInfo.stateOrProvince ?? ''
                }
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            print("onSuccess: $params");
            var paymentId = params["paymentId"];
            _submitOrder(paymentId, context1);
          },
          onError: (error) {
            print("onError: $error");
          },
          onCancel: (params) {
            print('cancelled: $params');
          },
        ),
      ),
    );
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
                _buildImageSection(),
                SizedBox(height: 16),
                _buildProductInfo(),
                SizedBox(height: 24),
                _isLoading
                    ? CircularProgressIndicator()
                    : _shippingInfo != null
                        ? _buildShippingInfo()
                        : Text('No shipping info available.'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => openPaypalCheckout(context),
                  child: Text('Submit Order'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    textStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

    return Container(
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
    );
  }

  Widget _buildProductInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Model', widget.product.model),
            _buildInfoRow('Brand', widget.product.brand?.name),
            _buildInfoRow(
                'Price',
                widget.product.price != null
                    ? '\$${widget.product.price?.toStringAsFixed(2)}'
                    : 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('Street Address', _shippingInfo!.streetAddress),
            _buildInfoRow('City', _shippingInfo!.city),
            _buildInfoRow('State/Province', _shippingInfo!.stateOrProvince),
            _buildInfoRow('Zip Code', _shippingInfo!.zipCode),
            _buildInfoRow('Country', _shippingInfo!.country),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
