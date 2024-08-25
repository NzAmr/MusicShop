import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:musicshop_mobile/models/customer/customer.dart';
import 'package:musicshop_mobile/models/customer/login.dart';
import 'package:musicshop_mobile/providers/base/base_provider.dart';

class CustomerProvider extends BaseProvider<Customer> {
  HttpClient client = HttpClient();
  IOClient? httpClient;

  CustomerProvider() : super('Customer') {
    client.badCertificateCallback = (cert, host, port) => true;
    httpClient = IOClient(client);
  }

  @override
  Customer fromJson(data) {
    return Customer.fromJson(data);
  }

  Future<Customer> customerLogin(Login request) async {
    var url = "${baseUrl}Customer/login";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request.toJson());

    try {
      var response =
          await httpClient!.post(uri, headers: headers, body: jsonRequest);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Customer.fromJson(data);
      } else {
        throw Exception(
            "Failed to login: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } on SocketException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on HandshakeException catch (e) {
      throw Exception("Handshake error: ${e.message}");
    } catch (e) {
      throw Exception("Wrong username or password, please try again!");
    }
  }

  Future<Customer> getCustomerByLogin() async {
    var url = "${baseUrl}Customer/get-customer-login";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await httpClient!.post(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Customer.fromJson(data);
      } else {
        throw Exception(
            "Failed to login: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } on SocketException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on HandshakeException catch (e) {
      throw Exception("Handshake error: ${e.message}");
    } catch (e) {
      throw Exception("Wrong username or password, please try again!");
    }
  }
}
