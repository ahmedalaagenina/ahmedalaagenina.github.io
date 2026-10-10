import 'package:url_launcher/url_launcher_string.dart';

import '../data/models.dart';
import 'web/browser.dart';

/// Opens URLs and contact intents. No UI lives here: picking a phone number
/// is a widget concern (see `PhonePicker`).
abstract final class Launcher {
  /// Web links always open in a new tab so the portfolio stays open.
  static Future<void> open(String url) => launchUrlString(
    url,
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );

  static Future<void> email(String address) =>
      launchUrlString('mailto:$address', webOnlyWindowName: '_self');

  static Future<void> call(Phone phone) =>
      launchUrlString('tel:${phone.e164}', webOnlyWindowName: '_self');

  static Future<void> whatsApp(Phone phone) =>
      open('https://wa.me/${phone.e164.replaceAll('+', '')}');

  /// Downloads the CV with a readable file name; falls back to opening it.
  static Future<void> downloadCv(Identity identity) async {
    if (downloadFile(identity.cvPath, identity.cvFileName)) return;
    await open(identity.cvPath);
  }
}
