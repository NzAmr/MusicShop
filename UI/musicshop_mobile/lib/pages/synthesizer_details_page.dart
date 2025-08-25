import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/synthesizer/synthesizer.dart';
import 'package:musicshop_mobile/pages/order_page.dart';

class SynthesizerDetailsPage extends StatelessWidget {
  final Synthesizer synthesizer;

  SynthesizerDetailsPage({required this.synthesizer});

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

  Widget _buildImageSection(String? imageBase64) {
    Uint8List? imageBytes;
    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(imageBase64);
      } catch (_) {}
    }

    return Container(
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
                child: Icon(Icons.image_not_supported,
                    size: 60, color: Colors.grey[700]),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Synthesizer Details'),
        backgroundColor: Color(0xFF1F1F1F),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildImageSection(synthesizer.productImage),
                SizedBox(height: 24),
                _buildDetailRow(Icons.devices, 'Model', synthesizer.model ?? 'N/A'),
                _buildDetailRow(Icons.branding_watermark, 'Brand', synthesizer.brand?.name ?? 'Unknown Brand'),
                _buildDetailRow(Icons.attach_money, 'Price', synthesizer.price != null ? '\$${synthesizer.price!.toStringAsFixed(2)}' : 'N/A'),
                _buildDetailRow(Icons.description, 'Description', synthesizer.description ?? 'No description'),
                _buildDetailRow(Icons.keyboard, 'Keyboard Size', synthesizer.keyboardSize?.toString() ?? 'N/A'),
                _buildDetailRow(Icons.music_note, 'Polyphony', synthesizer.polyphony?.toString() ?? 'N/A'),
                _buildDetailRow(Icons.library_music, 'Number of Presets', synthesizer.numberOfPresets?.toString() ?? 'N/A'),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final product = Product()
                        ..id = synthesizer.id
                        ..model = synthesizer.model
                        ..price = synthesizer.price
                        ..description = synthesizer.description
                        ..productImage = synthesizer.productImage
                        ..brand = synthesizer.brand;

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderPage(product: product),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Order',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
