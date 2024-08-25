import 'dart:convert';
import 'dart:io';
import 'package:musicshop_mobile/models/abstract/product.dart';
import 'package:musicshop_mobile/providers/base/base_provider.dart';

class ProductProvider extends BaseProvider<Product> {
  ProductProvider() : super("Product");

  @override
  Product fromJson(data) {
    return Product.fromJson(data);
  }

  Future<List<Product>> getUserRecommendations() async {
    var url = "${baseUrl}Product/recommendations";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http!.get(uri, headers: headers);

      if (isValidResponseCode(response)) {
        List<dynamic> dataList = jsonDecode(response.body);

        List<Product> recommendations = dataList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();

        return recommendations;
      } else {
        throw Exception(
            "Failed to fetch recommendations: ${response.statusCode}");
      }
    } on SocketException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on HandshakeException catch (e) {
      throw Exception("Handshake error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error: ${e.toString()}");
    }
  }
}
