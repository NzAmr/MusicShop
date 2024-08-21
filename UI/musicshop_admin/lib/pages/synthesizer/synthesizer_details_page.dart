import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/providers/product/synthesizer_provider.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/models/synthesizer/synthesizer.dart';
import 'package:musicshop_admin/models/synthesizer/synthesizer_update_request.dart';

class SynthesizerDetailsPage extends StatefulWidget {
  final Synthesizer synthesizer;

  SynthesizerDetailsPage({required this.synthesizer});

  @override
  _SynthesizerDetailsPageState createState() => _SynthesizerDetailsPageState();
}

class _SynthesizerDetailsPageState extends State<SynthesizerDetailsPage> {
  late TextEditingController _modelController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _keyboardSizeController;
  late TextEditingController _polyphonyController;
  late TextEditingController _presetsController;
  late SynthesizerProvider _synthesizerProvider;
  String _imageBase64 = '';
  File? _imageFile;

  List<Brand> _brands = [];
  int? _selectedBrandId;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _synthesizerProvider =
        Provider.of<SynthesizerProvider>(context, listen: false);
    _modelController = TextEditingController(text: widget.synthesizer.model);
    _priceController = TextEditingController(
        text: widget.synthesizer.price?.toStringAsFixed(2));
    _descriptionController =
        TextEditingController(text: widget.synthesizer.description);
    _keyboardSizeController = TextEditingController(
        text: widget.synthesizer.keyboardSize?.toString());
    _polyphonyController =
        TextEditingController(text: widget.synthesizer.polyphony?.toString());
    _presetsController = TextEditingController(
        text: widget.synthesizer.numberOfPresets?.toString());
    _imageBase64 = widget.synthesizer.productImage ?? '';
    _fetchData();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _keyboardSizeController.dispose();
    _polyphonyController.dispose();
    _presetsController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);

    try {
      final brandResult = await brandProvider.get();

      setState(() {
        _brands = brandResult;
        _selectedBrandId = widget.synthesizer.brand?.id;
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

  Future<void> _updateSynthesizer() async {
    final model = _modelController.text;
    final price = double.tryParse(_priceController.text);
    final description = _descriptionController.text;
    final keyboardSize = int.tryParse(_keyboardSizeController.text);
    final polyphony = int.tryParse(_polyphonyController.text);
    final numberOfPresets = int.tryParse(_presetsController.text);
    final id = widget.synthesizer.id;

    if (model.isEmpty ||
        price == null ||
        description.isEmpty ||
        keyboardSize == null ||
        polyphony == null ||
        numberOfPresets == null ||
        id == null ||
        _selectedBrandId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide valid details')));
      return;
    }

    try {
      final updateRequest = SynthesizerUpdateRequest()
        ..id = id
        ..model = model
        ..price = price
        ..description = description
        ..keyboardSize = keyboardSize
        ..weighedKeys = widget.synthesizer.weighedKeys
        ..polyphony = polyphony
        ..numberOfPresets = numberOfPresets
        ..image = _imageBase64
        ..brandId = _selectedBrandId;

      await _synthesizerProvider.update(id, updateRequest);

      setState(() {
        widget.synthesizer.model = model;
        widget.synthesizer.price = price;
        widget.synthesizer.description = description;
        widget.synthesizer.keyboardSize = keyboardSize;
        widget.synthesizer.polyphony = polyphony;
        widget.synthesizer.numberOfPresets = numberOfPresets;
        widget.synthesizer.productImage = _imageBase64;
        widget.synthesizer.brand?.id = _selectedBrandId;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Synthesizer updated successfully'),
      ));

      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to update synthesizer: $e'),
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
      appBar: AppBar(title: Text('Synthesizer Details')),
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
                                controller: _keyboardSizeController,
                                decoration:
                                    InputDecoration(labelText: 'Keyboard Size'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                              child: TextFormField(
                                controller: _polyphonyController,
                                decoration:
                                    InputDecoration(labelText: 'Polyphony'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                              child: TextFormField(
                                controller: _presetsController,
                                decoration: InputDecoration(
                                    labelText: 'Number of Presets'),
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _updateSynthesizer,
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
