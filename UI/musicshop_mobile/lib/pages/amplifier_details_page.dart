import 'dart:convert';
import 'dart:typed_data';
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
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _voltageController;
  late TextEditingController _powerRatingController;
  late TextEditingController _numberOfPresetsController;
  String _imageBase64 = '';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _modelController = TextEditingController(text: widget.amplifier.model);
    _priceController =
        TextEditingController(text: widget.amplifier.price?.toStringAsFixed(2));
    _descriptionController =
        TextEditingController(text: widget.amplifier.description);
    _voltageController =
        TextEditingController(text: widget.amplifier.voltage?.toString());
    _powerRatingController =
        TextEditingController(text: widget.amplifier.powerRating?.toString());
    _numberOfPresetsController = TextEditingController(
        text: widget.amplifier.numberOfPresets?.toString());
    _imageBase64 = widget.amplifier.productImage ?? '';
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _voltageController.dispose();
    _powerRatingController.dispose();
    _numberOfPresetsController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Amplifier Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 400,
                      maxHeight: 400,
                    ),
                    child: _imageBase64.isNotEmpty
                        ? Image.memory(
                            base64Decode(_imageBase64),
                            fit: BoxFit.cover,
                          )
                        : Placeholder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Model: ${widget.amplifier.model}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Brand: ${widget.amplifier.brand?.name ?? 'Unknown Brand'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: \$${widget.amplifier.price?.toStringAsFixed(2) ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  'Description: ${widget.amplifier.description ?? 'No description'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  'Voltage: ${widget.amplifier.voltage?.toString() ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Power Rating: ${widget.amplifier.powerRating?.toString() ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Number of Presets: ${widget.amplifier.numberOfPresets?.toString() ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _navigateToOrderPage,
                    child: Text('Order'),
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
