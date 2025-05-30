import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/synthesizer/synthesizer.dart';
import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/pages/synthesizer/synthesizer_add_page.dart';
import 'package:musicshop_admin/pages/synthesizer/synthesizer_details_page.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/synthesizer_provider.dart';

class SynthesizerSearchPage extends StatefulWidget {
  @override
  _SynthesizerSearchPageState createState() => _SynthesizerSearchPageState();
}

class _SynthesizerSearchPageState extends State<SynthesizerSearchPage> {
  int? _selectedBrand;
  String _modelFilter = '';
  double? _priceFrom;
  double? _priceTo;
  int? _keyboardSizeFilter;
  bool? _weighedKeysFilter;
  int? _polyphonyFilter;
  int? _numberOfPresetsFilter;

  late SynthesizerProvider _synthesizerProvider;
  late BrandProvider _brandProvider;

  bool _isFilterMenuOpen = false;
  List<Synthesizer> _synthesizers = [];

  @override
  void initState() {
    super.initState();
    _synthesizerProvider =
        Provider.of<SynthesizerProvider>(context, listen: false);
    _brandProvider = Provider.of<BrandProvider>(context, listen: false);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _search();
  }

  Future<void> _search() async {
    setState(() {
      _synthesizers = [];
    });

    Map<String, dynamic> filters = {
      'model': _modelFilter,
      'brandId': _selectedBrand,
      'keyboardSize': _keyboardSizeFilter,
      'weighedKeys': _weighedKeysFilter,
      'polyphony': _polyphonyFilter,
      'numberOfPresets': _numberOfPresetsFilter,
    };

    if (_priceFrom != null) {
      filters['priceFrom'] = _priceFrom;
    }
    if (_priceTo != null) {
      filters['priceTo'] = _priceTo;
    }

    List<Synthesizer> synthesizers = await _synthesizerProvider.get(
      filter: filters,
    );

    setState(() {
      _synthesizers = synthesizers;
    });
  }

  Future<void> _deleteSynthesizer(int synthesizerId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this synthesizer?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _synthesizerProvider.delete(synthesizerId);
      setState(() {
        _synthesizers
            .removeWhere((synthesizer) => synthesizer.id == synthesizerId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Synthesizer Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _isFilterMenuOpen = !_isFilterMenuOpen;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Filter by Model',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _modelFilter = value;
                          });
                          _search();
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    FutureBuilder<List<Brand>>(
                      future: _brandProvider.get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return Text('No brands available');
                        }

                        List<Brand> brands = snapshot.data!;
                        return DropdownButton<int>(
                          value: _selectedBrand,
                          hint: Text('Brand'),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text('All Brands'),
                            ),
                            ...brands.map((brand) {
                              return DropdownMenuItem(
                                value: brand.id,
                                child: Text(brand.name ?? ''),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedBrand = value;
                            });
                            _search();
                          },
                        );
                      },
                    ),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {
                        setState(() {
                          _isFilterMenuOpen = !_isFilterMenuOpen;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: _synthesizers.length,
                    itemBuilder: (context, index) {
                      final synthesizer = _synthesizers[index];
                      final imageBytes = synthesizer.productImage != null
                          ? base64Decode(synthesizer.productImage!)
                          : null;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SynthesizerDetailsPage(
                                synthesizer: synthesizer,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 36, 26, 26),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      image: imageBytes != null
                                          ? DecorationImage(
                                              image: MemoryImage(
                                                  Uint8List.fromList(
                                                      imageBytes)),
                                              fit: BoxFit.contain,
                                            )
                                          : null,
                                    ),
                                    child: imageBytes == null
                                        ? Center(child: Text('No Image'))
                                        : null,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deleteSynthesizer(synthesizer.id!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      synthesizer.brand?.name ??
                                          'Unknown Brand',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(synthesizer.model ?? 'Unknown Model'),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${synthesizer.price?.toStringAsFixed(2) ?? 'N/A'}',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          _isFilterMenuOpen
              ? Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        labelText: 'Price From'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _priceFrom = value.isNotEmpty
                                            ? double.tryParse(value)
                                            : null;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    decoration:
                                        InputDecoration(labelText: 'Price To'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        _priceTo = value.isNotEmpty
                                            ? double.tryParse(value)
                                            : null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration:
                                  InputDecoration(labelText: 'Keyboard Size'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _keyboardSizeFilter = int.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            SwitchListTile(
                              title: Text('Weighed Keys'),
                              value: _weighedKeysFilter ?? false,
                              onChanged: (value) {
                                setState(() {
                                  _weighedKeysFilter = value;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration:
                                  InputDecoration(labelText: 'Polyphony'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _polyphonyFilter = int.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: 'Number of Presets'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _numberOfPresetsFilter = int.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _search();
                                    setState(() {
                                      _isFilterMenuOpen = false;
                                    });
                                  },
                                  child: Text('Add Filters'),
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isFilterMenuOpen = false;
                                      _priceFrom = null;
                                      _priceTo = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSynthesizerPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: CupertinoColors.lightBackgroundGray,
      ),
    );
  }
}
