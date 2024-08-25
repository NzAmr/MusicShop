import 'package:musicshop_admin/models/order/order.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class OrderProvider extends BaseProvider<Order> {
  OrderProvider() : super('Order');

  @override
  Order fromJson(data) {
    return Order.fromJson(data);
  }
}
