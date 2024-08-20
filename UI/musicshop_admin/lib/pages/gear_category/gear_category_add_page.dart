import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/requests/name_upsert_request.dart';
import 'package:musicshop_admin/providers/product/gear_category_provider.dart';

class AddGearCategoryPage extends StatefulWidget {
  const AddGearCategoryPage({super.key});

  @override
  State<AddGearCategoryPage> createState() => _AddGearCategoryPageState();
}

class _AddGearCategoryPageState extends State<AddGearCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final GearCategoryProvider _gearCategoryProvider = GearCategoryProvider();

  void _saveGearCategory() async {
    final String gearCategoryName = _nameController.text;
    if (gearCategoryName.isNotEmpty) {
      final NameUpsertRequest request = NameUpsertRequest()
        ..name = gearCategoryName;

      try {
        await _gearCategoryProvider.insert(request.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gear Category saved successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save Gear Category: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Gear Category name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Gear Category'),
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
                  labelText: 'Gear Category Name',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveGearCategory,
                child: const Text('Save Gear Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
