import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/synthesizer/synthesizer.dart';
import 'package:musicshop_mobile/pages/order_page.dart';

class SynthesizerDetailsPage extends StatelessWidget {
  final Synthesizer synthesizer;

  SynthesizerDetailsPage({required this.synthesizer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Synthesizer Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildImageSection(synthesizer.productImage),
              SizedBox(height: 16),
              Text(
                'Model: ${synthesizer.model}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Brand: ${synthesizer.brand?.name ?? 'Unknown Brand'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Price: \$${synthesizer.price?.toStringAsFixed(2) ?? 'N/A'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Divider(),
              Text(
                'Description: ${synthesizer.description ?? 'No description'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Divider(),
              Text(
                'Keyboard Size: ${synthesizer.keyboardSize?.toString() ?? 'N/A'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Polyphony: ${synthesizer.polyphony?.toString() ?? 'N/A'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Number of Presets: ${synthesizer.numberOfPresets?.toString() ?? 'N/A'}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final product = Product();
                      product.id = synthesizer.id;
                      product.model = synthesizer.model;
                      product.price = synthesizer.price;
                      product.description = synthesizer.description;
                      product.productImage = synthesizer.productImage;
                      product.brand = synthesizer.brand;
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
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(String? imageBase64) {
    Uint8List? imageBytes;
    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(imageBase64);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: double.infinity,
        maxHeight: 400,
      ),
      child: imageBytes != null
          ? Image.memory(
              imageBytes,
              fit: BoxFit.cover,
            )
          : Placeholder(),
    );
  }
}
