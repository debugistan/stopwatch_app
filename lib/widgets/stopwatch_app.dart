import 'package:flutter/material.dart';

import '../models/timer_config.dart';
import '../screens/config_screen.dart';
import '../screens/timer_screen.dart';

/// Root widget that manages navigation between config and timer screens
class StopwatchApp extends StatefulWidget {
  const StopwatchApp({super.key});

  @override
  State<StopwatchApp> createState() => _StopwatchAppState();
}

class _StopwatchAppState extends State<StopwatchApp> {
  TimerConfig? _config;

  void _navigateToTimer(TimerConfig config) {
    setState(() {
      _config = config;
    });
  }

  void _navigateBackToConfig() {
    setState(() {
      _config = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_config != null) {
      return TimerScreen(config: _config!, onBack: _navigateBackToConfig);
    } else {
      return ConfigScreen(onStart: _navigateToTimer);
    }
  }
}
