/// Data model for timer configuration
class TimerConfig {
  final int totalExercises;
  final int exerciseDuration;
  final int totalSets;
  final int restBetweenExercises;
  final int restBetweenSets;

  TimerConfig({
    required this.totalExercises,
    required this.exerciseDuration,
    required this.totalSets,
    required this.restBetweenExercises,
    required this.restBetweenSets,
  });
}
