import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/audio_service.dart';

void main() {
  const MethodChannel channel = MethodChannel('com.example.my_app/beep');

  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioService', () {
    tearDown(() async {
      channel.setMockMethodCallHandler(null);
    });

    test('playShortBeep invokes method channel with duration 100', () async {
      MethodCall? lastCall;
      channel.setMockMethodCallHandler((call) async {
        lastCall = call;
        return null;
      });

      final svc = AudioService();
      await svc.playShortBeep();

      expect(lastCall, isNotNull);
      expect(lastCall!.method, 'playBeep');
      expect(lastCall!.arguments, isA<Map>());
      expect((lastCall!.arguments as Map)['duration'], 100);

      svc.dispose();
    });

    test('playLongBeep invokes method channel with duration 300', () async {
      MethodCall? lastCall;
      channel.setMockMethodCallHandler((call) async {
        lastCall = call;
        return null;
      });

      final svc = AudioService();
      await svc.playLongBeep();

      expect(lastCall, isNotNull);
      expect(lastCall!.method, 'playBeep');
      expect((lastCall!.arguments as Map)['duration'], 300);

      svc.dispose();
    });
  });
}
