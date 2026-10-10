import '../../../../data/models.dart';

/// Finds where each skill is mentioned in the experience text.
///
/// Derived purely from the CV bullets, so it can never claim more than the
/// CV says. Product bullets map to the product name; role-level bullets map
/// to the company.
Map<String, List<String>> skillUsage(
  List<SkillGroup> groups,
  List<Role> roles,
) {
  // (place, text) pairs to search.
  final sources = <(String, String)>[
    for (final role in roles) ...[
      for (final product in role.products)
        for (final bullet in product.bullets) (product.name, bullet),
      for (final bullet in role.bullets) (role.company, bullet),
    ],
  ];

  final usage = <String, List<String>>{};
  for (final group in groups) {
    for (final skill in group.skills) {
      final patterns = [
        for (final term in skill.terms)
          // Letter-boundary match: "Git" must not match inside "GitHub",
          // but "payment" should match "multi-payment".
          RegExp(
            '(?<![A-Za-z])${RegExp.escape(term)}(?![A-Za-z])',
            caseSensitive: false,
          ),
      ];
      final places = <String>[];
      for (final (place, text) in sources) {
        if (places.contains(place)) continue;
        if (patterns.any((p) => p.hasMatch(text))) places.add(place);
      }
      usage[skill.name] = places;
    }
  }
  return usage;
}
