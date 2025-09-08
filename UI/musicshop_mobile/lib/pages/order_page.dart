import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/order/order_insert_request.dart';
import 'package:musicshop_mobile/models/shipping_info/shipping_info.dart';
import 'package:musicshop_mobile/providers/order_provider/order_provider.dart';
import 'package:musicshop_mobile/providers/shipping_info/shipping_info_provider.dart';
import 'package:musicshop_mobile/pages/order_search_page.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  final Product product;
  OrderPage({Key? key, required this.product}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ScrollController _scrollController = ScrollController();
  ShippingInfo? _shippingInfo;
  bool _isLoading = true;
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  String _selectedCountry = 'US';
  String? _streetError, _cityError, _stateError, _zipError, _countryError;

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

  @override
  void initState() {
    super.initState();
    _fetchShippingInfo();
  }

  bool _isShippingInfoComplete() {
    return _streetController.text.isNotEmpty &&
        _cityController.text.isNotEmpty &&
        _stateController.text.isNotEmpty &&
        _zipController.text.isNotEmpty &&
        _selectedCountry.isNotEmpty;
  }

  void _updateShippingInfo() {
    _shippingInfo ??= ShippingInfo();
    final _customer = _shippingInfo?.customer;
    _shippingInfo!
      ..streetAddress = _streetController.text
      ..city = _cityController.text
      ..stateOrProvince = _stateController.text
      ..zipCode = _zipController.text
      ..country = _selectedCountry
      ..customer = _customer;
  }

  Future<void> _fetchShippingInfo() async {
    final provider = Provider.of<ShippingInfoProvider>(context, listen: false);
    try {
      final info = await provider.getByCustomerId();
      setState(() {
        if (info != null) {
          _streetController.text = info.streetAddress ?? '';
          _cityController.text = info.city ?? '';
          _stateController.text = info.stateOrProvince ?? '';
          _zipController.text = info.zipCode ?? '';
          _selectedCountry = info.country ?? 'US';
          _shippingInfo = info;
        }
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitOrder(String paymentId) async {
    if (_shippingInfo == null) return;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final request = OrderInsertRequest()
      ..shippingInfoId = _shippingInfo!.id
      ..productId = widget.product.id
      ..paymentId = paymentId;

    try {
      await orderProvider.insert(request);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green[700],
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OrdersSearchPage()),
        );
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: Colors.red[700],
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void openPaypalCheckout() {
    if (_shippingInfo == null) return;
    _updateShippingInfo();
    final product = widget.product;
    final shippingInfo = _shippingInfo!;
    final recipientName =
        '${shippingInfo.customer?.firstName ?? ''} ${shippingInfo.customer?.lastName ?? ''}'.trim();
    final safeRecipient = recipientName.isEmpty ? 'Customer' : recipientName;
    final safeCountry = ['US', 'GB', 'DE', 'FR', 'IT', 'ES'].contains(shippingInfo.country)
        ? shippingInfo.country!
        : 'US';
    final safePhone = shippingInfo.customer?.phoneNumber?.isNotEmpty == true
        ? shippingInfo.customer!.phoneNumber!
        : '0000000000';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => UsePaypal(
          sandboxMode: true,
          clientId: "AcBfWwnXZ0jMKDxDJt_gqDp2XzBt9N1_YjqnYlBm35NeryUJWjuWGeswYgXlepmYZLcPFRnj9aZVFMzm",
          secretKey: "EIuUXSQNklabUxNwfGhPrfWZ87_pUNqTwqjqSINjg6ld7hpjAqjVhPQoUZJ7moSgnug31Ub_6mjoXP6m",
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
              "payment_options": {"allowed_payment_method": "INSTANT_FUNDING_SOURCE"},
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
                  "recipient_name": safeRecipient,
                  "line1": shippingInfo.streetAddress ?? '',
                  "line2": '',
                  "city": shippingInfo.city ?? '',
                  "country_code": safeCountry,
                  "postal_code": shippingInfo.zipCode ?? '',
                  "phone": safePhone,
                  "state": shippingInfo.stateOrProvince ?? ''
                }
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (params) => _submitOrder(params["paymentId"]),
          onError: (_) {},
          onCancel: (_) {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            _buildImageSection(),
            SizedBox(height: 24),
            _buildProductInfo(),
            SizedBox(height: 24),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.amber[700]))
                : _buildEditableShippingInfo(),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _updateShippingInfo();
                  setState(() {
                    _streetError = _streetController.text.isEmpty ? 'Street is required' : null;
                    _cityError = _cityController.text.isEmpty ? 'City is required' : null;
                    _stateError = _stateController.text.isEmpty ? 'State/Province is required' : null;
                    _zipError = _zipController.text.isEmpty ? 'Zip Code is required' : null;
                    _countryError = _selectedCountry.isEmpty ? 'Country is required' : null;
                  });
                  if (_streetError != null ||
                      _cityError != null ||
                      _stateError != null ||
                      _zipError != null ||
                      _countryError != null) return;
                  openPaypalCheckout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Submit Order', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    Uint8List? bytes;
    if (widget.product.productImage != null) {
      try {
        bytes = base64Decode(widget.product.productImage!);
      } catch (_) {}
    }
    return Container(
      constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[700]!),
      ),
      clipBehavior: Clip.antiAlias,
      child: bytes != null
          ? Image.memory(bytes, fit: BoxFit.cover)
          : Container(
              height: 200,
              color: Color(0xFF1F1F1F),
              child: Center(child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey[700])),
            ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      children: [
        _buildDetailRow('Model', widget.product.model ?? 'N/A'),
        _buildDetailRow('Brand', widget.product.brand?.name ?? 'Unknown Brand'),
        _buildDetailRow('Price', widget.product.price != null ? '\$${widget.product.price!.toStringAsFixed(2)}' : 'N/A'),
      ],
    );
  }

  Widget _buildEditableShippingInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Street Address', _streetController, _streetError),
        _buildTextField('City', _cityController, _cityError),
        _buildTextField('State/Province', _stateController, _stateError),
        _buildTextField('Zip Code', _zipController, _zipError),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: DropdownButtonFormField<String>(
            value: _selectedCountry,
            items: countryCodes.map((c) => DropdownMenuItem(
              value: c['code'],
              child: Text('${c['name']} (${c['code']})', style: TextStyle(color: Colors.white70)),
            )).toList(),
            onChanged: (value) => setState(() { if (value != null) { _selectedCountry = value; _countryError = null; }}),
            decoration: InputDecoration(
              labelText: 'Country',
              labelStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(),
              errorText: _countryError,
              errorStyle: TextStyle(color: Colors.redAccent),
            ),
            dropdownColor: Color(0xFF1F1F1F),
          ),
        ),
        if (!_isShippingInfoComplete())
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text('Please fill out all shipping info to proceed.', style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
          ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String? errorText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[500]),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFF1F1F1F),
          errorText: errorText,
          errorStyle: TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, size: 20, color: Colors.grey[400]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, -6),
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey[500], letterSpacing: 1),
                  ),
                ),
                SizedBox(height: 4),
                Text(value, style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
