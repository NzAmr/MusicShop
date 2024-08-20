import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/gear_category/gear_category.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/gear_category_provider.dart';
import 'package:musicshop_admin/providers/product/gear_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/gear/gear_insert_request.dart';

class AddGearPage extends StatefulWidget {
  @override
  _AddGearPageState createState() => _AddGearPageState();
}

class _AddGearPageState extends State<AddGearPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedBrandId;
  int? _selectedGearCategoryId;
  String? _description;
  String? _model;
  double? _price;
  File? _imageFile;
  String? _base64Image;

  List<Brand> _brands = [];
  List<GearCategory> _gearCategories = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
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
        if (_brands.isNotEmpty && _selectedBrandId == null) {
          _selectedBrandId = _brands.first.id;
        }
        if (_gearCategories.isNotEmpty && _selectedGearCategoryId == null) {
          _selectedGearCategoryId = _gearCategories.first.id;
        }
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
        _base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Gear')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<int>(
                      value: _brands.isNotEmpty ? _selectedBrandId : null,
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
                      validator: (value) =>
                          value == null ? 'Please select a brand' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _gearCategories.isNotEmpty
                          ? _selectedGearCategoryId
                          : null,
                      hint: Text('Select Gear Category'),
                      items: _gearCategories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name ?? 'Unknown Category'),
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
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Model'),
                      onChanged: (value) {
                        _model = value;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      onChanged: (value) {
                        _description = value;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        _price = double.tryParse(value);
                      },
                    ),
                    SizedBox(height: 20),
                    _imageFile == null
                        ? Text('No image selected.')
                        : SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick Image'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _submitForm();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final gearProvider = Provider.of<GearProvider>(context, listen: false);

    final request = GearInsertRequest()
      ..gearCategoryId = _selectedGearCategoryId
      ..brandId = _selectedBrandId
      ..description = _description
      ..price = _price
      ..model = _model
      ..image = _base64Image;

    try {
      await gearProvider.insert(request);
      Navigator.pop(context);
    } catch (e) {
      print("Error submitting form: $e");
    }
  }
}
