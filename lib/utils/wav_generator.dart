import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

/// Utility class for generating WAV audio files programmatically
class WAVGenerator {
  static const int _sampleRate = 44100;
  static const int _channels = 1;
  static const int _bitsPerSample = 16;
  static const int _fadeInOutMs = 10; // 10ms fade in/out envelope

  /// Generates a single-frequency WAV file with envelope
  static Uint8List generateSineWave(int frequency, int durationMs) {
    final int numSamples = (_sampleRate * durationMs) ~/ 1000;
    final int byteRate = _sampleRate * _channels * (_bitsPerSample ~/ 8);
    final int blockAlign = _channels * (_bitsPerSample ~/ 8);
    final int subchunk2Size = numSamples * _channels * (_bitsPerSample ~/ 8);
    final int fileSize = 36 + subchunk2Size;

    final BytesBuilder wav = BytesBuilder();

    // RIFF header
    _addString(wav, 'RIFF');
    _addInt32LE(wav, fileSize);
    _addString(wav, 'WAVE');

    // fmt subchunk
    _addString(wav, 'fmt ');
    _addInt32LE(wav, 16); // subchunk1 size
    _addInt16LE(wav, 1); // audio format (PCM)
    _addInt16LE(wav, _channels);
    _addInt32LE(wav, _sampleRate);
    _addInt32LE(wav, byteRate);
    _addInt16LE(wav, blockAlign);
    _addInt16LE(wav, _bitsPerSample);

    // data subchunk
    _addString(wav, 'data');
    _addInt32LE(wav, subchunk2Size);

    // PCM data (sine wave with envelope)
    _generatePCM(wav, [frequency], [durationMs], numSamples);

    return wav.toBytes();
  }

  /// Generates a melody WAV file with multiple tones
  static Uint8List generateMelodyWAV(
    List<int> frequencies,
    List<int> durations,
  ) {
    final int totalDurationMs = durations.reduce((a, b) => a + b);
    final int totalSamples = (_sampleRate * totalDurationMs) ~/ 1000;
    final int byteRate = _sampleRate * _channels * (_bitsPerSample ~/ 8);
    final int blockAlign = _channels * (_bitsPerSample ~/ 8);
    final int subchunk2Size = totalSamples * _channels * (_bitsPerSample ~/ 8);
    final int fileSize = 36 + subchunk2Size;

    final BytesBuilder wav = BytesBuilder();

    // RIFF header
    _addString(wav, 'RIFF');
    _addInt32LE(wav, fileSize);
    _addString(wav, 'WAVE');

    // fmt subchunk
    _addString(wav, 'fmt ');
    _addInt32LE(wav, 16);
    _addInt16LE(wav, 1);
    _addInt16LE(wav, _channels);
    _addInt32LE(wav, _sampleRate);
    _addInt32LE(wav, byteRate);
    _addInt16LE(wav, blockAlign);
    _addInt16LE(wav, _bitsPerSample);

    // data subchunk
    _addString(wav, 'data');
    _addInt32LE(wav, subchunk2Size);

    // PCM data (multi-tone with envelope)
    _generatePCM(wav, frequencies, durations, totalSamples);

    return wav.toBytes();
  }

  /// Generates PCM audio data with envelope
  static void _generatePCM(
    BytesBuilder wav,
    List<int> frequencies,
    List<int> durations,
    int totalSamples,
  ) {
    int currentSample = 0;

    for (int toneIdx = 0; toneIdx < frequencies.length; toneIdx++) {
      final int freq = frequencies[toneIdx];
      final int durationMs = durations[toneIdx];
      final int numSamples = (_sampleRate * durationMs) ~/ 1000;

      for (int i = 0; i < numSamples; i++) {
        final double rawSample = sin(2 * pi * freq * i / _sampleRate);

        // Apply envelope (fade in/out for smoothness)
        double envelope = 1.0;
        final int fadeInSamples = _sampleRate ~/ (_fadeInOutMs * 10);
        final int fadeOutSamples = _sampleRate ~/ (_fadeInOutMs * 10);

        if (i < fadeInSamples) {
          envelope = i / fadeInSamples;
        } else if (i > numSamples - fadeOutSamples) {
          envelope = (numSamples - i) / fadeOutSamples;
        }

        final double sample = 32767 * 0.25 * envelope * rawSample;
        final int intSample = sample.toInt();
        _addInt16LE(wav, intSample);

        currentSample++;
        if (currentSample >= totalSamples) break;
      }
      if (currentSample >= totalSamples) break;
    }
  }

  /// Converts WAV bytes to base64 data URL
  static String wavToDataUrl(Uint8List wav) {
    final String base64Wav = base64Encode(wav);
    return 'data:audio/wav;base64,$base64Wav';
  }

  static void _addString(BytesBuilder builder, String str) {
    for (int i = 0; i < str.length; i++) {
      builder.addByte(str.codeUnitAt(i));
    }
  }

  static void _addInt32LE(BytesBuilder builder, int value) {
    builder.addByte(value & 0xFF);
    builder.addByte((value >> 8) & 0xFF);
    builder.addByte((value >> 16) & 0xFF);
    builder.addByte((value >> 24) & 0xFF);
  }

  static void _addInt16LE(BytesBuilder builder, int value) {
    builder.addByte(value & 0xFF);
    builder.addByte((value >> 8) & 0xFF);
  }
}
