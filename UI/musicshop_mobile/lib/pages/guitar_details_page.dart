import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/guitar/guitar.dart';
import 'package:musicshop_mobile/pages/order_page.dart';

class GuitarDetailsPage extends StatelessWidget {
  final Guitar guitar;

  GuitarDetailsPage({required this.guitar});

  Widget _buildImageSection() {
    Uint8List? _imageBytes;
    if (guitar.productImage != null && guitar.productImage!.isNotEmpty) {
      try {
        _imageBytes = base64Decode(guitar.productImage!);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
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
      appBar: AppBar(title: Text('Guitar Details')),
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
                        'Model: ${guitar.model ?? 'Unknown Model'}',
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
                        'Brand: ${guitar.brand?.name ?? 'Unknown Brand'}',
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
                        'Description: ${guitar.description ?? 'No Description'}',
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
                        'Pickups: ${guitar.pickups ?? 'No Pickups'}',
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
                        'Pickup Configuration: ${guitar.pickupConfiguration ?? 'No Pickup Configuration'}',
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
                        'Frets: ${guitar.frets?.toString() ?? 'No Frets Information'}',
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
                        'Price: \$${guitar.price?.toStringAsFixed(2) ?? 'No Price'}',
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
                          ..id = guitar.id
                          ..model = guitar.model
                          ..price = guitar.price
                          ..description = guitar.description
                          ..productImage = guitar.productImage
                          ..brand = guitar.brand;
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
