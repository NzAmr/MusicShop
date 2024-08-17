import 'package:musicshop_admin/models/guitar/guitar.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class GuitarProvider extends BaseProvider<Guitar> {
  GuitarProvider() : super("Guitar");
  @override
  Guitar fromJson(data) {
    return Guitar.fromJson(data);
  }
}
