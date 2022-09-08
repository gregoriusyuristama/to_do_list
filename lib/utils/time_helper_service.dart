import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/services.dart';

class TimeHelperService {
  TimeHelperService() {
    setup();
  }

  void setup() async {
    tz.initializeTimeZones();
    final timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(
      tz.getLocation(
        timezone,
      ),
    );
  }

  Future<tz.TZDateTime> getTimeNow() async {
    return tz.TZDateTime.now(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
  }
}
