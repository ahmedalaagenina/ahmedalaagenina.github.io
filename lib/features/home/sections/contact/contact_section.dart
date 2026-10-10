import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/motion/springs.dart';
import '../../../../core/responsive.dart';
import '../../../../data/portfolio_data.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/icons/brand_icons.dart';
import '../../../../widgets/motion/magnetic.dart';
import '../../../../widgets/pressable.dart';

/// The closing screen: one bold statement, the email front and center with
/// a copy action, then every other channel.
class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    required this.copy,
    required this.common,
    required this.identity,
    required this.onSendEmail,
    required this.onWhatsApp,
    required this.onCall,
    required this.onDownloadCv,
  });

  final ContactCopy copy;
  final CommonCopy common;
  final Identity identity;
  final VoidCallback onSendEmail;
  final VoidCallback onWhatsApp;
  final VoidCallback onCall;
  final VoidCallback onDownloadCv;

  @override
  Widget build(BuildContext context) {
    final type = context.type;
    final t = context.tokens;
    return MaxWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Semantics(
              header: true,
              child: Text(copy.headline, style: type.statement),
            ),
          ),
          SizedBox(height: context.pick(36, desktop: 52)),
          Magnetic(
            maxOffset: 6,
            child: _EmailCapsule(email: identity.email, copy: copy),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              AppButton(
                label: copy.sendEmail,
                tone: ButtonTone.secondary,
                icon: const Icon(Icons.mail_outline_rounded),
                onTap: onSendEmail,
              ),
              AppButton(
                label: copy.whatsApp,
                tone: ButtonTone.secondary,
                icon: const BrandIcon(Brand.whatsApp),
                onTap: onWhatsApp,
              ),
              AppButton(
                label: copy.call,
                tone: ButtonTone.secondary,
                icon: const Icon(Icons.call_outlined),
                onTap: onCall,
              ),
              AppButton(
                label: common.linkedIn,
                tone: ButtonTone.secondary,
                icon: const BrandIcon(Brand.linkedIn),
                url: identity.linkedInUrl,
              ),
              AppButton(
                label: common.gitHub,
                tone: ButtonTone.secondary,
                icon: const BrandIcon(Brand.gitHub),
                url: identity.gitHubUrl,
              ),
              AppButton(
                label: common.downloadCv,
                tone: ButtonTone.secondary,
                icon: const Icon(Icons.download_rounded),
                onTap: onDownloadCv,
              ),
            ],
          ),
          const SizedBox(height: 36),
          SelectionArea(
            child: Wrap(
              spacing: 32,
              runSpacing: 10,
              children: [
                for (final phone in identity.phones)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '${phone.label}  '),
                        TextSpan(
                          text: phone.display,
                          style: TextStyle(color: t.text),
                        ),
                      ],
                    ),
                    style: type.mono.copyWith(fontSize: 14),
                  ),
                Text(identity.location, style: type.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The email address with a copy button attached. On copy, the icon morphs
/// into a check and the label says "Copied" for a moment; the label is a
/// live region, so screen readers announce it too.
class _EmailCapsule extends StatefulWidget {
  const _EmailCapsule({required this.email, required this.copy});

  final String email;
  final ContactCopy copy;

  @override
  State<_EmailCapsule> createState() => _EmailCapsuleState();
}

class _EmailCapsuleState extends State<_EmailCapsule> {
  bool _copied = false;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.email));
    HapticFeedback.lightImpact();
    if (!mounted) return;
    setState(() => _copied = true);
    _reset?.cancel();
    _reset = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final type = context.type;
    final curve = SpringCurve(Springs.playful);
    final accent = _copied ? t.success : t.signal;

    return Pressable(
      semanticLabel: '${widget.copy.copyEmail}: ${widget.email}',
      onTap: _copy,
      pressScale: 0.98,
      focusRadius: Radii.l,
      builder: (context, states) {
        final hovered = states.contains(WidgetState.hovered);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.fromLTRB(22, 14, 14, 14),
          decoration: BoxDecoration(
            color: hovered ? t.surfaceRaised : t.surface,
            borderRadius: BorderRadius.circular(Radii.l),
            border: Border.all(
              color: _copied
                  ? t.success
                  : (hovered ? t.signalText : t.lineStrong),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.email,
                    style: type.headline.copyWith(
                      fontSize: context.pick(18, tablet: 22, desktop: 26),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(Radii.m),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: curve.duration,
                      switchInCurve: curve,
                      transitionBuilder: (child, animation) =>
                          RotationTransition(
                            turns: Tween(
                              begin: -0.15,
                              end: 0.0,
                            ).animate(animation),
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          ),
                      child: Icon(
                        _copied
                            ? Icons.check_rounded
                            : Icons.content_copy_rounded,
                        key: ValueKey(_copied),
                        size: 18,
                        color: accent,
                      ),
                    ),
                    if (!context.isMobile) ...[
                      const SizedBox(width: 8),
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _copied ? widget.copy.copied : widget.copy.copyEmail,
                          style: type.label.copyWith(color: accent),
                        ),
                      ),
                    ],
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
