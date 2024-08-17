import 'package:flutter/material.dart';
import 'package:musicshop_admin/pages/brand/brand_add_page.dart';
import 'package:musicshop_admin/pages/guitar/guitar_add_page.dart';
import 'package:musicshop_admin/pages/guitar/guitar_search_page.dart';
import 'package:musicshop_admin/pages/guitar_type/guitar_type_add_page.dart';
import 'package:musicshop_admin/providers/api_provider.dart';

void main() {
  runApp(
    ApiProvider(
      child: const MyApp(),
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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 3, 13, 95)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Add Brand'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBrandPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Add Guitar Type'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddGuitarTypePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Add Guitar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddGuitarPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Search Guitars'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuitarSearchPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Music Shop Admin!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
