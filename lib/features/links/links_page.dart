import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/launcher.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/icons/brand_icons.dart';
import '../../widgets/phone_picker.dart';
import '../../widgets/pressable.dart';
import '../../widgets/theme_toggle.dart';
import '../home/sections/hero/contour_field.dart';
import '../home/shell/logo_mark.dart';

/// `/links`: one URL for every channel, made for link-in-bio use.
class LinksPage extends StatefulWidget {
  const LinksPage({super.key});

  @override
  State<LinksPage> createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  final _pointer = ValueNotifier<Offset?>(null);

  @override
  void dispose() {
    _pointer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const identity = Portfolio.identity;
    const copy = Portfolio.copy;
    final t = context.tokens;
    final type = context.type;

    void pick(String title, void Function(Phone) onPick) => pickPhone(
      context,
      title: title,
      subtitle: copy.contact.chooseNumber,
      phones: identity.phones,
      onPick: onPick,
    );

    final rows = <_LinkRowData>[
      _LinkRowData(
        icon: const Icon(Icons.person_outline_rounded),
        label: copy.links.portfolio,
        subtitle: copy.links.portfolioSubtitle,
        onTap: () => context.go('/'),
      ),
      for (final link in Portfolio.quickLinks)
        _LinkRowData(
          icon: switch (link.label) {
            'LinkedIn' => const BrandIcon(Brand.linkedIn),
            'GitHub' => const BrandIcon(Brand.gitHub),
            _ => const BrandIcon(Brand.dart),
          },
          label: link.label,
          subtitle: link.subtitle,
          url: link.url,
        ),
      _LinkRowData(
        icon: const Icon(Icons.mail_outline_rounded),
        label: copy.common.email,
        subtitle: identity.email,
        onTap: () => Launcher.email(identity.email),
      ),
      _LinkRowData(
        icon: const BrandIcon(Brand.whatsApp),
        label: copy.contact.whatsApp,
        subtitle: copy.links.whatsAppSubtitle,
        onTap: () => pick(copy.contact.whatsApp, Launcher.whatsApp),
      ),
      _LinkRowData(
        icon: const Icon(Icons.call_outlined),
        label: copy.contact.call,
        subtitle: copy.links.callSubtitle,
        onTap: () => pick(copy.contact.call, Launcher.call),
      ),
      _LinkRowData(
        icon: const Icon(Icons.download_rounded),
        label: copy.common.downloadCv,
        subtitle: copy.links.cvSubtitle,
        onTap: () => Launcher.downloadCv(identity),
      ),
    ];

    return Title(
      title: '${copy.links.pageTitle} | ${identity.displayName}',
      color: t.signal,
      child: Scaffold(
        body: Listener(
          onPointerHover: (e) => _pointer.value = e.localPosition,
          onPointerMove: (e) => _pointer.value = e.localPosition,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: ContourField(pointer: _pointer, active: true),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ThemeToggle(copy: copy.palette),
                  ),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 56,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LogoMark(logo: identity.logo, fontSize: 22),
                        const SizedBox(height: 28),
                        Semantics(
                          header: true,
                          child: Text(
                            identity.displayName,
                            style: type.display,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(identity.fullTitle, style: type.body),
                        const SizedBox(height: 32),
                        for (final row in rows) ...[
                          _LinkRow(data: row),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
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

class _LinkRowData {
  const _LinkRowData({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.url,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final String subtitle;
  final String? url;
  final VoidCallback? onTap;
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.data});

  final _LinkRowData data;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    return Pressable(
      semanticLabel: '${data.label}, ${data.subtitle}',
      url: data.url,
      onTap: data.onTap,
      pressScale: 0.98,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: hovered ? t.surfaceRaised : t.surface,
            borderRadius: BorderRadius.circular(Radii.m),
            border: Border.all(color: hovered ? t.lineStrong : t.line),
          ),
          child: Row(
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  color: hovered ? t.signalText : t.text,
                  size: 20,
                ),
                child: data.icon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.label, style: type.label),
                    const SizedBox(height: 2),
                    Text(data.subtitle, style: type.small),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
