/*
Copyright 2020 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_acpcore/src/acpextension_event.dart';
import 'package:flutter_acpcore/src/acpmobile_logging_level.dart';
import 'package:flutter_acpcore/src/acpmobile_privacy_status.dart';

/// Adobe Experience Platform Core API.
class FlutterACPCore {
  static const MethodChannel _channel = const MethodChannel('flutter_acpcore');

  /// Gets the current Core extension version.
  static Future<String> get extensionVersion => _channel.invokeMethod<String>('extensionVersion').then((value) => value!);

  /// This method sends a generic Analytics action tracking hit with context data.
  static Future<void> trackAction(
    String action, {
    Map<String, String>? data,
  }) =>
      _channel.invokeMethod(
        'track',
        {
          'type': 'action',
          'name': action,
          'data': data ?? {},
        },
      );

  /// This method sends a generic Analytics state tracking hit with context data.
  static Future<void> trackState(
    String state, {
    Map<String, String>? data,
  }) =>
      _channel.invokeMethod(
        'track',
        {
          'type': 'state',
          'name': state,
          'data': data ?? {},
        },
      );

  /// Submits a generic event containing the provided IDFA with event type `generic.identity`.
  static Future<void> setAdvertisingIdentifier(String aid) => _channel.invokeMethod<void>('setAdvertisingIdentifier', aid);

  /// Sets the FCM/APNS token as the push identifier
  static Future<void> setPushIdentifier(String token) => _channel.invokeMethod<void>('setPushIdentifier', token);

  /// Submits a generic PII collection request event with type `generic.pii`.
  ///
  /// @param {Map<String, String>} a map containing the PII data
  static Future<void> collectPii(Map<String, String> data) => _channel.invokeMethod('collectPii', data);

  ///  Called by the extension public API to dispatch an event for other extensions or the internal SDK to consume. Any events dispatched by this call will not be processed until after `start` has been called.
  static Future<bool> dispatchEvent(ACPExtensionEvent event) => _channel.invokeMethod<bool>('dispatchEvent', event.data).then((value) => value!);

  /// You should use this method when the Event being passed is a request and you expect an event in response. Any events dispatched by this call will not be processed until after `start` has been called.
  static Future<ACPExtensionEvent> dispatchEventWithResponseCallback(
    ACPExtensionEvent event,
  ) =>
      _channel.invokeMethod<Map<dynamic, dynamic>>('dispatchEventWithResponseCallback', event.data).then((value) => ACPExtensionEvent(value!));

  /// Dispatches a response event for a paired event that was sent to dispatchEventWithResponseCallback or received by an extension listener hear method.
  static Future<bool> dispatchResponseEvent(
    ACPExtensionEvent responseEvent,
    ACPExtensionEvent requestEvent,
  ) =>
      _channel.invokeMethod<bool>(
        'dispatchResponseEvent',
        {"responseEvent": responseEvent.data, "requestEvent": requestEvent.data},
      ).then((value) => value!);

  /// RulesEngine API to download and refresh rules from the server. (iOS only)
  static Future<void> downloadRules() => _channel.invokeMethod('downloadRules');

  /// Calls the provided callback with a JSON string containing all of the user's identities known by the SDK
  ///
  /// @return {String} known identifier as a JSON string
  static Future<String> get sdkIdentities => _channel.invokeMethod<String>('getSdkIdentities').then((value) => value!);

  /// Get the current Adobe Mobile Privacy Status
  static Future<ACPPrivacyStatus> get privacyStatus => _channel.invokeMethod<String>('getPrivacyStatus').then((value) => value!.toACPPrivacyStatus);

  /// Set the logging level of the SDK
  ///
  /// @param {ACPMobileLogLevel} mode ACPMobileLogLevel to be used by the SDK
  static Future<void> setLogLevel(ACPLoggingLevel mode) => _channel.invokeMethod('setLogLevel', mode.value);

  /// Set the Adobe Mobile Privacy status
  ///
  /// @param {ACPMobilePrivacyStatus} privacyStatus ACPMobilePrivacyStatus to be set to the SDK
  static Future<void> setPrivacyStatus(ACPPrivacyStatus privacyStatus) => _channel.invokeMethod('setPrivacyStatus', privacyStatus.value);

  /// Update specific configuration parameters
  ///
  /// Update the current SDK configuration with specific key/value pairs. Keys not found in the current
  /// configuration are added.
  ///
  /// Using `null` values is allowed and effectively removes the configuration parameter from the current configuration.
  ///
  /// @param  {Map<String, Object>} configMap configuration key/value pairs to be updated or added. A value of `null` has no effect.
  static Future<void> updateConfiguration(Map<String, Object> configMap) => _channel.invokeMethod('updateConfiguration', configMap);
}
