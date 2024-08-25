import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/synthesizer/synthesizer.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';
import 'package:musicshop_mobile/pages/synthesizer_details_page.dart';
import 'package:musicshop_mobile/providers/product/brand_provider.dart';
import 'package:musicshop_mobile/providers/product/synthesizer_provider.dart';
import 'package:provider/provider.dart';

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

    try {
      List<Synthesizer> synthesizers = await _synthesizerProvider.get(
        filter: {
          'model': _modelFilter,
          'brandId': _selectedBrand,
          'priceFrom': _priceFrom,
          'priceTo': _priceTo,
          'keyboardSize': _keyboardSizeFilter,
          'weighedKeys': _weighedKeysFilter,
          'polyphony': _polyphonyFilter,
          'numberOfPresets': _numberOfPresetsFilter,
        },
      );

      setState(() {
        _synthesizers = synthesizers;
      });
    } catch (e) {
      print('Error occurred: $e');
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Additional Filters'),
                    content: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Price From',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _priceFrom = double.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Price To',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _priceTo = double.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Keyboard Size',
                                border: OutlineInputBorder(),
                              ),
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
                              decoration: InputDecoration(
                                labelText: 'Polyphony',
                                border: OutlineInputBorder(),
                              ),
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
                                labelText: 'Number of Presets',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _numberOfPresetsFilter = int.tryParse(value);
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    actions: [
                      TextButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Apply Filters'),
                        onPressed: () {
                          setState(() {
                            _search();
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Filter by Model',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _modelFilter = value;
                  });
                  _search();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: FutureBuilder<List<Brand>>(
                future: _brandProvider.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No brands available');
                  }

                  List<Brand> brands = snapshot.data!;
                  return DropdownButtonFormField<int>(
                    value: _selectedBrand,
                    decoration: InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
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
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
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
                      Navigator.of(context).push(
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
                          Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              image: imageBytes != null
                                  ? DecorationImage(
                                      image: MemoryImage(
                                          Uint8List.fromList(imageBytes)),
                                      fit: BoxFit.contain,
                                    )
                                  : null,
                            ),
                            child: imageBytes == null
                                ? Center(child: Text('No Image'))
                                : null,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  synthesizer.model ?? 'No Model',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  synthesizer.brand?.name ?? 'No Brand',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  '${synthesizer.price} \$',
                                  style: TextStyle(fontSize: 14),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Additional Filters'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Price From',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _priceFrom = double.tryParse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Price To',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _priceTo = double.tryParse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Keyboard Size',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _keyboardSizeFilter = int.tryParse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
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
                          decoration: InputDecoration(
                            labelText: 'Polyphony',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _polyphonyFilter = int.tryParse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Number of Presets',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _numberOfPresetsFilter = int.tryParse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    );
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Apply Filters'),
                    onPressed: () {
                      setState(() {
                        _search();
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }
}
