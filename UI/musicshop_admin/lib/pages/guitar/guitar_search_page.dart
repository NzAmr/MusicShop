import 'package:flutter/material.dart';
import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';
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

  late GuitarProvider _guitarProvider;
  late BrandProvider _brandProvider;
  late GuitarTypeProvider _typeProvider;

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
      appBar: AppBar(title: Text('Guitar Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Filter by Model'),
              onChanged: (value) {
                setState(() {
                  _modelFilter = value;
                });
              },
            ),
            SizedBox(height: 16),
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
                  hint: Text('Select Brand (or choose None)'),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Any'),
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
                  },
                );
              },
            ),
            SizedBox(height: 16),
            FutureBuilder<List<GuitarType>>(
              future: _typeProvider.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return Text('No types available');
                }

                List<GuitarType> types = snapshot.data!;
                return DropdownButton<int>(
                  value: _selectedType,
                  hint: Text('Select Type (or choose None)'),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Any'),
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
                  },
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _search,
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 1200,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Model')),
                      DataColumn(label: Text('Brand')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Details')),
                    ],
                    rows: _guitars.map((guitar) {
                      return DataRow(cells: [
                        DataCell(Text(guitar.model ?? 'Error Loading')),
                        DataCell(Text(guitar.brand?.name ?? 'Error Loading')),
                        DataCell(
                          Text(guitar.guitarType?.name ?? 'Error Loading'),
                        ),
                        DataCell(Text(
                            '\$${guitar.price?.toStringAsFixed(2) ?? 'N/A'}')),
                        DataCell(TextButton(
                          child: Text('Details'),
                          onPressed: () {},
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
