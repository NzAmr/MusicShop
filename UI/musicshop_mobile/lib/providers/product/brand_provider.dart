import 'package:musicshop_mobile/models/brand/brand.dart';
import 'package:musicshop_mobile/providers/base/base_provider.dart';

class BrandProvider extends BaseProvider<Brand> {
  BrandProvider() : super('Brand');

  @override
  Brand fromJson(data) {
    return Brand.fromJson(data);
  }
}
