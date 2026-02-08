import 'package:flutter/material.dart';

import '../models/timer_config.dart';
import '../utils/validators.dart';

/// Configuration screen where users input timer parameters
class ConfigScreen extends StatefulWidget {
  final Function(TimerConfig) onStart;

  const ConfigScreen({required this.onStart, super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _exCountCtrl = TextEditingController(text: '5');
  final _exDurationCtrl = TextEditingController(text: '30');
  final _setCountCtrl = TextEditingController(text: '3');
  final _restBetweenExCtrl = TextEditingController(text: '15');
  final _restBetweenSetsCtrl = TextEditingController(text: '60');

  @override
  void dispose() {
    _exCountCtrl.dispose();
    _exDurationCtrl.dispose();
    _setCountCtrl.dispose();
    _restBetweenExCtrl.dispose();
    _restBetweenSetsCtrl.dispose();
    super.dispose();
  }

  void _handleStart() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli değerler girin')),
      );
      return;
    }
    final config = TimerConfig(
      totalExercises: int.tryParse(_exCountCtrl.text) ?? 5,
      exerciseDuration: int.tryParse(_exDurationCtrl.text) ?? 30,
      totalSets: int.tryParse(_setCountCtrl.text) ?? 3,
      restBetweenExercises: int.tryParse(_restBetweenExCtrl.text) ?? 15,
      restBetweenSets: int.tryParse(_restBetweenSetsCtrl.text) ?? 60,
    );
    widget.onStart(config);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch - Interval Trainer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Egzersiz Ayarları',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _exCountCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Egzersiz sayısı',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validateCount,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _exDurationCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Egzersiz süresi (s)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validateDuration,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setCountCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Set sayısı',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validateCount,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _restBetweenExCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Egzersizler arası (s)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: Validators.validateDuration,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _restBetweenSetsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Setler arası dinlenme (s)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validateDuration,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _handleStart,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Başlat', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
