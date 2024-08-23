import 'package:musicshop_admin/models/customer/customer.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class CustomerProvider extends BaseProvider<Customer> {
  CustomerProvider() : super('Customer');

  @override
  Customer fromJson(data) {
    return Customer.fromJson(data);
  }
}
