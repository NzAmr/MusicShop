import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/gear/gear.dart';
import 'package:musicshop_admin/models/gear/gear_update_request.dart';
import 'package:musicshop_admin/models/gear_category/gear_category.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/gear_category_provider.dart';
import 'package:musicshop_admin/providers/product/gear_provider.dart';
import 'package:provider/provider.dart';

class GearDetailsPage extends StatefulWidget {
  final Gear gear;

  GearDetailsPage({required this.gear});

  @override
  _GearDetailsPageState createState() => _GearDetailsPageState();
}

class _GearDetailsPageState extends State<GearDetailsPage> {
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late GearProvider _gearProvider;
  String _imageBase64 = '';
  File? _imageFile;

  List<Brand> _brands = [];
  List<GearCategory> _gearCategories = [];
  int? _selectedBrandId;
  int? _selectedGearCategoryId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _gearProvider = Provider.of<GearProvider>(context, listen: false);
    _modelController = TextEditingController(text: widget.gear.model);
    _priceController =
        TextEditingController(text: widget.gear.price?.toStringAsFixed(2));
    _descriptionController =
        TextEditingController(text: widget.gear.description);
    _imageBase64 = widget.gear.productImage ?? '';
    _selectedBrandId = widget.gear.brand?.id;
    _selectedGearCategoryId = widget.gear.gearCategory?.id;

    _fetchData();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);
    final gearCategoryProvider =
        Provider.of<GearCategoryProvider>(context, listen: false);

    try {
      final brandResult = await brandProvider.get();
      final gearCategoryResult = await gearCategoryProvider.get();

      setState(() {
        _brands = brandResult;
        _gearCategories = gearCategoryResult;
        _selectedBrandId = widget.gear.brand?.id;
        _selectedGearCategoryId = widget.gear.gearCategory?.id;
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

  Future<void> _updateGear() async {
    final model = _modelController.text;
    final price = double.tryParse(_priceController.text);
    final description = _descriptionController.text;
    final id = widget.gear.id;

    if (model.isEmpty ||
        price == null ||
        description.isEmpty ||
        id == null ||
        _selectedBrandId == null ||
        _selectedGearCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide valid details')));
      return;
    }

    try {
      final updateRequest = GearUpdateRequest()
        ..id = id
        ..model = model
        ..price = price
        ..description = description
        ..productImage = _imageBase64
        ..brandId = _selectedBrandId
        ..gearCategoryId = _selectedGearCategoryId;

      await _gearProvider.update(id, updateRequest);

      setState(() {
        widget.gear.model = model;
        widget.gear.price = price;
        widget.gear.description = description;
        widget.gear.productImage = _imageBase64;
        widget.gear.brand = _brands.firstWhere((b) => b.id == _selectedBrandId);
        widget.gear.gearCategory =
            _gearCategories.firstWhere((c) => c.id == _selectedGearCategoryId);
        print(widget.gear.gearCategory?.name);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gear updated successfully'),
      ));

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update gear: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gear Details')),
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
                                value: _selectedGearCategoryId,
                                hint: Text('Select Gear Category'),
                                items: _gearCategories.map((category) {
                                  return DropdownMenuItem<int>(
                                    value: category.id,
                                    child: Text(
                                        category.name ?? 'Unknown Category'),
                                  );
                                }).toList(),
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedGearCategoryId = value;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a gear category'
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
                            minLines: 11,
                            maxLines: 15,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _updateGear,
                          child: Text('Update'),
                        ),
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
