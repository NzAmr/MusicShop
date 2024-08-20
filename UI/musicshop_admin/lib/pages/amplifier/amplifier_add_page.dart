import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/amplifier_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/amplifier/amplifier_insert_request.dart';

class AddAmplifierPage extends StatefulWidget {
  @override
  _AddAmplifierPageState createState() => _AddAmplifierPageState();
}

class _AddAmplifierPageState extends State<AddAmplifierPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedBrandId;
  String? _model;
  double? _price;
  String? _description;
  int? _voltage;
  int? _powerRating;
  bool? _headphoneJack = false;
  bool? _usbJack = false;
  int? _numberOfPresets;
  File? _imageFile;
  String? _base64Image;

  List<Brand> _brands = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);

    try {
      final brandResult = await brandProvider.get();

      setState(() {
        _brands = brandResult;
        if (_brands.isNotEmpty && _selectedBrandId == null) {
          _selectedBrandId = _brands.first.id;
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
      appBar: AppBar(title: Text('Add Amplifier')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
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
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Model'),
                      onChanged: (value) {
                        _model = value;
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
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      onChanged: (value) {
                        _description = value;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Voltage'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _voltage = int.tryParse(value);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Power Rating'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _powerRating = int.tryParse(value);
                      },
                    ),
                    SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text('Headphone Jack'),
                      value: _headphoneJack,
                      onChanged: (bool? value) {
                        setState(() {
                          _headphoneJack = value;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('USB Jack'),
                      value: _usbJack,
                      onChanged: (bool? value) {
                        setState(() {
                          _usbJack = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Number of Presets'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _numberOfPresets = int.tryParse(value);
                      },
                    ),
                    SizedBox(height: 20),
                    _imageFile == null
                        ? Text('No image selected.')
                        : SizedBox(
                            width: 200,
                            height: 150,
                            child: Image.file(_imageFile!, fit: BoxFit.cover),
                          ),
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
    final amplifierProvider =
        Provider.of<AmplifierProvider>(context, listen: false);

    final request = AmplifierInsertRequest()
      ..brandId = _selectedBrandId
      ..model = _model
      ..price = _price
      ..description = _description
      ..voltage = _voltage
      ..powerRating = _powerRating
      ..headphoneJack = _headphoneJack
      ..usbjack = _usbJack
      ..numberOfPresets = _numberOfPresets
      ..image = _base64Image;

    try {
      await amplifierProvider.insert(request);
      Navigator.pop(context);
    } catch (e) {
      print("Error submitting form: $e");
    }
  }
}
