// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

typedef Callback = Function(MethodCall call);

const String kTestString = 'Hello World';

final MockFirebaseMessaging kMockMessagingPlatform = MockFirebaseMessaging();

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}

void setupFirebaseMessagingMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    return null;
  });

  // Mock Platform Interface Methods
  // ignore: invalid_use_of_protected_member
  when(kMockMessagingPlatform.delegateFor(app: anyNamed('app')))
      .thenReturn(kMockMessagingPlatform);
  // ignore: invalid_use_of_protected_member
  when(kMockMessagingPlatform.setInitialValues(
    isAutoInitEnabled: anyNamed('isAutoInitEnabled'),
  )).thenReturn(kMockMessagingPlatform);
}

// Platform Interface Mock Classes

// FirebaseMessagingPlatform Mock
class MockFirebaseMessaging extends Mock
    with MockPlatformInterfaceMixin
    implements FirebaseMessagingPlatform {
  MockFirebaseMessaging() {
    TestFirebaseMessagingPlatform();
  }

  @override
  bool get isAutoInitEnabled {
    return super.noSuchMethod(Invocation.getter(#isAutoInitEnabled), true);
  }

  @override
  FirebaseMessagingPlatform delegateFor({FirebaseApp? app}) {
    return super.noSuchMethod(
      Invocation.method(#delegateFor, [], {#app: app}),
      TestFirebaseMessagingPlatform(),
    );
  }

  @override
  FirebaseMessagingPlatform setInitialValues({bool? isAutoInitEnabled}) {
    return super.noSuchMethod(
      Invocation.method(
          #setInitialValues, [], {#isAutoInitEnabled: isAutoInitEnabled}),
      TestFirebaseMessagingPlatform(),
    );
  }

  @override
  Future<RemoteMessage?> getInitialMessage() {
    return super.noSuchMethod(Invocation.method(#getInitialMessage, []),
        neverEndingFuture<RemoteMessage>());
  }

  @override
  Future<void> deleteToken({String? senderId}) {
    return super.noSuchMethod(
        Invocation.method(#deleteToken, [], {#senderId: senderId}),
        Future<void>.value());
  }

  @override
  Future<String?> getAPNSToken() {
    return super.noSuchMethod(
        Invocation.method(#getAPNSToken, []), Future<String>.value(''));
  }

  @override
  Future<String> getToken({String? senderId, String? vapidKey}) {
    return super.noSuchMethod(
        Invocation.method(
            #getToken, [], {#senderId: senderId, #vapidKey: vapidKey}),
        Future<String>.value(''));
  }

  @override
  Future<void> setAutoInitEnabled(bool? enabled) {
    return super.noSuchMethod(Invocation.method(#setAutoInitEnabled, [enabled]),
        Future<void>.value());
  }

  @override
  Stream<String> get onTokenRefresh {
    return super.noSuchMethod(
      Invocation.getter(#onTokenRefresh),
      const Stream<String>.empty(),
    );
  }

  @override
  Future<NotificationSettings> requestPermission(
      {bool? alert = true,
      bool? announcement = false,
      bool? badge = true,
      bool? carPlay = false,
      bool? criticalAlert = false,
      bool? provisional = false,
      bool? sound = true}) {
    return super.noSuchMethod(
        Invocation.method(#requestPermission, [], {
          #alert: alert,
          #announcement: announcement,
          #badge: badge,
          #carPlay: carPlay,
          #criticalAlert: criticalAlert,
          #provisional: provisional,
          #sound: sound
        }),
        neverEndingFuture<NotificationSettings>());
  }

  @override
  Future<void> subscribeToTopic(String? topic) {
    return super.noSuchMethod(
        Invocation.method(#subscribeToTopic, [topic]), Future<void>.value());
  }

  @override
  Future<void> unsubscribeFromTopic(String? topic) {
    return super.noSuchMethod(Invocation.method(#unsubscribeFromTopic, [topic]),
        Future<void>.value());
  }
}

class TestFirebaseMessagingPlatform extends FirebaseMessagingPlatform {
  TestFirebaseMessagingPlatform() : super();
}
