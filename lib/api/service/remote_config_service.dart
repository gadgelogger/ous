// lib/services/remote_config_service.dart

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<bool> checkMaintenance() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(minutes: 5),
      ),
    );

    await _remoteConfig.setDefaults(<String, dynamic>{
      "isUnderMaintenance": false,
    });

    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getBool('isUnderMaintenance');
  }
}
