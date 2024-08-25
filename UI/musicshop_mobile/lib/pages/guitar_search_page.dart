import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/guitar_type/guitar_type.dart';
import 'package:musicshop_mobile/pages/guitar_details_page.dart';
import 'package:musicshop_mobile/providers/product/brand_provider.dart';
import 'package:musicshop_mobile/providers/product/guitar_provider.dart';
import 'package:musicshop_mobile/providers/product/guitar_type_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_mobile/models/guitar/guitar.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';

class GuitarSearchPage extends StatefulWidget {
  @override
  _GuitarSearchPageState createState() => _GuitarSearchPageState();
}

class _GuitarSearchPageState extends State<GuitarSearchPage> {
  int? _selectedBrand;
  int? _selectedType;
  String _modelFilter = '';
  double? _priceFrom;
  double? _priceTo;
  int? _fretsFilter;
  String? _pickupsFilter;
  String? _pickupConfigurationFilter;

  late GuitarProvider _guitarProvider;
  late BrandProvider _brandProvider;
  late GuitarTypeProvider _typeProvider;

  List<Guitar> _guitars = [];

  @override
  void initState() {
    super.initState();
    _guitarProvider = Provider.of<GuitarProvider>(context, listen: false);
    _brandProvider = Provider.of<BrandProvider>(context, listen: false);
    _typeProvider = Provider.of<GuitarTypeProvider>(context, listen: false);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _search();
  }

  Future<void> _search() async {
    setState(() {
      _guitars = [];
    });

    try {
      List<Guitar> guitars = await _guitarProvider.get(
        filter: {
          'model': _modelFilter,
          'brandId': _selectedBrand,
          'guitarTypeId': _selectedType,
          'priceFrom': _priceFrom,
          'priceTo': _priceTo,
          'frets': _fretsFilter,
          'pickups': _pickupsFilter,
          'pickupConfiguration': _pickupConfigurationFilter,
        },
      );

      setState(() {
        _guitars = guitars;
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guitar Search'),
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
                                labelText: 'Frets',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _fretsFilter = int.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Pickups',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _pickupsFilter = value;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Pickup Configuration',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _pickupConfigurationFilter = value;
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FutureBuilder<List<Brand>>(
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FutureBuilder<List<GuitarType>>(
                      future: _typeProvider.get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return Text('No types available');
                        }

                        List<GuitarType> types = snapshot.data!;
                        return DropdownButtonFormField<int>(
                          value: _selectedType,
                          decoration: InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text('All Types'),
                            ),
                            ...types.map((type) {
                              return DropdownMenuItem(
                                value: type.id,
                                child: Text(type.name ?? ''),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                            _search();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: _guitars.length,
                itemBuilder: (context, index) {
                  final guitar = _guitars[index];
                  final imageBytes = guitar.productImage != null
                      ? base64Decode(guitar.productImage!)
                      : null;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuitarDetailsPage(
                            guitar: guitar,
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
                                  guitar.model ?? 'No Model',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  guitar.brand?.name ?? 'No Brand',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  '${guitar.price} \$',
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
                            labelText: 'Frets',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _fretsFilter = int.tryParse(value);
                            });
                          },
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Pickups',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _pickupsFilter = value;
                            });
                          },
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Pickup Configuration',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _pickupConfigurationFilter = value;
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
        child: Icon(Icons.filter_list),
      ),
    );
  }
}
