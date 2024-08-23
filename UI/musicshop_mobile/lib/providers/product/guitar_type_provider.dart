import 'package:musicshop_admin/models/guitar_type/guitar_type.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class GuitarTypeProvider extends BaseProvider<GuitarType> {
  GuitarTypeProvider() : super('GuitarType');

  @override
  GuitarType fromJson(data) {
    return GuitarType.fromJson(data);
  }
}
