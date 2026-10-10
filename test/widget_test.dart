import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mycv/data/portfolio_data.dart';
import 'package:mycv/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

Future<void> pumpHome(WidgetTester tester, Size size) async {
  SharedPreferences.setMockInitialValues({});
  VisibilityDetectorController.instance.updateInterval = Duration.zero;
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const PortfolioApp());
  // Intro flight + hero entrance.
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

void main() {
  testWidgets('home renders the hero on desktop', (tester) async {
    await pumpHome(tester, const Size(1440, 1000));
    expect(find.text(Portfolio.identity.displayName), findsWidgets);
    expect(find.text(Portfolio.copy.hero.oneLiner), findsOneWidget);
    expect(find.text(Portfolio.copy.hero.primaryCta), findsOneWidget);
  });

  testWidgets('home renders on a small phone without overflow', (tester) async {
    await pumpHome(tester, const Size(360, 740));
    expect(tester.takeException(), isNull);
    expect(find.text(Portfolio.copy.hero.oneLiner), findsOneWidget);
  });
}
