import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/amplifier/amplifier.dart';
import 'package:musicshop_mobile/pages/order_page.dart';

class AmplifierDetailsPage extends StatefulWidget {
  final Amplifier amplifier;

  AmplifierDetailsPage({required this.amplifier});

  @override
  _AmplifierDetailsPageState createState() => _AmplifierDetailsPageState();
}

class _AmplifierDetailsPageState extends State<AmplifierDetailsPage> {
  late String _imageBase64;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _imageBase64 = widget.amplifier.productImage ?? '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBase64 = base64Encode(bytes);
      });
    }
  }

  void _navigateToOrderPage() {
    final product = Product();
    product.id = widget.amplifier.id;
    product.model = widget.amplifier.model;
    product.price = widget.amplifier.price;
    product.description = widget.amplifier.description;
    product.productImage = widget.amplifier.productImage;
    product.brand = widget.amplifier.brand;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderPage(product: product),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final amplifier = widget.amplifier;

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Amplifier Details'),
        backgroundColor: Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 400,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _imageBase64.isNotEmpty
                        ? Image.memory(
                            base64Decode(_imageBase64),
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 200,
                            color: Color(0xFF1F1F1F),
                            child: Center(
                              child: Icon(Icons.image, size: 60, color: Colors.grey[700]),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24),
                _buildDetailRow(Icons.devices, 'Model', amplifier.model ?? 'N/A'),
                _buildDetailRow(Icons.branding_watermark, 'Brand', amplifier.brand?.name ?? 'Unknown Brand'),
                _buildDetailRow(Icons.attach_money, 'Price', amplifier.price != null ? '\$${amplifier.price!.toStringAsFixed(2)}' : 'N/A'),
                Divider(color: Colors.grey[700], height: 32, thickness: 1),
                _buildDetailRow(Icons.description, 'Description', amplifier.description ?? 'No description'),
                Divider(color: Colors.grey[700], height: 32, thickness: 1),
                _buildDetailRow(Icons.bolt, 'Voltage', amplifier.voltage?.toString() ?? 'N/A'),
                _buildDetailRow(Icons.power, 'Power Rating', amplifier.powerRating?.toString() ?? 'N/A'),
                _buildDetailRow(Icons.settings_input_component, 'Number of Presets', amplifier.numberOfPresets?.toString() ?? 'N/A'),
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
