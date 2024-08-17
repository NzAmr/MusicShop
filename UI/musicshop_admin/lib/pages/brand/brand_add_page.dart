import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/requests/name_upsert_request.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';

class AddBrandPage extends StatefulWidget {
  const AddBrandPage({super.key});

  @override
  State<AddBrandPage> createState() => _AddBrandPageState();
}

class _AddBrandPageState extends State<AddBrandPage> {
  final TextEditingController _nameController = TextEditingController();
  final BrandProvider _brandProvider = BrandProvider();

  void _saveBrand() async {
    final String brandName = _nameController.text;
    if (brandName.isNotEmpty) {
      final NameUpsertRequest request = NameUpsertRequest()..name = brandName;

      try {
        await _brandProvider.insert(request.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Brand saved successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save brand: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a brand name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Brand'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Brand Name',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveBrand,
                child: const Text('Save Brand'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
