import 'package:musicshop_admin/models/Abstract/base_model.dart';

class Product extends BaseModel {
  String? ProductNumber;
  int? ProductImageId;
  int? BrandId;
  String? Model;
  double? Price;
  String? Description;
  DateTime? CreatedAt;
  DateTime? UpdatedAt;

  Product();
}
