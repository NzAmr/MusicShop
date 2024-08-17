import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/requests/name_upsert_request.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';

class AddGuitarTypePage extends StatefulWidget {
  const AddGuitarTypePage({super.key});

  @override
  State<AddGuitarTypePage> createState() => _AddGuitarTypePageState();
}

class _AddGuitarTypePageState extends State<AddGuitarTypePage> {
  final TextEditingController _nameController = TextEditingController();
  final GuitarTypeProvider _guitarTypeProvider = GuitarTypeProvider();

  void _saveGuitarType() async {
    final String guitarTypeName = _nameController.text;
    if (guitarTypeName.isNotEmpty) {
      final NameUpsertRequest request = NameUpsertRequest()
        ..name = guitarTypeName;

      try {
        await _guitarTypeProvider.insert(request.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guitar Type saved successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save Guitar Type: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a guitar type name.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Guitar Type'),
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
                  labelText: 'Guitar Type Name',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveGuitarType,
                child: const Text('Save Guitar Type'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
