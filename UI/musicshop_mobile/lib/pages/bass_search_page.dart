import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/bass/bass.dart';
import 'package:musicshop_mobile/models/guitar_type/guitar_type.dart';
import 'package:musicshop_mobile/pages/bass_details_page.dart';
import 'package:musicshop_mobile/providers/product/brand_provider.dart';
import 'package:musicshop_mobile/providers/product/bass_provider.dart';
import 'package:musicshop_mobile/providers/product/guitar_type_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';

class BassSearchPage extends StatefulWidget {
  @override
  _BassSearchPageState createState() => _BassSearchPageState();
}

class _BassSearchPageState extends State<BassSearchPage> {
  int? _selectedBrand;
  int? _selectedType;
  String _modelFilter = '';
  double? _priceFrom;
  double? _priceTo;
  int? _fretsFilter;
  String? _pickupsFilter;
  String? _productNumberFilter;

  late BassProvider _bassProvider;
  late BrandProvider _brandProvider;
  late GuitarTypeProvider _typeProvider;

  bool _isFilterMenuOpen = false;
  List<Bass> _basses = [];

  @override
  void initState() {
    super.initState();
    _bassProvider = Provider.of<BassProvider>(context, listen: false);
    _brandProvider = Provider.of<BrandProvider>(context, listen: false);
    _typeProvider = Provider.of<GuitarTypeProvider>(context, listen: false);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _search();
  }

  Future<void> _search() async {
    setState(() {
      _basses = [];
    });

    List<Bass> basses = await _bassProvider.get(
      filter: {
        'model': _modelFilter,
        'brandId': _selectedBrand,
        'guitarTypeId': _selectedType,
        'priceFrom': _priceFrom,
        'priceTo': _priceTo,
        'frets': _fretsFilter,
        'pickups': _pickupsFilter,
        'productNumber': _productNumberFilter,
      },
    );

    setState(() {
      _basses = basses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bass Search'),
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
                SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: _basses.length,
                    itemBuilder: (context, index) {
                      final bass = _basses[index];
                      final imageBytes = bass.productImage != null
                          ? base64Decode(bass.productImage!)
                          : null;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BassDetailsPage(
                                bass: bass,
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
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
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
                                      bass.brand?.name ?? 'Unknown Brand',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(bass.model ?? 'Unknown Model'),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${bass.price?.toStringAsFixed(2) ?? 'N/A'}',
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
              ? Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                  labelText: 'Product Number',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _productNumberFilter = value;
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
                                    child: Text('Apply Filters'),
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
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isFilterMenuOpen = !_isFilterMenuOpen;
          });
        },
        child: Icon(Icons.filter_list),
      ),
    );
  }
}
