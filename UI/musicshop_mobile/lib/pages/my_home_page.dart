import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/pages/account_details_parge.dart';
import 'package:musicshop_mobile/pages/amplifier_search_page.dart';
import 'package:musicshop_mobile/pages/bass_search_page.dart';
import 'package:musicshop_mobile/pages/gear_search_page.dart';
import 'package:musicshop_mobile/pages/guitar_search_page.dart';
import 'package:musicshop_mobile/pages/login_page.dart';
import 'package:musicshop_mobile/pages/order_search_page.dart';
import 'package:musicshop_mobile/pages/studio_reservation_page.dart';
import 'package:musicshop_mobile/pages/synthesizer_search_page.dart';
import 'package:musicshop_mobile/pages/bass_details_page.dart';
import 'package:musicshop_mobile/pages/guitar_details_page.dart';
import 'package:musicshop_mobile/pages/amplifier_details_page.dart';
import 'package:musicshop_mobile/pages/synthesizer_details_page.dart';
import 'package:musicshop_mobile/pages/gear_details_page.dart';
import 'package:musicshop_mobile/providers/customer/customer_provider.dart';
import 'package:musicshop_mobile/providers/product/amplifier_provider.dart';
import 'package:musicshop_mobile/providers/product/bass_provider.dart';
import 'package:musicshop_mobile/providers/product/gear_provider.dart';
import 'package:musicshop_mobile/providers/product/guitar_provider.dart';
import 'package:musicshop_mobile/providers/product/product_provider.dart';
import 'package:musicshop_mobile/providers/product/synthesizer_provider.dart';

import 'package:musicshop_mobile/utils/util.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    return await productProvider.getUserRecommendations();
  }

  Future<void> _showLogoutConfirmation() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      _logout();
    }
  }

  void _logout() {
    Authorization.username = null;
    Authorization.password = null;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _navigateToDetailsPage(Product product) async {
    switch (product.type) {
      case 'Guitar':
        final guitarProvider =
            Provider.of<GuitarProvider>(context, listen: false);
        final guitar = await guitarProvider.getById(product.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuitarDetailsPage(guitar: guitar),
          ),
        );
        break;
      case 'Bass':
        final bassProvider = Provider.of<BassProvider>(context, listen: false);
        final bass = await bassProvider.getById(product.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BassDetailsPage(bass: bass),
          ),
        );
        break;
      case 'Amplifier':
        final amplifierProvider =
            Provider.of<AmplifierProvider>(context, listen: false);
        final amplifier = await amplifierProvider.getById(product.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AmplifierDetailsPage(amplifier: amplifier),
          ),
        );
        break;
      case 'Synthesizer':
        final synthesizerProvider =
            Provider.of<SynthesizerProvider>(context, listen: false);
        final synthesizer = await synthesizerProvider.getById(product.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                SynthesizerDetailsPage(synthesizer: synthesizer),
          ),
        );
        break;
      case 'Gear':
        final gearProvider = Provider.of<GearProvider>(context, listen: false);
        final gear = await gearProvider.getById(product.id!);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GearDetailsPage(gear: gear),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown product type: ${product.type}')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 12, 9, 163),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: _showLogoutConfirmation,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: colorScheme.surface,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading:
                    Icon(FontAwesomeIcons.guitar, color: colorScheme.onSurface),
                title: Text('Guitars',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuitarSearchPage()),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(FontAwesomeIcons.guitar, color: colorScheme.onSurface),
                title: Text('Basses',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BassSearchPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.keyboard,
                    color: colorScheme.onSurface),
                title: Text('Synthesizers',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SynthesizerSearchPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.volumeHigh,
                    color: colorScheme.onSurface),
                title: Text('Amplifiers',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AmplifierSearchPage()),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(FontAwesomeIcons.box, color: colorScheme.onSurface),
                title: Text('Gear',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GearSearchPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.calendar,
                    color: colorScheme.onSurface),
                title: Text('Studio Reservations',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudioReservationPage()),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(FontAwesomeIcons.gift, color: colorScheme.onSurface),
                title: Text('Orders',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersSearchPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.userCog,
                    color: colorScheme.onSurface),
                title: Text('Account Details',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () async {
                  final customerProvider =
                      Provider.of<CustomerProvider>(context, listen: false);
                  try {
                    final customer =
                        await customerProvider.getCustomerByLogin();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AccountDetailsPage(customer: customer),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Failed to load account details: $e')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recommendations available'));
          }

          List<Product> products = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final imageBytes = product.productImage != null
                    ? base64Decode(product.productImage!)
                    : null;

                return GestureDetector(
                  onTap: () => _navigateToDetailsPage(product),
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
                                product.model ?? 'No Model',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                product.brand?.name ?? 'No Brand',
                                style: TextStyle(
                                    fontSize: 14, fontStyle: FontStyle.italic),
                              ),
                              Text(
                                '${product.price ?? 'N/A'} \$',
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
          );
        },
      ),
    );
  }
}
