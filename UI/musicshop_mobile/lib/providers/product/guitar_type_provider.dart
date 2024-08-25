import 'package:musicshop_mobile/models/guitar_type/guitar_type.dart';
import 'package:musicshop_mobile/providers/base/base_provider.dart';

class GuitarTypeProvider extends BaseProvider<GuitarType> {
  GuitarTypeProvider() : super('GuitarType');

  @override
  GuitarType fromJson(data) {
    return GuitarType.fromJson(data);
  }
}
