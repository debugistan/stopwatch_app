import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

import '../utils/wav_generator.dart';

/// Service for handling audio beeps on both Android and Web platforms
class AudioService {
  static const MethodChannel _methodChannel = MethodChannel(
    'com.example.my_app/beep',
  );

  AudioPlayer? _audioPlayer;

  AudioService() {
    // Do not eagerly create AudioPlayer to avoid platform channel calls during tests.
    _audioPlayer = null;
  }

  /// Plays a short beep (100ms)
  Future<void> playShortBeep() async {
    try {
      if (!kIsWeb) {
        // Android: use native ToneGenerator with 100ms duration
        await _methodChannel.invokeMethod('playBeep', {'duration': 100});
      } else {
        // Web: use WAV generation with data URL
        final audio = WAVGenerator.generateSineWave(750, 120);
        final dataUrl = WAVGenerator.wavToDataUrl(audio);
        _audioPlayer ??= AudioPlayer();
        await _audioPlayer!.play(
          UrlSource(dataUrl),
          mode: PlayerMode.lowLatency,
        );
      }
    } catch (e) {
      debugPrint('Short beep error: $e');
    }
  }

  /// Plays a long beep (300ms) with melody
  Future<void> playLongBeep() async {
    try {
      if (!kIsWeb) {
        // Android: use native ToneGenerator with 300ms duration
        await _methodChannel.invokeMethod('playBeep', {'duration': 300});
      } else {
        // Web: use WAV generation with melody and data URL
        final audio = WAVGenerator.generateMelodyWAV([800, 600], [150, 150]);
        final dataUrl = WAVGenerator.wavToDataUrl(audio);
        _audioPlayer ??= AudioPlayer();
        await _audioPlayer!.play(
          UrlSource(dataUrl),
          mode: PlayerMode.lowLatency,
        );
      }
    } catch (e) {
      debugPrint('Long beep error: $e');
    }
  }

  /// Disposes audio player resources
  void dispose() {
    _audioPlayer?.dispose();
  }
}
