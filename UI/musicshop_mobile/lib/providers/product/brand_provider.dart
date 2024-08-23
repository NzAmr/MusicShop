import 'package:musicshop_admin/models/brand/brand.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class BrandProvider extends BaseProvider<Brand> {
  BrandProvider() : super('Brand');

  @override
  Brand fromJson(data) {
    return Brand.fromJson(data);
  }
}
