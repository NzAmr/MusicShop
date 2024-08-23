import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicshop_admin/pages/amplifier/amplifier_search_page.dart';
import 'package:musicshop_admin/pages/auth/login_page.dart';
import 'package:musicshop_admin/pages/customer/customer_manage_page.dart';
import 'package:musicshop_admin/pages/gear/gear_search_page.dart';
import 'package:musicshop_admin/pages/guitar/guitar_search_page.dart';
import 'package:musicshop_admin/pages/order/orders_search_page.dart';
import 'package:musicshop_admin/pages/studio/studio_reservation_add_page.dart';
import 'package:musicshop_admin/pages/synthesizer/synthesizer_search_page.dart';
import 'package:musicshop_admin/pages/brand/brand_add_page.dart';
import 'package:musicshop_admin/pages/guitar_type/guitar_type_add_page.dart';
import 'package:musicshop_admin/pages/gear_category/gear_category_add_page.dart';
import 'package:musicshop_admin/providers/api_provider.dart';

void main() {
  runApp(
    const ApiProvider(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _darkBlue,
          brightness: Brightness.light,
          primary: _blue,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent,
          onSecondary: Colors.white,
          surface: _darkGray,
          onSurface: _lightGray,
          error: Colors.red,
          onError: Colors.white,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: _darkGray,
          titleTextStyle: const TextStyle(
            color: _lightGray,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: _bodyTextStyle,
          bodyMedium: _bodyTextStyle,
          titleLarge: _bodyTextStyle,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const Color _darkBlue = Color.fromARGB(255, 3, 13, 95);
const Color _blue = Color.fromARGB(255, 75, 89, 194);
const Color _darkGray = Color.fromARGB(255, 39, 35, 35);
const Color _lightGray = Color.fromARGB(255, 228, 226, 226);

// Slightly lighter gray for tile background
const Color _tileBackground = Color.fromARGB(255, 100, 100, 100);

const TextStyle _bodyTextStyle = TextStyle(
  color: _lightGray,
);

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
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
                title: Text('Add Brand',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddBrandPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Add Guitar Type',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddGuitarTypePage()),
                  );
                },
              ),
              ListTile(
                title: Text('Add Gear Category',
                    style: TextStyle(color: colorScheme.onSurface)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddGearCategoryPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome to the Music Shop Admin!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildTile(
                  context,
                  'Guitars',
                  FontAwesomeIcons.guitar,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuitarSearchPage()),
                  ),
                ),
                _buildTile(
                  context,
                  'Amplifiers',
                  FontAwesomeIcons.volumeHigh,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AmplifierSearchPage()),
                  ),
                ),
                _buildTile(
                  context,
                  'Synthesizers',
                  FontAwesomeIcons.keyboard,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SynthesizerSearchPage()),
                  ),
                ),
                _buildTile(
                  context,
                  'Gear',
                  FontAwesomeIcons.box,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GearSearchPage()),
                  ),
                ),
                _buildTile(
                  context,
                  'Studio Reservations',
                  FontAwesomeIcons.calendar,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudioReservationPage()),
                  ),
                ),
                _buildTile(
                  context,
                  'Customers',
                  FontAwesomeIcons.user,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageCustomersPage()),
                  ),
                ),
                _buildTile(
                  context,
                  'Orders',
                  FontAwesomeIcons.gift,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersSearchPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: const Color.fromARGB(255, 0, 0, 0),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 50, color: Theme.of(context).colorScheme.primary),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
