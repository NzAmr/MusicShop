import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/requests/name_upsert_request.dart';
import 'package:musicshop_admin/providers/product/gear_category_provider.dart';
import 'package:musicshop_admin/models/gear_category/gear_category.dart';

class AddGearCategoryPage extends StatefulWidget {
  const AddGearCategoryPage({super.key});

  @override
  State<AddGearCategoryPage> createState() => _AddGearCategoryPageState();
}

class _AddGearCategoryPageState extends State<AddGearCategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final GearCategoryProvider _gearCategoryProvider = GearCategoryProvider();
  Future<List<GearCategory>>? _gearCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _gearCategoriesFuture = _gearCategoryProvider.get();
  }

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
        setState(() {
          _gearCategoriesFuture = _gearCategoryProvider.get();
        });
        _nameController.clear();
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

  void _deleteGearCategory(int id) async {
    try {
      await _gearCategoryProvider.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gear Category deleted successfully!')),
      );
      setState(() {
        _gearCategoriesFuture = _gearCategoryProvider.get();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Gear Category: $e')),
      );
    }
  }

  void _updateGearCategory(GearCategory gearCategory) async {
    final TextEditingController _updateController =
        TextEditingController(text: gearCategory.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Gear Category'),
          content: TextField(
            controller: _updateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Gear Category Name',
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
                    await _gearCategoryProvider.update(
                        gearCategory.id!, request.toJson());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Gear Category updated successfully!')),
                    );
                    setState(() {
                      _gearCategoriesFuture = _gearCategoryProvider.get();
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to update Gear Category: $e')),
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
        title: const Text('Add Gear Category'),
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
            const SizedBox(height: 24.0),
            Expanded(
              child: FutureBuilder<List<GearCategory>>(
                future: _gearCategoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No Gear Categories available.'));
                  }
                  final gearCategories = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 2 / 1,
                    ),
                    itemCount: gearCategories.length,
                    itemBuilder: (context, index) {
                      final gearCategory = gearCategories[index];
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
                                gearCategory.name ?? 'Unnamed Gear Category',
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
                                onPressed: () =>
                                    _deleteGearCategory(gearCategory.id!),
                              ),
                            ),
                            Positioned(
                              bottom: 4.0,
                              right: 4.0,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _updateGearCategory(gearCategory),
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
