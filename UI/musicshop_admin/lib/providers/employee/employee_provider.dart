import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musicshop_admin/models/employee/employee.dart';
import 'package:musicshop_admin/models/employee/login.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class EmployeeProvider extends BaseProvider<Employee> {
  EmployeeProvider() : super('Employee');

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }

  Future<Employee> employeeLogin(Login request) async {
    var url = "https://localhost:7234/Employee/login";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    headers['Content-Type'] = 'application/json';

    var body = jsonEncode(request.toJson());

    var response = await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception(
          "Failed to login: ${response.statusCode} ${response.reasonPhrase}");
    }
  }

  Future<Employee> getLoggedInEmployee() async {
    var url = "https://localhost:7234/Employee/get-employee-login";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    print("asdasd");
    headers['Content-Type'] = 'application/json';

    var response = await http.post(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception(
          "Failed to login: ${response.statusCode} ${response.reasonPhrase}");
    }
  }
}
