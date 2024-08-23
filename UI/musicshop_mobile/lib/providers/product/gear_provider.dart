import 'package:musicshop_admin/models/gear/gear.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class GearProvider extends BaseProvider<Gear> {
  GearProvider() : super('Gear');

  @override
  Gear fromJson(data) {
    return Gear.fromJson(data);
  }
}
