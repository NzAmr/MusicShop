import 'dart:convert';
import 'dart:io';
import 'package:musicshop_mobile/models/studio/studio_reservation.dart';
import 'package:musicshop_mobile/models/studio/studio_reservation_insert_request.dart';
import 'package:musicshop_mobile/providers/base/base_provider.dart';

class StudioReservationProvider extends BaseProvider<StudioReservation> {
  StudioReservationProvider() : super('StudioReservation') {}

  @override
  StudioReservation fromJson(data) {
    return StudioReservation.fromJson(data);
  }

  Future<StudioReservation> createCustomerReservation(
      StudioReservationInsertRequest request) async {
    var url = "${baseUrl}StudioReservation/customer-reservation";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request.toJson());

    if (http == null) {
      throw Exception("Http client is not initialized.");
    }

    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponseCode(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Failed to create reservation: ${response.statusCode}");
    }
  }

  Future<List<StudioReservation>> getReservationsFromRequest() async {
    var url = "${baseUrl}StudioReservation/get-customer-reservations";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    if (http == null) {
      throw Exception("Http client is not initialized.");
    }

    try {
      var response = await http!.get(uri, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List<dynamic>;

        List<StudioReservation> reservations = data
            .map((jsonItem) => StudioReservation.fromJson(jsonItem))
            .toList();

        return reservations;
      } else {
        throw Exception(
            "Failed to get reservations: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } on SocketException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on HandshakeException catch (e) {
      throw Exception("Handshake error: ${e.message}");
    } catch (e) {
      throw Exception("An error occurred: ${e.toString()}");
    }
  }
}
