import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/bass/bass.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';
import 'package:musicshop_admin/pages/bass/bass_add_page.dart';
import 'package:musicshop_admin/pages/bass/bass_details_page.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/bass_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_admin/models/brand/brand.dart';

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

  Future<void> _deleteBass(int bassId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this bass?'),
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
      await _bassProvider.delete(bassId);
      setState(() {
        _basses.removeWhere((bass) => bass.id == bassId);
      });
    }
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
                                        _deleteBass(bass.id!);
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
                              decoration:
                                  InputDecoration(labelText: 'Product Number'),
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
              builder: (context) => AddBassPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: CupertinoColors.lightBackgroundGray,
      ),
    );
  }
}
