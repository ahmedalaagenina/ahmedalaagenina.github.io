import 'package:flutter/material.dart';

import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import 'icons/brand_icons.dart';
import 'pressable.dart';

/// The platform links of one product. Linked platforms are buttons that open
/// the store in a new tab; platforms without a public link render as plain,
/// non-interactive labels (and say so to screen readers).
class StoreLinks extends StatelessWidget {
  const StoreLinks({
    super.key,
    required this.productName,
    required this.links,
    required this.copy,
    this.compact = false,
  });

  final String productName;
  final List<StoreLink> links;
  final CommonCopy copy;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final link in links)
          link.hasUrl
              ? _LinkChip(
                  link: link,
                  productName: productName,
                  copy: copy,
                  compact: compact,
                )
              : _PlainChip(link: link, copy: copy, compact: compact),
      ],
    );
  }
}

String _storeName(LinkKind kind, CommonCopy copy) => switch (kind) {
  LinkKind.ios => copy.appStore,
  LinkKind.android => copy.googlePlay,
  LinkKind.web => copy.web,
  LinkKind.admin => copy.admin,
};

String _platformName(LinkKind kind, CommonCopy copy) => switch (kind) {
  LinkKind.ios => copy.ios,
  LinkKind.android => copy.android,
  LinkKind.web => copy.web,
  LinkKind.admin => copy.admin,
};

Widget _icon(LinkKind kind, double size) => switch (kind) {
  LinkKind.ios => BrandIcon(Brand.apple, size: size),
  LinkKind.android => BrandIcon(Brand.googlePlay, size: size - 1),
  LinkKind.web => Icon(Icons.public_rounded, size: size),
  LinkKind.admin => Icon(Icons.admin_panel_settings_outlined, size: size),
};

class _LinkChip extends StatelessWidget {
  const _LinkChip({
    required this.link,
    required this.productName,
    required this.copy,
    required this.compact,
  });

  final StoreLink link;
  final String productName;
  final CommonCopy copy;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final store = _storeName(link.kind, copy);
    return Pressable(
      semanticLabel: copy.openOn.fill({'name': productName, 'platform': store}),
      url: link.url,
      focusRadius: Radii.s + 2,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: compact ? 34 : 38,
          padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12),
          decoration: BoxDecoration(
            color: hovered ? t.surfaceRaised : t.surface,
            borderRadius: BorderRadius.circular(Radii.s + 2),
            border: Border.all(color: hovered ? t.signalText : t.line),
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: t.text),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _icon(link.kind, compact ? 14 : 15),
                const SizedBox(width: 8),
                // Fixed-height chip: one line, ellipsized under large text.
                Flexible(
                  child: Text(
                    store,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.type.label.copyWith(fontSize: 13.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlainChip extends StatelessWidget {
  const _PlainChip({
    required this.link,
    required this.copy,
    required this.compact,
  });

  final StoreLink link;
  final CommonCopy copy;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final name = _platformName(link.kind, copy);
    return Semantics(
      label: copy.noPublicLink.fill({'platform': name}),
      excludeSemantics: true,
      child: Container(
        height: compact ? 34 : 38,
        padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.s + 2),
          border: Border.all(color: t.line),
        ),
        child: IconTheme.merge(
          data: IconThemeData(color: t.textMuted),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _icon(link.kind, compact ? 14 : 15),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.type.label.copyWith(
                    fontSize: 13.5,
                    color: t.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
