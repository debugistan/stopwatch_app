/// Form field validators for timer configuration
class Validators {
  /// Validates duration fields (minimum 3 seconds)
  static String? validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen bir değer girin';
    }
    final intVal = int.tryParse(value);
    if (intVal == null) {
      return 'Lütfen geçerli bir sayı girin';
    }
    if (intVal < 3) {
      return 'Minimum 3 saniye olmalı';
    }
    return null;
  }

  /// Validates count fields (minimum 2)
  static String? validateCount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen bir değer girin';
    }
    final intVal = int.tryParse(value);
    if (intVal == null) {
      return 'Lütfen geçerli bir sayı girin';
    }
    if (intVal < 2) {
      return 'Minimum 2 olmalı';
    }
    return null;
  }
}
