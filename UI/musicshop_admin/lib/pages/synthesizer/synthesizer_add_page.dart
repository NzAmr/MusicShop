import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/synthesizer_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/synthesizer/synthesizer_insert_request.dart';

class AddSynthesizerPage extends StatefulWidget {
  @override
  _AddSynthesizerPageState createState() => _AddSynthesizerPageState();
}

class _AddSynthesizerPageState extends State<AddSynthesizerPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedBrandId;
  String? _model;
  double? _price;
  String? _description;
  int? _keyboardSize;
  bool? _weighedKeys;
  int? _polyphony;
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
      appBar: AppBar(title: Text('Add Synthesizer')),
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
                      decoration: InputDecoration(labelText: 'Keyboard Size'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _keyboardSize = int.tryParse(value);
                      },
                    ),
                    SizedBox(height: 16),
                    SwitchListTile(
                      title: Text('Weighed Keys'),
                      value: _weighedKeys ?? false,
                      onChanged: (value) {
                        setState(() {
                          _weighedKeys = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Polyphony'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _polyphony = int.tryParse(value);
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
    final synthesizerProvider =
        Provider.of<SynthesizerProvider>(context, listen: false);

    final request = SynthesizerInsertRequest()
      ..BrandId = _selectedBrandId
      ..Model = _model
      ..Price = _price
      ..Description = _description
      ..KeyboardSize = _keyboardSize
      ..WeighedKeys = _weighedKeys
      ..Polyphony = _polyphony
      ..NumberOfPresets = _numberOfPresets
      ..image = _base64Image;

    try {
      await synthesizerProvider.insert(request);
      Navigator.pop(context);
    } catch (e) {
      print("Error submitting form: $e");
    }
  }
}
