import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/guitar/guitar.dart';
import 'package:musicshop_mobile/pages/order_page.dart';

class GuitarDetailsPage extends StatefulWidget {
  final Guitar guitar;

  GuitarDetailsPage({required this.guitar});

  @override
  _GuitarDetailsPageState createState() => _GuitarDetailsPageState();
}

class _GuitarDetailsPageState extends State<GuitarDetailsPage> {
  late String _imageBase64;

  @override
  void initState() {
    super.initState();
    _imageBase64 = widget.guitar.productImage ?? '';
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[400]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.translate(
                  offset: Offset(0, -6),
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToOrderPage() {
    final product = Product()
      ..id = widget.guitar.id
      ..model = widget.guitar.model
      ..price = widget.guitar.price
      ..description = widget.guitar.description
      ..productImage = widget.guitar.productImage
      ..brand = widget.guitar.brand;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    if (_imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(_imageBase64);
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Guitar Details'),
        backgroundColor: Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imageBytes != null
                      ? Image.memory(imageBytes, fit: BoxFit.cover)
                      : Container(
                          height: 200,
                          color: Color(0xFF1F1F1F),
                          child: Center(
                            child: Icon(Icons.image_not_supported, size: 60, color: Colors.grey[700]),
                          ),
                        ),
                ),
                SizedBox(height: 24),
                _buildDetailRow(Icons.devices, 'Model', widget.guitar.model ?? 'N/A'),
                _buildDetailRow(Icons.branding_watermark, 'Brand', widget.guitar.brand?.name ?? 'Unknown Brand'),
                _buildDetailRow(Icons.description, 'Description', widget.guitar.description ?? 'No description'),
                _buildDetailRow(Icons.music_note, 'Pickups', widget.guitar.pickups ?? 'N/A'),
                _buildDetailRow(Icons.settings_input_component, 'Pickup Configuration', widget.guitar.pickupConfiguration ?? 'N/A'),
                _buildDetailRow(Icons.format_list_numbered, 'Frets', widget.guitar.frets?.toString() ?? 'N/A'),
                _buildDetailRow(Icons.attach_money, 'Price', widget.guitar.price != null ? '\$${widget.guitar.price!.toStringAsFixed(2)}' : 'N/A'),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _navigateToOrderPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Order',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
