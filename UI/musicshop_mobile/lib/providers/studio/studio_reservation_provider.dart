import 'package:musicshop_admin/models/studio/studio_reservation.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class StudioReservationProvider extends BaseProvider<StudioReservation> {
  StudioReservationProvider() : super('StudioReservation');

  @override
  StudioReservation fromJson(data) {
    return StudioReservation.fromJson(data);
  }
}
