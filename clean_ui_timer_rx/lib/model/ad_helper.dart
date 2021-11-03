import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      print('android');
      return "ca-app-pub-7683260316645911/8901121675";
    } else if (Platform.isIOS) {
      print('ios');
      return "ca-app-pub-7683260316645911/5930525166";
    } else {
      print('nothing');
      throw UnsupportedError("Unsupported platform");
    }
  }
}
