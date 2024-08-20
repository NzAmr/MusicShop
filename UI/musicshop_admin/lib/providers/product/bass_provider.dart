import 'package:musicshop_admin/models/bass/bass.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class BassProvider extends BaseProvider<Bass> {
  BassProvider() : super('Bass');

  @override
  Bass fromJson(data) {
    return Bass.fromJson(data);
  }
}
