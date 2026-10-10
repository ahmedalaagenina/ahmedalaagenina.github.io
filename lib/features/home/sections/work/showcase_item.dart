import '../../../../data/models.dart';

/// Presentation model for one showcase entry: the entry plus its resolved
/// product and the exact bullets to show. Built by the composition root, so
/// the section never has to search the data layer itself.
class ShowcaseItem {
  const ShowcaseItem({
    required this.entry,
    required this.product,
    required this.highlights,
  });

  final ShowcaseEntry entry;
  final Product product;
  final List<String> highlights;
}
