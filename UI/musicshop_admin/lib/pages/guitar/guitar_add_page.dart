import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/guitar/guitar_insert_request.dart';

class AddGuitarPage extends StatefulWidget {
  @override
  _AddGuitarPageState createState() => _AddGuitarPageState();
}

class _AddGuitarPageState extends State<AddGuitarPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedBrandId;
  int? _selectedGuitarTypeId;
  String? _pickups;
  String? _pickupConfiguration;
  String? _description;
  String? _model;
  int? _frets;
  double? _price;
  File? _imageFile;
  String? _base64Image;

  List<Brand> _brands = [];
  List<GuitarType> _guitarTypes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
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
        if (_brands.isNotEmpty && _selectedBrandId == null) {
          _selectedBrandId = _brands.first.id;
        }
        if (_guitarTypes.isNotEmpty && _selectedGuitarTypeId == null) {
          _selectedGuitarTypeId = _guitarTypes.first.id;
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
    return Scaffold(
      appBar: AppBar(title: Text('Add Guitar')),
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
                      value: _guitarTypes.isNotEmpty
                          ? _selectedGuitarTypeId
                          : null,
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
                      validator: (value) =>
                          value == null ? 'Please select a guitar type' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Model'),
                      onChanged: (value) {
                        _model = value;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Pickups',
                            ),
                            onChanged: (value) {
                              _pickups = value;
                            },
                            enabled: !_isAcousticGuitar(),
                            validator: (value) => _isAcousticGuitar() &&
                                    value != null
                                ? 'Pickups are not applicable for Acoustic guitars'
                                : null,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Frets',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _frets = int.tryParse(value);
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Price',
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              _price = double.tryParse(value);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Pickup Configuration',
                      ),
                      onChanged: (value) {
                        _pickupConfiguration = value;
                      },
                      enabled: !_isAcousticGuitar(),
                      validator: (value) => _isAcousticGuitar() && value != null
                          ? 'Pickup Configuration is not applicable for Acoustic guitars'
                          : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 5,
                      onChanged: (value) {
                        _description = value;
                      },
                    ),
                    SizedBox(height: 20),
                    _imageFile == null
                        ? Text('No image selected.')
                        : Image.file(
                            _imageFile!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
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
    final guitarProvider = Provider.of<GuitarProvider>(context, listen: false);

    final request = GuitarInsertRequest()
      ..guitarTypeId = _selectedGuitarTypeId
      ..brandId = _selectedBrandId
      ..pickups = _isAcousticGuitar() ? null : _pickups
      ..pickupConfiguration = _isAcousticGuitar() ? null : _pickupConfiguration
      ..description = _description
      ..frets = _frets
      ..price = _price
      ..model = _model
      ..productImage = _base64Image;

    try {
      await guitarProvider.insert(request);
      Navigator.pop(context);
    } catch (e, stackTrace) {
      print("Error submitting form: $e");
      print("Stack trace: $stackTrace");
    }
  }
}
