import 'package:flutter/material.dart';

import '../../../../core/motion/springs.dart';
import '../../../../core/responsive.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/bullet_list.dart';
import '../../../../widgets/motion/reveal.dart';
import '../../../../widgets/pressable.dart';
import '../../../../widgets/section_heading.dart';
import '../../../../widgets/store_links.dart';
import 'timeline_rail.dart';

/// Experience as a route map that draws itself while you scroll.
///
/// Full-time roles sit on the solid main line. Part-time roles run on a
/// dashed parallel lane that branches off and merges back, because they
/// really did run in parallel with full-time work.
class ExperienceSection extends StatelessWidget {
  const ExperienceSection({
    super.key,
    required this.copy,
    required this.common,
    required this.roles,
    required this.scroll,
  });

  final ExperienceCopy copy;
  final CommonCopy common;
  final List<Role> roles;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    final lanes = [
      for (final r in roles)
        r.employment == Employment.partTime ? Lane.parallel : Lane.main,
    ];
    bool isParallel(int i) =>
        i >= 0 && i < lanes.length && lanes[i] == Lane.parallel;

    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeading(title: copy.title),
          const SizedBox(height: 20),
          _Legend(copy: copy),
          SizedBox(height: context.pick(40, desktop: 56)),
          for (var i = 0; i < roles.length; i++)
            Reveal(
              child: _RoleRow(
                role: roles[i],
                lane: lanes[i],
                branchIn: isParallel(i) && !isParallel(i - 1),
                mergeOut: isParallel(i) && !isParallel(i + 1),
                isLast: i == roles.length - 1,
                expandFirstProduct: i == 0,
                copy: copy,
                common: common,
                scroll: scroll,
              ),
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.copy});

  final ExperienceCopy copy;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    Widget item(Widget line, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        line,
        const SizedBox(width: 10),
        Text(label, style: type.small),
      ],
    );
    return Wrap(
      spacing: 28,
      runSpacing: 10,
      children: [
        item(
          Container(width: 28, height: 2, color: t.signal),
          copy.fullTimeLane,
        ),
        item(
          Row(
            children: [
              for (var i = 0; i < 3; i++)
                Container(
                  width: 6,
                  height: 2,
                  margin: const EdgeInsets.only(right: 5),
                  color: t.offline,
                ),
            ],
          ),
          copy.partTimeLane,
        ),
      ],
    );
  }
}

/// One role: its rail slice on the left, the content on the right.
///
/// The rail is a Positioned sibling in a Stack (not a Row child), so it
/// takes the content's height without an IntrinsicHeight layout pass, and
/// it lives in its own RepaintBoundary: scrolling repaints six thin rails,
/// never the text next to them.
class _RoleRow extends StatefulWidget {
  const _RoleRow({
    required this.role,
    required this.lane,
    required this.branchIn,
    required this.mergeOut,
    required this.isLast,
    required this.expandFirstProduct,
    required this.copy,
    required this.common,
    required this.scroll,
  });

  final Role role;
  final Lane lane;
  final bool branchIn;
  final bool mergeOut;
  final bool isLast;
  final bool expandFirstProduct;
  final ExperienceCopy copy;
  final CommonCopy common;
  final ScrollController scroll;

  @override
  State<_RoleRow> createState() => _RoleRowState();
}

class _RoleRowState extends State<_RoleRow> {
  final _progress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scroll.removeListener(_onScroll);
    _progress.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.height == 0) return;
    if (context.reduceMotion) {
      _progress.value = 1;
      return;
    }
    // The "reading line" sits a bit below the middle of the viewport.
    final readingLine = MediaQuery.sizeOf(context).height * 0.62;
    final top = box.localToGlobal(Offset.zero).dy;
    _progress.value = ((readingLine - top) / box.size.height).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final desktop = context.isDesktop;
    final railWidth = desktop ? 72.0 : 40.0;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: railWidth,
            bottom: widget.isLast ? 0 : context.pick(56, desktop: 72),
          ),
          child: _RoleContent(
            role: widget.role,
            copy: widget.copy,
            common: widget.common,
            expandFirstProduct: widget.expandFirstProduct,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: railWidth,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: TimelineRailPainter(
                progress: _progress,
                lane: widget.lane,
                branchIn: widget.branchIn,
                mergeOut: widget.mergeOut,
                current: widget.role.isCurrent,
                mainX: desktop ? 14 : 8,
                parallelX: desktop ? 40 : 24,
                nodeY: 16,
                base: t.line,
                mainColor: t.signal,
                parallelColor: t.offline,
                background: t.background,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleContent extends StatelessWidget {
  const _RoleContent({
    required this.role,
    required this.copy,
    required this.common,
    required this.expandFirstProduct,
  });

  final Role role;
  final ExperienceCopy copy;
  final CommonCopy common;
  final bool expandFirstProduct;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final desktop = context.isDesktop;
    final period = Text(role.period, style: type.mono);

    final detailed = role.products.where((p) => p.bullets.isNotEmpty);
    final plain = role.products.where((p) => p.bullets.isEmpty).toList();
    // Many link-only apps (One Solution) read best as a compact grid after
    // the role bullets; a couple of them (Aramex) as rows before.
    final appsGrid = role.bullets.isNotEmpty && plain.length > 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(role.title, style: type.headline),
              ),
            ),
            if (desktop) ...[
              const SizedBox(width: 24),
              Padding(padding: const EdgeInsets.only(top: 6), child: period),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(role.company, style: type.label.copyWith(color: t.signalText)),
            _EmploymentChip(
              label: role.employmentLabel,
              partTime: role.employment == Employment.partTime,
            ),
            if (role.isCurrent) _CurrentTag(label: copy.current),
            if (!desktop) period,
            Text(role.location, style: type.small),
          ],
        ),
        const SizedBox(height: 20),
        for (final product in detailed)
          _ProductRow(
            product: product,
            copy: copy,
            common: common,
            initiallyExpanded:
                expandFirstProduct && product == role.products.first,
          ),
        if (!appsGrid)
          for (final product in plain)
            _ProductRow(product: product, copy: copy, common: common),
        if (role.bullets.isNotEmpty) ...[
          const SizedBox(height: 16),
          BulletList(bullets: role.bullets),
        ],
        if (appsGrid) ...[
          const SizedBox(height: 12),
          Text(copy.appsHeading, style: type.title),
          const SizedBox(height: 12),
          _AppsGrid(products: plain, common: common),
        ],
      ],
    );
  }
}

