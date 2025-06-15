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

  Widget buildInfoRow(IconData icon, String label, String value, TextStyle? labelStyle, TextStyle? valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: labelStyle),
                SizedBox(height: 4),
                Text(value, style: valueStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Gear Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 400,
                        maxHeight: 400,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _imageBase64.isNotEmpty
                          ? Image.memory(
                              base64Decode(_imageBase64),
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 200,
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 24),
                  buildInfoRow(
                    Icons.devices,
                    'Model',
                    widget.gear.model ?? 'Unknown Model',
                    theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                    theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  buildInfoRow(
                    Icons.branding_watermark,
                    'Brand',
                    widget.gear.brand?.name ?? 'Unknown Brand',
                    theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                    theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
                  buildInfoRow(
                    Icons.attach_money,
                    'Price',
                    widget.gear.price != null
                        ? '\$${widget.gear.price!.toStringAsFixed(2)}'
                        : 'N/A',
                    theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                    theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  buildInfoRow(
                    Icons.description,
                    'Description',
                    widget.gear.description ?? 'No description',
                    theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                    theme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  buildInfoRow(
                    Icons.category,
                    'Gear Category',
                    widget.gear.gearCategory?.name ?? 'Unknown Category',
                    theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                    theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToOrderPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Order',
                        style: TextStyle(fontSize: 18),
                      ),
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
