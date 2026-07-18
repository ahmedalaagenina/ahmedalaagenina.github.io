import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';

class CommandItem {
  final String label;
  final String hint;
  final FaIconData icon;
  final VoidCallback action;

  const CommandItem({
    required this.label,
    required this.hint,
    required this.icon,
    required this.action,
  });
}

/// ⌘K / Ctrl+K quick-navigation palette.
class CommandPalette extends StatefulWidget {
  final List<CommandItem> items;

  const CommandPalette({super.key, required this.items});

  static Future<void> show(BuildContext context, List<CommandItem> items) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .55),
      builder: (_) => CommandPalette(items: items),
    );
  }

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  static const double _itemExtent = 44;

  final TextEditingController _query = TextEditingController();
  final ScrollController _listScroll = ScrollController();
  int _selected = 0;

  @override
  void dispose() {
    _query.dispose();
    _listScroll.dispose();
    super.dispose();
  }

  /// Keeps the keyboard-selected row inside the visible part of the list.
  void _ensureSelectedVisible() {
    if (!_listScroll.hasClients) return;
    final viewport = _listScroll.position.viewportDimension;
    final top = _selected * _itemExtent;
    final bottom = top + _itemExtent;
    double? target;
    if (top < _listScroll.offset) {
      target = top;
    } else if (bottom > _listScroll.offset + viewport) {
      target = bottom - viewport;
    }
    if (target != null) {
      _listScroll.animateTo(
        target.clamp(0, _listScroll.position.maxScrollExtent),
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    }
  }

  List<CommandItem> get _filtered {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items
        .where((i) =>
            i.label.toLowerCase().contains(q) ||
            i.hint.toLowerCase().contains(q))
        .toList();
  }

  void _run(CommandItem item) {
    Navigator.of(context).pop();
    item.action();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final items = _filtered;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() => _selected = (_selected + 1) % items.length);
      _ensureSelectedVisible();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() => _selected = (_selected - 1 + items.length) % items.length);
      _ensureSelectedVisible();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter && items.isNotEmpty) {
      _run(items[_selected.clamp(0, items.length - 1)]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final items = _filtered;
    if (_selected >= items.length) _selected = 0;

    return Dialog(
      alignment: const Alignment(0, -0.5),
      backgroundColor: t.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: t.glassBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 420),
        child: Focus(
          onKeyEvent: _onKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                child: TextField(
                  controller: _query,
                  autofocus: true,
                  onChanged: (_) => setState(() => _selected = 0),
                  style: TextStyle(color: t.textPrimary, fontSize: 15),
                  decoration: InputDecoration(
                    icon: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 14,
                      color: t.textMuted,
                    ),
                    hintText: 'Jump to a section or link…',
                    hintStyle: TextStyle(color: t.textMuted),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Divider(height: 1, color: t.glassBorder),
              Flexible(
                child: items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No matches',
                          style: TextStyle(color: t.textMuted),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        controller: _listScroll,
                        itemExtent: _itemExtent,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final item = items[i];
                          final selected = i == _selected;
                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _run(item),
                            onHover: (h) {
                              if (h) setState(() => _selected = i);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? t.accentA.withValues(alpha: .14)
                                    : null,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  FaIcon(
                                    item.icon,
                                    size: 14,
                                    color:
                                        selected ? t.accentB : t.textMuted,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: TextStyle(
                                        color: t.textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    item.hint,
                                    style: TextStyle(
                                      color: t.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
