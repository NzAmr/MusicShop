import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/requests/name_upsert_request.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';

class AddGuitarTypePage extends StatefulWidget {
  const AddGuitarTypePage({super.key});

  @override
  State<AddGuitarTypePage> createState() => _AddGuitarTypePageState();
}

class _AddGuitarTypePageState extends State<AddGuitarTypePage> {
  final TextEditingController _nameController = TextEditingController();
  final GuitarTypeProvider _guitarTypeProvider = GuitarTypeProvider();
  Future<List<GuitarType>>? _guitarTypesFuture;

  @override
  void initState() {
    super.initState();
    _guitarTypesFuture = _guitarTypeProvider.get();
  }

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
        setState(() {
          _guitarTypesFuture = _guitarTypeProvider.get();
        });
        _nameController.clear();
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

  void _deleteGuitarType(int id) async {
    try {
      await _guitarTypeProvider.delete(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guitar Type deleted successfully!')),
      );
      setState(() {
        _guitarTypesFuture = _guitarTypeProvider.get();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete Guitar Type: $e')),
      );
    }
  }

  void _updateGuitarType(GuitarType guitarType) async {
    final TextEditingController _updateController =
        TextEditingController(text: guitarType.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Guitar Type'),
          content: TextField(
            controller: _updateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Guitar Type Name',
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
                    await _guitarTypeProvider.update(
                        guitarType.id!, request.toJson());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Guitar Type updated successfully!')),
                    );
                    setState(() {
                      _guitarTypesFuture = _guitarTypeProvider.get();
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to update Guitar Type: $e')),
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
        title: const Text('Add Guitar Type'),
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
            const SizedBox(height: 24.0),
            Expanded(
              child: FutureBuilder<List<GuitarType>>(
                future: _guitarTypesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No Guitar Types available.'));
                  }
                  final guitarTypes = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 2 / 1,
                    ),
                    itemCount: guitarTypes.length,
                    itemBuilder: (context, index) {
                      final guitarType = guitarTypes[index];
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
                                guitarType.name ?? 'Unnamed Guitar Type',
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
                                    _deleteGuitarType(guitarType.id!),
                              ),
                            ),
                            Positioned(
                              bottom: 4.0,
                              right: 4.0,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _updateGuitarType(guitarType),
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
