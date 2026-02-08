import 'dart:async';

import 'package:flutter/material.dart';

import '../enums/phase.dart';
import '../models/timer_config.dart';
import '../services/audio_service.dart';

/// Timer screen that displays the countdown and manages the workout phases
class TimerScreen extends StatefulWidget {
  final TimerConfig config;
  final VoidCallback onBack;

  const TimerScreen({required this.config, required this.onBack, super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late AudioService _audioService;
  Timer? _timer;
  bool _running = false;

  // Runtime state
  Phase _phase = Phase.exercise;
  int _currentSet = 1;
  int _currentExercise = 1;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _audioService = AudioService();
    _resetTimer();
    // Auto-start with preparation countdown
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _start();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  void _resetTimer() {
    setState(() {
      _phase = Phase.preparation;
      _currentSet = 1;
      _currentExercise = 1;
      _remainingSeconds = 5; // 5-second preparation countdown
      _running = false;
    });
    _timer?.cancel();
  }

  void _start() {
    if (_running) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    setState(() => _running = true);
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _tick() {
    if (_remainingSeconds > 0) {
      setState(() => _remainingSeconds--);
      // Play short beep for last 3 seconds
      if (_remainingSeconds <= 3 && _remainingSeconds >= 1) {
        _audioService.playShortBeep();
      } else if (_remainingSeconds == 0) {
        _audioService.playLongBeep();
      }
      return;
    }

    // Phase transition
    if (_phase == Phase.preparation) {
      _phase = Phase.exercise;
      _remainingSeconds = widget.config.exerciseDuration;
    } else if (_phase == Phase.exercise) {
      // Finished an exercise
      if (_currentExercise < widget.config.totalExercises) {
        _phase = Phase.restBetweenExercises;
        _remainingSeconds = widget.config.restBetweenExercises;
      } else {
        // Finished exercises in this set
        if (_currentSet < widget.config.totalSets) {
          _phase = Phase.restBetweenSets;
          _remainingSeconds = widget.config.restBetweenSets;
        } else {
          _phase = Phase.finished;
          _timer?.cancel();
          setState(() => _running = false);
          return;
        }
      }
    } else if (_phase == Phase.restBetweenExercises) {
      _currentExercise++;
      _phase = Phase.exercise;
      _remainingSeconds = widget.config.exerciseDuration;
    } else if (_phase == Phase.restBetweenSets) {
      _currentSet++;
      _currentExercise = 1;
      _phase = Phase.exercise;
      _remainingSeconds = widget.config.exerciseDuration;
    }

    setState(() {});
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _getPhaseDisplay(Phase phase) {
    switch (phase) {
      case Phase.preparation:
        return 'Hazırlık - Başlamaya Hazır Ol';
      case Phase.exercise:
        return 'Egzersiz Zamanı';
      case Phase.restBetweenExercises:
        return 'Egzersizler Arası Dinlenme';
      case Phase.restBetweenSets:
        return 'Setler Arası Dinlenme';
      case Phase.finished:
        return 'Tamamlandı';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopwatch - Interval Trainer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _timer?.cancel();
            widget.onBack();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Set: $_currentSet / ${widget.config.totalSets}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Egzersiz: $_currentExercise / ${widget.config.totalExercises}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _phase == Phase.exercise
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.blue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getPhaseDisplay(_phase),
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Timer Display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    _formatTime(_remainingSeconds),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _running ? null : _start,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Başlat'),
                ),
                ElevatedButton.icon(
                  onPressed: _running ? _stop : null,
                  icon: const Icon(Icons.pause),
                  label: const Text('Durdur'),
                ),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Sıfırla'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
