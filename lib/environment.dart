import 'dart:convert';

import 'package:flutter/services.dart';



class Env {

  String tag = 'env';

  static Map<String, dynamic>? _env;
  static String? _envType;

  static Future<void> initEnv() async {
    _env = json.decode(await rootBundle.loadString('.env'));
    _envType = _env ? ['environment'];
  }

  /// Get API Url.
  ///
  ///
  static String get newsEndpoint => _env ? [_envType]['news_endpoint'];

  /// Get Google  Map Api.
  ///
  ///
  static String get googleMapApi => _env ? [_envType]['google_map_api'];

  /// Get Google  x_rapidapi_key.
  ///
  ///
  static String get x_rapidapi_key => _env ? [_envType]['x-rapidapi-key'];

  /// Get x_rapidapi_host.
  ///
  ///
  static String get x_rapidapi_host => _env ? [_envType]['x-rapidapi-host'];

}