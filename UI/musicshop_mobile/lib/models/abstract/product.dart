import 'package:json_annotation/json_annotation.dart';
import 'package:musicshop_admin/models/brand/brand.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  int? id;

  String? productNumber;

  String? productImage;

  Brand? brand;

  String? model;

  double? price;

  String? description;

  String? type;

  Product();

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
