import 'dart:async';
import 'package:flutter/services.dart';

class StripeWidget {
  static const MethodChannel _channel =
      const MethodChannel('stripe_widget');

  static Future<String> addSource() async {
    final String token = await _channel.invokeMethod('addSource');
    return token;
  }

  /// set the publishable key that stripe should use
  /// call this once and before you use [addSource]
  static void setPublishableKey(String apiKey) {
    _channel.invokeMethod('setPublishableKey', apiKey);
  }

}
