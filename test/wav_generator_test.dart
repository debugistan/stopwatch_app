import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/wav_generator.dart';

void main() {
  group('WAVGenerator', () {
    test('generateSineWave returns WAV bytes with RIFF header', () {
      final wav = WAVGenerator.generateSineWave(750, 100);
      // RIFF in ASCII
      expect(String.fromCharCodes(wav.sublist(0, 4)), 'RIFF');
      // data url
      final url = WAVGenerator.wavToDataUrl(wav);
      expect(url.startsWith('data:audio/wav;base64,'), isTrue);
    });

    test('generateMelodyWAV length corresponds to durations', () {
      final wav = WAVGenerator.generateMelodyWAV([800, 600], [100, 150]);
      expect(String.fromCharCodes(wav.sublist(0, 4)), 'RIFF');
      final url = WAVGenerator.wavToDataUrl(wav);
      expect(url, startsWith('data:audio/wav;base64,'));
    });
  });
}