class _EmploymentChip extends StatelessWidget {
  const _EmploymentChip({required this.label, required this.partTime});

  final String label;
  final bool partTime;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final color = partTime ? t.offline : t.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.s),
        border: Border.all(
          color: partTime ? t.offline.withValues(alpha: 0.6) : t.lineStrong,
        ),
      ),
      child: Text(
        label,
        style: context.type.small.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _CurrentTag extends StatelessWidget {
  const _CurrentTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: t.success, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: context.type.small.copyWith(
            color: t.success,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// A product line inside a role. Products with bullets expand on tap; the
/// header is the toggle, and the store links sit beside it (not inside it,
/// so they stay separate, reachable links for screen readers).
class _ProductRow extends StatefulWidget {
  const _ProductRow({
    required this.product,
    required this.copy,
    required this.common,
    this.initiallyExpanded = false,
  });

  final Product product;
  final ExperienceCopy copy;
  final CommonCopy common;
  final bool initiallyExpanded;

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  late bool _expanded = widget.initiallyExpanded;
  final _curve = SpringCurve(Springs.gentle);

  bool get _expandable => widget.product.bullets.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final product = widget.product;
    final count = product.bullets.length;
    final toggleLabel = _expanded
        ? widget.copy.hideHighlights
        : count == 1
        ? widget.copy.showHighlight
        : widget.copy.showHighlights.fill({'n': count});

    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: type.title),
        if (product.category != null) ...[
          const SizedBox(height: 2),
          Text(product.category!, style: type.small),
        ],
      ],
    );

    final header = _expandable
        ? Semantics(
            expanded: _expanded,
            child: Pressable(
              semanticLabel: '${product.name}. $toggleLabel',
              onTap: () => setState(() => _expanded = !_expanded),
              pressScale: 0.99,
              focusRadius: Radii.s,
              builder: (context, states) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1, right: 10),
                    child: AnimatedRotation(
                      turns: _expanded ? 0.25 : 0,
                      duration: _curve.duration,
                      curve: _curve,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 22,
                        color: states.contains(WidgetState.hovered)
                            ? t.text
                            : t.textMuted,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        const SizedBox(height: 6),
                        Text(
                          toggleLabel,
                          style: type.small.copyWith(
                            color: t.signalText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(padding: const EdgeInsets.only(left: 32), child: title);

    final links = StoreLinks(
      productName: product.name,
      links: product.links,
      copy: widget.common,
      compact: true,
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: t.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (context.isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: header),
                const SizedBox(width: 16),
                links,
              ],
            )
          else ...[
            header,
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.only(left: 32), child: links),
          ],
          if (_expandable)
            AnimatedSize(
              duration: context.reduceMotion ? Duration.zero : _curve.duration,
              curve: _curve,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16, left: 32),
                      child: BulletList(bullets: product.bullets),
                    )
                  : const SizedBox(width: double.infinity),
            ),
        ],
      ),
    );
  }
}

/// Compact grid of link-only apps (two columns on wide screens).
class _AppsGrid extends StatelessWidget {
  const _AppsGrid({required this.products, required this.common});

  final List<Product> products;
  final CommonCopy common;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 640;
        final width = twoColumns
            ? (constraints.maxWidth - 24) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 24,
          children: [
            for (final p in products)
              Container(
                width: width,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: t.line)),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    Text(p.name, style: context.type.label),
                    StoreLinks(
                      productName: p.name,
                      links: p.links,
                      copy: common,
                      compact: true,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
