import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';
import 'package:musicshop_admin/pages/guitar/guitar_details_page.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/guitar/guitar.dart';
import 'package:musicshop_admin/models/brand/brand.dart';

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
  String? _descriptionFilter;
  int? _fretsFilter;
  String? _pickupsFilter;
  String? _pickupConfigurationFilter;

  late GuitarProvider _guitarProvider;
  late BrandProvider _brandProvider;
  late GuitarTypeProvider _typeProvider;

  bool _isFilterMenuOpen = false;

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

    List<Guitar> guitars = await _guitarProvider.get(
      filter: {
        'model': _modelFilter,
        'brandId': _selectedBrand,
        'guitarTypeId': _selectedType,
        'priceFrom': _priceFrom,
        'priceTo': _priceTo,
        'description': _descriptionFilter,
        'frets': _fretsFilter,
        'pickups': _pickupsFilter,
        'pickupConfiguration': _pickupConfigurationFilter,
      },
    );

    setState(() {
      _guitars = guitars;
    });
  }

  List<Guitar> _guitars = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guitar Search'),
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
                    FutureBuilder<List<GuitarType>>(
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
                        return DropdownButton<int>(
                          value: _selectedType,
                          hint: Text('Type'),
                          items: [
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
                      crossAxisCount: 5, // Adjusted to fit 4 cards per row
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
                          color: const Color.fromARGB(
                              255, 36, 26, 26), // Adjusted background color
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 250, // Fixed height for the image
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255), // Placeholder color
                                  image: imageBytes != null
                                      ? DecorationImage(
                                          image: MemoryImage(
                                              Uint8List.fromList(imageBytes)),
                                          fit: BoxFit
                                              .contain, // Changed to fit: BoxFit.contain
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
                                      guitar.brand?.name ?? 'Unknown Brand',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(guitar.model ?? 'Unknown Model'),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${guitar.price?.toStringAsFixed(2) ?? 'N/A'}', // Assuming there's a price field
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
                    width: 300,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration:
                                      InputDecoration(labelText: 'Price From'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      _priceFrom = double.tryParse(value);
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
                                      _priceTo = double.tryParse(value);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration:
                                InputDecoration(labelText: 'Description'),
                            onChanged: (value) {
                              setState(() {
                                _descriptionFilter = value;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(labelText: 'Frets'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                _fretsFilter = int.tryParse(value);
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(labelText: 'Pickups'),
                            onChanged: (value) {
                              setState(() {
                                _pickupsFilter = value;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                                labelText: 'Pickup Configuration'),
                            onChanged: (value) {
                              setState(() {
                                _pickupConfigurationFilter = value;
                              });
                            },
                          ),
                          Spacer(),
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
                )
              : Container(),
        ],
      ),
    );
  }
}
