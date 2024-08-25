import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicshop_mobile/pages/gear_details_page.dart';
import 'package:provider/provider.dart';
import 'package:musicshop_mobile/models/gear/gear.dart';
import 'package:musicshop_mobile/models/brand/brand.dart';
import 'package:musicshop_mobile/models/gear_category/gear_category.dart';
import 'package:musicshop_mobile/providers/product/brand_provider.dart';
import 'package:musicshop_mobile/providers/product/gear_category_provider.dart';
import 'package:musicshop_mobile/providers/product/gear_provider.dart';

class GearSearchPage extends StatefulWidget {
  @override
  _GearSearchPageState createState() => _GearSearchPageState();
}

class _GearSearchPageState extends State<GearSearchPage> {
  int? _selectedBrand;
  String _modelFilter = '';
  double? _priceFrom;
  double? _priceTo;
  int? _gearCategoryFilter;

  late GearProvider _gearProvider;
  late BrandProvider _brandProvider;
  late GearCategoryProvider _gearCategoryProvider;

  List<Gear> _gears = [];

  @override
  void initState() {
    super.initState();
    _gearProvider = Provider.of<GearProvider>(context, listen: false);
    _brandProvider = Provider.of<BrandProvider>(context, listen: false);
    _gearCategoryProvider =
        Provider.of<GearCategoryProvider>(context, listen: false);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _search();
  }

  Future<void> _search() async {
    setState(() {
      _gears = [];
    });

    Map<String, dynamic> filters = {
      'model': _modelFilter,
      'brandId': _selectedBrand,
      'gearCategoryId': _gearCategoryFilter,
    };

    if (_priceFrom != null) {
      filters['priceFrom'] = _priceFrom;
    }
    if (_priceTo != null) {
      filters['priceTo'] = _priceTo;
    }

    List<Gear> gears = await _gearProvider.get(filter: filters);

    setState(() {
      _gears = gears;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gear Search'),
        actions: [],
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
                    child: FutureBuilder<List<GearCategory>>(
                      future: _gearCategoryProvider.get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return Text('No categories available');
                        }

                        List<GearCategory> categories = snapshot.data!;
                        return DropdownButtonFormField<int>(
                          value: _gearCategoryFilter,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: null,
                              child: Text('All Categories'),
                            ),
                            ...categories.map((category) {
                              return DropdownMenuItem(
                                value: category.id,
                                child: Text(category.name ?? ''),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _gearCategoryFilter = value;
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
                itemCount: _gears.length,
                itemBuilder: (context, index) {
                  final gear = _gears[index];
                  final imageBytes = gear.productImage != null
                      ? base64Decode(gear.productImage!)
                      : null;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GearDetailsPage(
                            gear: gear,
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
                                  gear.model ?? 'No Model',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  gear.brand?.name ?? 'No Brand',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  '${gear.price} \$',
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
