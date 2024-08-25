import 'package:musicshop_mobile/models/guitar/guitar.dart';
import 'package:musicshop_mobile/providers/base/base_provider.dart';

class GuitarProvider extends BaseProvider<Guitar> {
  GuitarProvider() : super("Guitar");
  @override
  Guitar fromJson(data) {
    return Guitar.fromJson(data);
  }
}
