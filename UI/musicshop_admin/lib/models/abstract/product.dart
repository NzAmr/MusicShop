import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/Abstract/base_model.dart';

part 'product.g.dart';

@JsonSerializable()
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

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
