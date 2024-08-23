import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_admin/models/abstract/product.dart';
import 'package:musicshop_admin/pages/order/order_details_page.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/amplifier_provider.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/amplifier/amplifier.dart';
import 'package:musicshop_admin/models/amplifier/amplifier_update_request.dart';

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
  late AmplifierProvider _amplifierProvider;
  String _imageBase64 = '';
  File? _imageFile;

  List<Brand> _brands = [];
  int? _selectedBrandId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amplifierProvider = Provider.of<AmplifierProvider>(context, listen: false);
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
    _fetchData();
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

  Future<void> _fetchData() async {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);

    try {
      final brandResult = await brandProvider.get();

      setState(() {
        _brands = brandResult;
        _selectedBrandId = widget.amplifier.brand?.id;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
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

  Future<void> _updateAmplifier() async {
    final model = _modelController.text;
    final price = double.tryParse(_priceController.text);
    final description = _descriptionController.text;
    final voltage = int.tryParse(_voltageController.text);
    final powerRating = int.tryParse(_powerRatingController.text);
    final numberOfPresets = int.tryParse(_numberOfPresetsController.text);
    final id = widget.amplifier.id;

    if (model.isEmpty ||
        price == null ||
        description.isEmpty ||
        voltage == null ||
        powerRating == null ||
        numberOfPresets == null ||
        id == null ||
        _selectedBrandId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please provide valid details')));
      return;
    }

    try {
      final updateRequest = AmplifierUpdateRequest()
        ..id = id
        ..model = model
        ..price = price
        ..description = description
        ..voltage = voltage
        ..powerRating = powerRating
        ..numberOfPresets = numberOfPresets
        ..productImage = _imageBase64
        ..brandId = _selectedBrandId;

      await _amplifierProvider.update(id, updateRequest);

      setState(() {
        widget.amplifier.model = model;
        widget.amplifier.price = price;
        widget.amplifier.description = description;
        widget.amplifier.voltage = voltage;
        widget.amplifier.powerRating = powerRating;
        widget.amplifier.numberOfPresets = numberOfPresets;
        widget.amplifier.productImage = _imageBase64;
        widget.amplifier.brand =
            _brands.firstWhere((b) => b.id == _selectedBrandId);
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Amplifier updated successfully'),
      ));

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update amplifier: $e'),
      ));
    }
  }

  Widget _buildImageSection() {
    Uint8List? _imageBytes;
    if (_imageBase64.isNotEmpty) {
      try {
        _imageBytes = base64Decode(_imageBase64);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
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
      ),
    );
  }

  void _navigateToOrderDetailsPage() {
    final product = Product();

    product.id = widget.amplifier.id;
    product.model = widget.amplifier.model;
    product.price = widget.amplifier.price;
    product.description = widget.amplifier.description;
    product.productImage = widget.amplifier.productImage;
    product.brand = new Brand();
    product.brand?.id = widget.amplifier.brand?.id;
    product.brand?.name = widget.amplifier.brand?.name;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(product: product),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildImageSection(),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _modelController,
                                decoration: InputDecoration(labelText: 'Model'),
                                maxLines: 1,
                              ),
                              SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                value: _selectedBrandId,
                                hint: Text('Select Brand'),
                                items: _brands.map((brand) {
                                  return DropdownMenuItem<int>(
                                    value: brand.id,
                                    child: Text(brand.name ?? 'Unknown Brand'),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedBrandId = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a brand'
                                    : null,
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _priceController,
                                decoration: InputDecoration(labelText: 'Price'),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextFormField(
                            controller: _descriptionController,
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            keyboardType: TextInputType.multiline,
                            minLines: 5,
                            maxLines: 10,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: TextFormField(
                                controller: _voltageController,
                                decoration:
                                    InputDecoration(labelText: 'Voltage'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: TextFormField(
                                controller: _powerRatingController,
                                decoration:
                                    InputDecoration(labelText: 'Power Rating'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                              child: TextFormField(
                                controller: _numberOfPresetsController,
                                decoration: InputDecoration(
                                    labelText: 'Number of Presets'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: _updateAmplifier,
                                child: Text('Update'),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _navigateToOrderDetailsPage,
                                child: Text('Order'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
