import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ous/constant/urls.dart';
import 'package:ous/infrastructure/bus_api.dart';

final busServiceProvider =
    StateNotifierProvider<BusServiceNotifier, AsyncValue<Map<String, String>>>(
        (ref) {
  return BusServiceNotifier()..fetchBusInfo();
});

class BusServiceNotifier
    extends StateNotifier<AsyncValue<Map<String, String>>> {
  BusServiceNotifier() : super(const AsyncValue.loading());

  Future<void> fetchBusInfo() async {
    state = const AsyncValue.loading();
    try {
      final okayamaStationInfo =
          await BusService().fetchBusApproachCaption(BusUrls.okayamaStation);
      final okayamaRikaUniversityInfo = await BusService()
          .fetchBusApproachCaption(BusUrls.okayamaRikaUniversity);
      final okayamaTenmayaInfo =
          await BusService().fetchBusApproachCaption(BusUrls.okayamaTenmaya);
      final okayamaRikaUniversityEastGateInfo = await BusService()
          .fetchBusApproachCaption(BusUrls.okayamaRikaUniversityEastGate);

      final busInfo = {
        BusUrls.okayamaStation: okayamaStationInfo,
        BusUrls.okayamaRikaUniversity: okayamaRikaUniversityInfo,
        BusUrls.okayamaTenmaya: okayamaTenmayaInfo,
        BusUrls.okayamaRikaUniversityEastGate:
            okayamaRikaUniversityEastGateInfo,
      };

      state = AsyncValue.data(busInfo);
    } on Exception catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
