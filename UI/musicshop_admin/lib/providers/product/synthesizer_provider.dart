import 'package:musicshop_admin/models/synthesizer/synthesizer.dart';
import 'package:musicshop_admin/providers/base/base_provider.dart';

class SynthesizerProvider extends BaseProvider<Synthesizer> {
  SynthesizerProvider() : super('Synthesizer');

  @override
  Synthesizer fromJson(data) {
    return Synthesizer.fromJson(data);
  }
}
