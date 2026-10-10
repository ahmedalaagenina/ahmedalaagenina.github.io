import 'package:flutter/material.dart';

import '../../../../core/responsive.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/icons/brand_icons.dart';
import '../../../../widgets/motion/visibility_gate.dart';
import '../../../../widgets/terminal_typing.dart';

class OpenSourceSection extends StatefulWidget {
  const OpenSourceSection({
    super.key,
    required this.copy,
    required this.package,
  });

  final OpenSourceCopy copy;
  final OpenSourcePackage package;

  @override
  State<OpenSourceSection> createState() => _OpenSourceSectionState();
}

class _OpenSourceSectionState extends State<OpenSourceSection> {
  int _replay = 0;

  @override
  Widget build(BuildContext context) {
    final type = context.type;
    final t = context.tokens;
    final p = widget.package;
    final copy = widget.copy;

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(header: true, child: Text(copy.title, style: type.display)),
        const SizedBox(height: 28),
        Text(
          p.name,
          style: type.mono.copyWith(
            fontSize: context.pick(22, desktop: 26),
            color: t.text,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(p.description, style: type.lead),
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppButton(
              label: copy.pubDev,
              url: p.pubDevUrl,
              icon: const BrandIcon(Brand.dart),
            ),
            AppButton(
              label: copy.gitHub,
              url: p.githubUrl,
              tone: ButtonTone.secondary,
              icon: const BrandIcon(Brand.gitHub),
            ),
          ],
        ),
      ],
    );

    final terminal = VisibilityGate(
      threshold: 0.4,
      builder: (context, visible) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TerminalTyping(
            command: p.installCommand,
            output: p.installOutput,
            semanticLabel: copy.terminalLabel.fill({
              'command': p.installCommand,
            }),
            play: visible,
            replayKey: _replay,
          ),
          const SizedBox(height: 10),
          IconAction(
            icon: const Icon(Icons.replay_rounded),
            label: copy.replay,
            onTap: () => setState(() => _replay++),
          ),
        ],
      ),
    );

    return MaxWidth(
      child: context.isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: info),
                const SizedBox(width: 64),
                Expanded(child: terminal),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [info, const SizedBox(height: 36), terminal],
            ),
    );
  }
}
