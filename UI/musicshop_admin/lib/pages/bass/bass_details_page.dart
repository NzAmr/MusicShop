import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_admin/models/abstract/product.dart';
import 'package:musicshop_admin/pages/order/order_details_page.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/bass_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';
import 'package:musicshop_admin/models/bass/bass.dart';
import 'package:musicshop_admin/models/bass/bass_update_request.dart';

class BassDetailsPage extends StatefulWidget {
  final Bass bass;

  BassDetailsPage({required this.bass});

  @override
  _BassDetailsPageState createState() => _BassDetailsPageState();
}

class _BassDetailsPageState extends State<BassDetailsPage> {
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _pickupsController;
  late TextEditingController _fretsController;
  late BassProvider _bassProvider;
  String _imageBase64 = '';
  File? _imageFile;

  List<Brand> _brands = [];
  List<GuitarType> _guitarTypes = [];
  int? _selectedBrandId;
  int? _selectedGuitarTypeId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bassProvider = Provider.of<BassProvider>(context, listen: false);
    _modelController = TextEditingController(text: widget.bass.model);
    _priceController =
        TextEditingController(text: widget.bass.price?.toStringAsFixed(2));
    _descriptionController =
        TextEditingController(text: widget.bass.description);
    _pickupsController = TextEditingController(text: widget.bass.pickups);
    _fretsController =
        TextEditingController(text: widget.bass.frets?.toString());
    _imageBase64 = widget.bass.productImage ?? '';
    _fetchData();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _pickupsController.dispose();
    _fretsController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);
    final guitarTypeProvider =
        Provider.of<GuitarTypeProvider>(context, listen: false);

    try {
      final brandResult = await brandProvider.get();
      final guitarTypeResult = await guitarTypeProvider.get();

      setState(() {
        _brands = brandResult;
        _guitarTypes = guitarTypeResult;
        _selectedBrandId = widget.bass.brand?.id;
        _selectedGuitarTypeId = widget.bass.guitarType?.id;
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

  Future<void> _updateBass() async {
    final model = _modelController.text;
    final price = double.tryParse(_priceController.text);
    final description = _descriptionController.text;
    final pickups = _pickupsController.text;
    final frets = int.tryParse(_fretsController.text);
    final id = widget.bass.id;

    if (model.isEmpty ||
        price == null ||
        description.isEmpty ||
        pickups.isEmpty ||
        frets == null ||
        id == null ||
        _selectedBrandId == null ||
        _selectedGuitarTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide valid details')));
      return;
    }

    try {
      final updateRequest = BassUpdateRequest()
        ..id = id
        ..model = model
        ..price = price
        ..description = description
        ..pickups = pickups
        ..frets = frets
        ..image = _imageBase64
        ..brandId = _selectedBrandId
        ..guitarTypeId = _selectedGuitarTypeId;

      await _bassProvider.update(id, updateRequest);

      setState(() {
        widget.bass.model = model;
        widget.bass.price = price;
        widget.bass.description = description;
        widget.bass.pickups = pickups;
        widget.bass.frets = frets;
        widget.bass.productImage = _imageBase64;
        widget.bass.brand = _brands.firstWhere((b) => b.id == _selectedBrandId);
        widget.bass.guitarType =
            _guitarTypes.firstWhere((t) => t.id == _selectedGuitarTypeId);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bass updated successfully'),
      ));

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update bass: $e'),
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

  void _navigateToOrderPage() {
    final product = Product();

    product.id = widget.bass.id;
    product.model = widget.bass.model;
    product.price = widget.bass.price;
    product.description = widget.bass.description;
    product.productImage = widget.bass.productImage;
    product.brand = new Brand();
    product.brand?.id = widget.bass.brand?.id;
    product.brand?.name =
        _brands.firstWhere((b) => b.id == widget.bass.brand?.id).name;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderPage(product: product),
      ),
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
                              DropdownButtonFormField<int>(
                                value: _selectedGuitarTypeId,
                                hint: Text('Select Guitar Type'),
                                items: _guitarTypes.map((type) {
                                  return DropdownMenuItem<int>(
                                    value: type.id,
                                    child: Text(type.name ?? 'Unknown Type'),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedGuitarTypeId = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a guitar type'
                                    : null,
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _pickupsController,
                                decoration:
                                    InputDecoration(labelText: 'Pickups'),
                                maxLines: 1,
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
                            minLines: 11,
                            maxLines: 15,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                              child: TextFormField(
                                controller: _fretsController,
                                decoration: InputDecoration(labelText: 'Frets'),
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
                                onPressed: _updateBass,
                                child: Text('Update'),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: _navigateToOrderPage,
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
