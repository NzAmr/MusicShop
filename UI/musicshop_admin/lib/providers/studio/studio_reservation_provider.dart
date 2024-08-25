import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musicshop_admin/models/studio/studio_reservation.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class StudioReservationProvider extends BaseProvider<StudioReservation> {
  StudioReservationProvider() : super('StudioReservation');

  @override
  StudioReservation fromJson(data) {
    return StudioReservation.fromJson(data);
  }

  Future<StudioReservation> markAsCancelled(int id) async {
    var url = "${baseUrl}StudioReservation/mark-as-cancelled/?id=$id";
    print(url);
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<StudioReservation> markAsConfirmed(int id) async {
    var url = "${baseUrl}StudioReservation/mark-as-confirmed/?id=$id";
    print(url);
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
}
