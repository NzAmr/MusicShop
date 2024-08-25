import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/models/amplifier/amplifier.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';
import 'package:musicshop_mobile/pages/amplifier_details_page.dart';
import 'package:musicshop_mobile/providers/product/amplifier_provider.dart';
import 'package:musicshop_mobile/providers/product/brand_provider.dart';
import 'package:provider/provider.dart';

class AmplifierSearchPage extends StatefulWidget {
  @override
  _AmplifierSearchPageState createState() => _AmplifierSearchPageState();
}

class _AmplifierSearchPageState extends State<AmplifierSearchPage> {
  int? _selectedBrand;
  String _modelFilter = '';
  double? _priceFrom;
  double? _priceTo;
  int? _voltageFilter;
  int? _powerRatingFilter;
  bool? _headphoneJackFilter;
  bool? _usbJackFilter;
  int? _numberOfPresetsFilter;

  late AmplifierProvider _amplifierProvider;
  late BrandProvider _brandProvider;

  bool _isFilterMenuOpen = false;
  List<Amplifier> _amplifiers = [];

  @override
  void initState() {
    super.initState();
    _amplifierProvider = Provider.of<AmplifierProvider>(context, listen: false);
    _brandProvider = Provider.of<BrandProvider>(context, listen: false);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _search();
  }

  Future<void> _search() async {
    setState(() {
      _amplifiers = [];
    });

    List<Amplifier> amplifiers = await _amplifierProvider.get(
      filter: {
        'model': _modelFilter,
        'brandId': _selectedBrand,
        'priceFrom': _priceFrom,
        'priceTo': _priceTo,
        'voltage': _voltageFilter,
        'powerRating': _powerRatingFilter,
        'headphoneJack': _headphoneJackFilter,
        'usbJack': _usbJackFilter,
        'numberOfPresets': _numberOfPresetsFilter,
      },
    );

    setState(() {
      _amplifiers = amplifiers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amplifier Search'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
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
                FutureBuilder<List<Brand>>(
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
                    return DropdownButton<int>(
                      value: _selectedBrand,
                      hint: Text('Select Brand'),
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
                SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: _amplifiers.length,
                    itemBuilder: (context, index) {
                      final amplifier = _amplifiers[index];
                      final imageBytes = amplifier.productImage != null
                          ? base64Decode(amplifier.productImage!)
                          : null;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AmplifierDetailsPage(
                                amplifier: amplifier,
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
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      amplifier.brand?.name ?? 'Unknown Brand',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 4),
                                    Text(amplifier.model ?? 'Unknown Model'),
                                    SizedBox(height: 4),
                                    Text(
                                      '\$${amplifier.price?.toStringAsFixed(2) ?? 'N/A'}',
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
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.5,
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
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _priceFrom = value.isNotEmpty
                                      ? double.tryParse(value)
                                      : null;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Price To',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _priceTo = value.isNotEmpty
                                      ? double.tryParse(value)
                                      : null;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Voltage',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _voltageFilter = int.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Power Rating',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _powerRatingFilter = int.tryParse(value);
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            SwitchListTile(
                              title: Text('Headphone Jack'),
                              value: _headphoneJackFilter ?? false,
                              onChanged: (value) {
                                setState(() {
                                  _headphoneJackFilter = value;
                                });
                              },
                            ),
                            SwitchListTile(
                              title: Text('USB Jack'),
                              value: _usbJackFilter ?? false,
                              onChanged: (value) {
                                setState(() {
                                  _usbJackFilter = value;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Number of Presets',
                              ),
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
                )
              : Container(),
        ],
      ),
    );
  }
}
