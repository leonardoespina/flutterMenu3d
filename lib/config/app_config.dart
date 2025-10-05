import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'https://default-api.com';
  }

  static String get uploadsBaseUrl {
    return dotenv.env['UPLOADS_BASE_URL'] ?? 'https://default-uploads.com/';
  }
}
