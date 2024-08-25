import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';
import 'package:musicshop_mobile/models/gear/gear.dart';
import 'package:musicshop_mobile/pages/order_page.dart';
import 'package:musicshop_mobile/providers/product/brand_provider.dart';
import 'package:musicshop_mobile/providers/product/gear_provider.dart';
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
  int? _selectedBrandId;

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

    _fetchBrands();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchBrands() async {
    final brandProvider = Provider.of<BrandProvider>(context, listen: false);

    try {
      final brandResult = await brandProvider.get();

      setState(() {
        _brands = brandResult;
        _selectedBrandId = widget.gear.brand?.id;
      });
    } catch (e) {
      print("Error fetching brands: $e");
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

  void _navigateToOrderPage() {
    final product = Product();

    product.id = widget.gear.id;
    product.model = widget.gear.model;
    product.price = widget.gear.price;
    product.description = widget.gear.description;
    product.productImage = widget.gear.productImage;
    product.brand = Brand();
    product.brand?.id = widget.gear.brand?.id;
    product.brand?.name = widget.gear.brand?.name;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderPage(product: product),
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
                  'Model: ${widget.gear.model}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Brand: ${widget.gear.brand?.name ?? 'Unknown Brand'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: \$${widget.gear.price?.toStringAsFixed(2) ?? 'N/A'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  'Description: ${widget.gear.description ?? 'No description'}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 8),
                Divider(),
                Text(
                  'Gear Category: ${widget.gear.gearCategory?.name ?? 'Unknown Category'}',
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
