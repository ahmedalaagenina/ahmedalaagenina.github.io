import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mycv/data/portfolio_data.dart';

/// Guards the content rule: the site says only what the CV says.
void main() {
  /// Every user-visible string in the data layer, flattened.
  List<String> allText() => [
    Portfolio.summary,
    Portfolio.identity.fullTitle,
    ...Portfolio.copy.hero.roles,
    Portfolio.copy.hero.oneLiner,
    for (final role in Portfolio.roles) ...[
      role.title,
      role.company,
      role.period,
      role.employmentLabel,
      ...role.bullets,
      for (final p in role.products) ...[p.name, ?p.category, ...p.bullets],
    ],
    Portfolio.openSource.description,
    for (final e in Portfolio.education) ...[e.title, e.institution],
  ];

  test('none of the removed, unconfirmed metrics come back', () {
    const banned = [
      '40%',
      '100%',
      '60%',
      '99.9',
      '15%',
      '17+',
      'fintech',
      'Fintech',
    ];
    for (final text in allText()) {
      for (final phrase in banned) {
        expect(
          text.contains(phrase),
          isFalse,
          reason: '"$phrase" is not in the CV: $text',
        );
      }
    }
  });

  test('part-time roles are labelled as such', () {
    for (final role in Portfolio.roles) {
      if (role.employment == Employment.partTime) {
        expect(role.employmentLabel, contains('Part-Time'));
      }
    }
  });

  test('every link is https', () {
    final urls = [
      Portfolio.identity.linkedInUrl,
      Portfolio.identity.gitHubUrl,
      Portfolio.openSource.pubDevUrl,
      Portfolio.openSource.githubUrl,
      for (final role in Portfolio.roles)
        for (final p in role.products)
          for (final l in p.links) ?l.url,
      for (final q in Portfolio.quickLinks) q.url,
    ];
    for (final url in urls) {
      expect(Uri.parse(url).scheme, 'https', reason: url);
    }
  });

  test('every showcase entry points at a real product and asset', () {
    for (final entry in Portfolio.showcase) {
      expect(() => Portfolio.product(entry.productId), returnsNormally);
      expect(File(entry.icon).existsSync(), isTrue, reason: entry.icon);
      for (final screen in entry.screens) {
        expect(File(screen).existsSync(), isTrue, reason: screen);
      }
    }
  });

  test('the CV PDF exists where the download button points', () {
    expect(File('web/${Portfolio.identity.cvPath}').existsSync(), isTrue);
  });
}
