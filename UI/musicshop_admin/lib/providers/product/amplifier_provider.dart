import 'package:musicshop_admin/models/amplifier/amplifier.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class AmplifierProvider extends BaseProvider<Amplifier> {
  AmplifierProvider() : super('Amplifier');

  @override
  Amplifier fromJson(data) {
    return Amplifier.fromJson(data);
  }
}
