import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/bass/bass.dart';
import 'package:musicshop_mobile/pages/order_page.dart';

class BassDetailsPage extends StatelessWidget {
  final Bass bass;

  BassDetailsPage({required this.bass});

  Widget _buildImageSection() {
    Uint8List? _imageBytes;
    if (bass.productImage != null && bass.productImage!.isNotEmpty) {
      try {
        _imageBytes = base64Decode(bass.productImage!);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: 400,
        maxHeight: 400,
      ),
      child: _imageBytes != null
          ? Image.memory(
              _imageBytes,
              fit: BoxFit.cover,
            )
          : Placeholder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bass Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Model: ${bass.model ?? 'Unknown Model'}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Brand: ${bass.brand?.name ?? 'Unknown Brand'}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Description: ${bass.description ?? 'No Description'}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pickups: ${bass.pickups ?? 'No Pickups'}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Frets: ${bass.frets?.toString() ?? 'No Frets Information'}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Price: \$${bass.price?.toStringAsFixed(2) ?? 'No Price'}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final product = Product()
                          ..id = bass.id
                          ..model = bass.model
                          ..price = bass.price
                          ..description = bass.description
                          ..productImage = bass.productImage
                          ..brand = bass.brand;

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderPage(product: product),
                          ),
                        );
                      },
                      child: Text('Order'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
