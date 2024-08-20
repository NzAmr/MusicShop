import 'package:musicshop_admin/models/gear_category/gear_category.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class GearCategoryProvider extends BaseProvider<GearCategory> {
  GearCategoryProvider() : super('GearCategory');

  @override
  GearCategory fromJson(data) {
    return GearCategory.fromJson(data);
  }
}
