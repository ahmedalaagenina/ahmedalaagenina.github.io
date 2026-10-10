import 'package:flutter_test/flutter_test.dart';
import 'package:mycv/data/portfolio_data.dart';
import 'package:mycv/features/home/sections/skills/skill_usage.dart';

void main() {
  final usage = skillUsage(Portfolio.skills, Portfolio.roles);

  test('finds a skill in product bullets by product name', () {
    expect(usage['Hive'], containsAll(['iDara Sign', 'iDara Tracking']));
  });

  test('role-level bullets map to the company', () {
    expect(usage['Platform Channels'], ['Aramex International']);
  });

  test('alternate terms are used (HealthKit / Health Connect)', () {
    expect(
      usage['HealthKit / Health Connect'],
      containsAll(['Sanad Rewards', 'Sanad Business']),
    );
  });

  test('matches on letter boundaries only', () {
    // "Git" appears in no bullet; "GetIt" and "GitHub" must not count.
    expect(usage['Git'], isEmpty);
  });

  test('every CV skill has an entry', () {
    final names = [
      for (final g in Portfolio.skills)
        for (final s in g.skills) s.name,
    ];
    expect(usage.keys, containsAll(names));
  });
}
