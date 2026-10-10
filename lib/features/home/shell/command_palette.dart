import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/responsive.dart';
import '../../../data/copy.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/pressable.dart';

class PaletteItem {
  const PaletteItem({
    required this.label,
    required this.icon,
    required this.onSelect,
    this.hint,
    this.keywords = const [],
  });

  final String label;
  final Widget icon;
  final VoidCallback onSelect;
  final String? hint;

  /// Extra search terms, e.g. "mail" for the email action.
  final List<String> keywords;
}

class PaletteGroup {
  const PaletteGroup({required this.title, required this.items});

  final String title;
  final List<PaletteItem> items;
}

/// ⌘K / Ctrl+K palette: type to filter, ↑/↓ to move, Enter to run,
/// Esc to close.
class CommandPalette extends StatefulWidget {
  const CommandPalette({super.key, required this.groups, required this.copy});

  final List<PaletteGroup> groups;
  final PaletteCopy copy;

  static Future<void> show(
    BuildContext context, {
    required List<PaletteGroup> groups,
    required PaletteCopy copy,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => CommandPalette(groups: groups, copy: copy),
    );
  }

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  static const double _rowHeight = 46;

  final _query = TextEditingController();
  final _scroll = ScrollController();
  int _selected = 0;

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  List<(String, PaletteItem)> get _results {
    final q = _query.text.trim().toLowerCase();
    return [
      for (final group in widget.groups)
        for (final item in group.items)
          if (q.isEmpty ||
              item.label.toLowerCase().contains(q) ||
              group.title.toLowerCase().contains(q) ||
              item.keywords.any((k) => k.toLowerCase().contains(q)))
            (group.title, item),
    ];
  }

  void _move(int delta) {
    final count = _results.length;
    if (count == 0) return;
    setState(() => _selected = (_selected + delta) % count);
    // Keep the selected row visible.
    if (!_scroll.hasClients) return;
    final top = _selected * _rowHeight;
    final viewport = _scroll.position.viewportDimension;
    if (top < _scroll.offset) {
      _scroll.jumpTo(top);
    } else if (top + _rowHeight > _scroll.offset + viewport) {
      _scroll.jumpTo(top + _rowHeight - viewport);
    }
  }

  void _run(PaletteItem item) {
    Navigator.of(context).pop();
    item.onSelect();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final results = _results;
    if (_selected >= results.length) _selected = 0;

    return Align(
      alignment: const Alignment(0, -0.55),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.gutter),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 520),
          child: Material(
            color: t.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.l),
              side: BorderSide(color: t.lineStrong),
            ),
            clipBehavior: Clip.antiAlias,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                    _move(1),
                const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                    _move(-1),
                const SingleActivator(LogicalKeyboardKey.enter): () {
                  if (results.isNotEmpty) _run(results[_selected].$2);
                },
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: t.textMuted),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _query,
                            autofocus: true,
                            onChanged: (_) => setState(() => _selected = 0),
                            style: type.bodyStrong,
                            decoration: InputDecoration(
                              hintText: widget.copy.searchHint,
                              hintStyle: type.body,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: t.line),
                  Flexible(
                    child: results.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              widget.copy.noMatches,
                              style: type.small,
                            ),
                          )
                        : ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shrinkWrap: true,
                            itemExtent: _rowHeight,
                            itemCount: results.length,
                            itemBuilder: (context, i) {
                              final (group, item) = results[i];
                              return _Row(
                                item: item,
                                group: group,
                                selected: i == _selected,
                                onHover: () => setState(() => _selected = i),
                                onTap: () => _run(item),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.item,
    required this.group,
    required this.selected,
    required this.onHover,
    required this.onTap,
  });

  final PaletteItem item;
  final String group;
  final bool selected;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    return MouseRegion(
      onEnter: (_) => onHover(),
      child: Pressable(
        semanticLabel: item.label,
        onTap: onTap,
        pressScale: 0.99,
        builder: (context, states) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? t.surfaceRaised : null,
            borderRadius: BorderRadius.circular(Radii.s + 2),
          ),
          child: Row(
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  size: 18,
                  color: selected ? t.signalText : t.textMuted,
                ),
                child: item.icon,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: type.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(item.hint ?? group, style: type.mono),
            ],
          ),
        ),
      ),
    );
  }
}
