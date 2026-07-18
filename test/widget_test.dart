import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mycv/data/cv_data.dart';
import 'package:mycv/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  testWidgets('home page renders without errors', (tester) async {
    SharedPreferences.setMockInitialValues({});
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Hi, I'm"), findsOneWidget);
    expect(find.textContaining(CV.shortName), findsWidgets);
  });

  testWidgets('home page renders on a phone-sized screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
  });

  test('CV data is consistent', () {
    expect(CV.experience, isNotEmpty);
    expect(CV.projects, isNotEmpty);
    expect(CV.skills, isNotEmpty);
    expect(CV.phones, isNotEmpty);
    // Every experience entry has at least one project with bullets.
    for (final record in CV.experience) {
      expect(record.projects, isNotEmpty, reason: record.company);
      for (final project in record.projects) {
        expect(project.bullets, isNotEmpty, reason: project.name);
      }
    }
    // Store links, when present, are valid URLs.
    for (final project in CV.projects) {
      for (final url in [project.iosUrl, project.androidUrl, project.webUrl]) {
        if (url != null) {
          expect(Uri.tryParse(url), isNotNull, reason: project.name);
        }
      }
    }
  });
}
