import 'package:flutter/material.dart';
import 'package:musicshop_admin/providers/product/amplifier_provider.dart';
import 'package:musicshop_admin/providers/product/brand_provider.dart';
import 'package:musicshop_admin/providers/product/gear_category_provider.dart';
import 'package:musicshop_admin/providers/product/gear_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_provider.dart';
import 'package:musicshop_admin/providers/product/guitar_type_provider.dart';
import 'package:musicshop_admin/providers/studio/studio_reservation_provider.dart';
import 'package:provider/provider.dart';

class ApiProvider extends StatelessWidget {
  final Widget? child;

  const ApiProvider({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => GuitarTypeProvider()),
        ChangeNotifierProvider(create: (_) => GuitarProvider()),
        ChangeNotifierProvider(create: (_) => GearCategoryProvider()),
        ChangeNotifierProvider(create: (_) => GearProvider()),
        ChangeNotifierProvider(create: (_) => AmplifierProvider()),
        ChangeNotifierProvider(create: (_) => StudioReservationProvider()),
      ],
      child: child,
    );
  }
}
