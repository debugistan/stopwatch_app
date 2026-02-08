import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateDuration rejects null/empty', () {
      expect(Validators.validateDuration(null), isNotNull);
      expect(Validators.validateDuration(''), isNotNull);
    });

    test('validateDuration rejects non-number and <3', () {
      expect(Validators.validateDuration('abc'), isNotNull);
      expect(Validators.validateDuration('2'), 'Minimum 3 saniye olmalı');
    });

    test('validateDuration accepts valid', () {
      expect(Validators.validateDuration('3'), isNull);
      expect(Validators.validateDuration('30'), isNull);
    });

    test('validateCount rejects null/empty/non-number', () {
      expect(Validators.validateCount(null), isNotNull);
      expect(Validators.validateCount(''), isNotNull);
      expect(Validators.validateCount('x'), isNotNull);
    });

    test('validateCount rejects <2 and accepts >=2', () {
      expect(Validators.validateCount('1'), 'Minimum 2 olmalı');
      expect(Validators.validateCount('2'), isNull);
      expect(Validators.validateCount('5'), isNull);
    });
  });
}
