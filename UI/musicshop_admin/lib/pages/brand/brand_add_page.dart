import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
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
  Future<List<Brand>>? _brandsFuture;

  @override
  void initState() {
    super.initState();
    _brandsFuture = _brandProvider.get();
  }

  void _saveBrand() async {
    final String brandName = _nameController.text;
    if (brandName.isNotEmpty) {
      final NameUpsertRequest request = NameUpsertRequest()..name = brandName;

      try {
        await _brandProvider.insert(request.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Brand saved successfully!')),
        );
        setState(() {
          _brandsFuture = _brandProvider.get();
        });
        _nameController.clear();
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

  void _deleteBrand(int id) async {
    try {
      await _brandProvider.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand deleted successfully!')),
      );
      setState(() {
        _brandsFuture = _brandProvider.get();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete brand: $e')),
      );
    }
  }

  void _updateBrand(Brand brand) async {
    final TextEditingController _updateController =
        TextEditingController(text: brand.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Brand'),
          content: TextField(
            controller: _updateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Brand Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String newName = _updateController.text;
                if (newName.isNotEmpty) {
                  final NameUpsertRequest request = NameUpsertRequest()
                    ..name = newName;
                  try {
                    await _brandProvider.update(brand.id!, request.toJson());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Brand updated successfully!')),
                    );
                    setState(() {
                      _brandsFuture = _brandProvider.get();
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update brand: $e')),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Add Brand'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
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
            const SizedBox(height: 24.0),
            Expanded(
              child: FutureBuilder<List<Brand>>(
                future: _brandsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No brands available.'));
                  }
                  final brands = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 2 / 1,
                    ),
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                brand.name ?? 'Unnamed Brand',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4.0,
                              right: 4.0,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteBrand(brand.id!),
                              ),
                            ),
                            Positioned(
                              bottom: 4.0,
                              right: 4.0,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _updateBrand(brand),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
