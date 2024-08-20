import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';
import 'package:musicshop_admin/models/guitar/guitar.dart';
import 'package:musicshop_admin/models/guitar/guitar_update_request.dart';

class GuitarDetailsPage extends StatefulWidget {
  final Guitar guitar;

  GuitarDetailsPage({required this.guitar});

  @override
  _GuitarDetailsPageState createState() => _GuitarDetailsPageState();
}

class _GuitarDetailsPageState extends State<GuitarDetailsPage> {
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _pickupsController;
  late TextEditingController _pickupConfigurationController;
  late TextEditingController _fretsController;
  late GuitarProvider _guitarProvider;
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
    _guitarProvider = Provider.of<GuitarProvider>(context, listen: false);
    _modelController = TextEditingController(text: widget.guitar.model);
    _priceController =
        TextEditingController(text: widget.guitar.price?.toStringAsFixed(2));
    _descriptionController =
        TextEditingController(text: widget.guitar.description);
    _pickupsController = TextEditingController(text: widget.guitar.pickups);
    _pickupConfigurationController =
        TextEditingController(text: widget.guitar.pickupConfiguration);
    _fretsController =
        TextEditingController(text: widget.guitar.frets?.toString());
    _imageBase64 = widget.guitar.productImage ?? '';
    _fetchData();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _pickupsController.dispose();
    _pickupConfigurationController.dispose();
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
        _selectedBrandId = widget.guitar.brand?.id;
        _selectedGuitarTypeId = widget.guitar.guitarType?.id;
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

  Future<void> _updateGuitar() async {
    final model = _modelController.text;
    final price = double.tryParse(_priceController.text);
    final description = _descriptionController.text;
    final pickups = _pickupsController.text;
    final pickupConfiguration = _pickupConfigurationController.text;
    final frets = int.tryParse(_fretsController.text);
    final id = widget.guitar.id;

    if (model.isEmpty ||
        price == null ||
        description.isEmpty ||
        pickups.isEmpty ||
        pickupConfiguration.isEmpty ||
        frets == null ||
        id == null ||
        _selectedBrandId == null ||
        _selectedGuitarTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide valid details')));
      return;
    }

    try {
      final updateRequest = GuitarUpdateRequest()
        ..id = id
        ..model = model
        ..price = price
        ..description = description
        ..pickups = pickups
        ..pickupConfiguration = pickupConfiguration
        ..frets = frets
        ..image = _imageBase64
        ..brandId = _selectedBrandId
        ..guitarTypeId = _selectedGuitarTypeId;

      await _guitarProvider.update(id, updateRequest);

      setState(() {
        widget.guitar.model = model;
        widget.guitar.price = price;
        widget.guitar.description = description;
        widget.guitar.pickups = pickups;
        widget.guitar.pickupConfiguration = pickupConfiguration;
        widget.guitar.frets = frets;
        widget.guitar.productImage = _imageBase64;
        widget.guitar.brand =
            _brands.firstWhere((b) => b.id == _selectedBrandId);
        widget.guitar.guitarType =
            _guitarTypes.firstWhere((t) => t.id == _selectedGuitarTypeId);
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Guitar updated successfully'),
      ));

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update guitar: $e'),
      ));
    }
  }

  bool _isAcousticGuitar() {
    return _guitarTypes
            .firstWhere(
              (type) => type.id == _selectedGuitarTypeId,
              orElse: () => GuitarType(name: 'Unknown'),
            )
            .name ==
        'Acoustic';
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? _imageBytes;
    if (_imageBase64.isNotEmpty) {
      try {
        _imageBytes = base64Decode(_imageBase64);
      } catch (e) {
        print('Error decoding base64 image: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Guitar Details')),
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
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 300,
                              maxHeight: 300,
                            ),
                            child: _imageBytes != null
                                ? Image.memory(
                                    _imageBytes,
                                    fit: BoxFit.cover,
                                  )
                                : Placeholder(),
                          ),
                        ),
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
                                enabled: !_isAcousticGuitar(),
                                validator: (value) => _isAcousticGuitar() &&
                                        value != null
                                    ? 'Pickups are not applicable for Acoustic guitars'
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                              child: TextFormField(
                                controller: _pickupConfigurationController,
                                decoration: InputDecoration(
                                    labelText: 'Pickup Configuration'),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 16),
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
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _updateGuitar,
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
