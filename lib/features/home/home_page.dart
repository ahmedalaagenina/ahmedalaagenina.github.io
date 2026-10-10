import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/launcher.dart';
import '../../core/motion/springs.dart';
import '../../core/responsive.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_cubit.dart';
import '../../widgets/buttons.dart';
import '../../widgets/icons/brand_icons.dart';
import '../../widgets/phone_picker.dart';
import '../../widgets/toast.dart';
import '../easter_egg/debug_paint.dart';
import '../intro/intro_overlay.dart';
import 'sections/about/about_section.dart';
import 'sections/experience/experience_section.dart';
import 'sections/footer/footer.dart';
import 'sections/hero/hero_section.dart';
import 'sections/work/showcase_item.dart';
import 'sections/work/work_section.dart';
import 'shell/command_palette.dart';
import 'shell/mobile_menu.dart';
import 'shell/nav_bar.dart';
import 'shell/section_id.dart';

/// Composition root of the home page.
///
/// This is the only widget that reads `Portfolio` (the data layer). Every
/// section receives exactly the data it renders through its constructor, so
/// sections stay reusable and testable with fake content.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _identity = Portfolio.identity;
  static const _copy = Portfolio.copy;

  /// The intro plays once per visit, not every time /links navigates back.
  static bool _introPlayed = false;

  /// Resolves each showcase entry against the experience data once.
  static final List<ShowcaseItem> _showcase = [
    for (final entry in Portfolio.showcase) _resolveShowcase(entry),
  ];

  static ShowcaseItem _resolveShowcase(ShowcaseEntry entry) {
    final product = Portfolio.product(entry.productId);
    // Products without their own bullets (e.g. the Aramex apps) share the
    // role-level bullets.
    final source = product.bullets.isNotEmpty
        ? product.bullets
        : Portfolio.roleOf(entry.productId).bullets;
    return ShowcaseItem(
      entry: entry,
      product: product,
      highlights: [
        for (final i in entry.highlights)
          if (i < source.length) source[i],
      ],
    );
  }

  final _scroll = ScrollController();
  final _keys = {for (final id in SectionId.values) id: GlobalKey()};
  final _logoKey = GlobalKey();

  // Scroll-derived UI state lives in notifiers, not setState: only the
  // widgets listening to them rebuild while scrolling, never the page.
  final _scrolled = ValueNotifier(false);
  final _showBackToTop = ValueNotifier(false);
  final _active = ValueNotifier(SectionId.home);
  final _heroStart = ValueNotifier(_introPlayed);
  final _logoVisible = ValueNotifier(_introPlayed);
  late bool _showIntro = !_introPlayed;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.dispose();
    for (final n in [_scrolled, _showBackToTop, _heroStart, _logoVisible]) {
      n.dispose();
    }
    _active.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scroll.offset;
    final viewport = _scroll.position.viewportDimension;
    _scrolled.value = offset > 8;
    _showBackToTop.value = offset > viewport * 1.2;

    var current = SectionId.home;
    for (final id in SectionId.values) {
      final box = _keys[id]!.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= NavBar.height + viewport * .35) {
        current = id;
      }
    }
    _active.value = current;
  }

  void _scrollTo(SectionId id) {
    if (id == SectionId.home) return _animateTo(0);
    final box = _keys[id]!.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final top = box.localToGlobal(Offset.zero).dy;
    final target = (_scroll.offset + top - NavBar.height - 24).clamp(
      0.0,
      _scroll.position.maxScrollExtent,
    );
    _animateTo(target);
  }

  void _animateTo(double target) {
    if (context.reduceMotion) return _scroll.jumpTo(target);
    final distance = (target - _scroll.offset).abs();
    _scroll.animateTo(
      target,
      duration: Duration(
        milliseconds: (380 + distance * 0.12).clamp(380, 900).round(),
      ),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _copyEmail() async {
    await Clipboard.setData(ClipboardData(text: _identity.email));
    if (mounted) {
      showToast(
        context,
        _copy.contact.emailCopiedToast,
        icon: Icons.check_rounded,
      );
    }
  }

  void _downloadCv() => Launcher.downloadCv(_identity);

  void _whatsApp() => pickPhone(
    context,
    title: _copy.contact.whatsApp,
    subtitle: _copy.contact.chooseNumber,
    phones: _identity.phones,
    onPick: Launcher.whatsApp,
  );

  void _call() => pickPhone(
    context,
    title: _copy.contact.call,
    subtitle: _copy.contact.chooseNumber,
    phones: _identity.phones,
    onPick: Launcher.call,
  );

  void _openPalette() {
    final dark = context.isDark;
    final common = _copy.common;
    CommandPalette.show(
      context,
      copy: _copy.palette,
      groups: [
        PaletteGroup(
          title: _copy.palette.sectionsGroup,
          items: [
            for (final id in SectionId.values)
              PaletteItem(
                label: id.label(_copy.nav),
                icon: const Icon(Icons.tag_rounded),
                onSelect: () => _scrollTo(id),
              ),
          ],
        ),
        PaletteGroup(
          title: _copy.palette.actionsGroup,
          items: [
            PaletteItem(
              label: dark
                  ? _copy.palette.switchToLight
                  : _copy.palette.switchToDark,
              icon: const Icon(Icons.contrast_rounded),
              keywords: const ['theme', 'dark', 'light'],
              onSelect: () => context.read<ThemeCubit>().toggle(),
            ),
            PaletteItem(
              label: _copy.contact.copyEmail,
              hint: _identity.email,
              icon: const Icon(Icons.content_copy_rounded),
              keywords: const ['mail', 'contact'],
              onSelect: _copyEmail,
            ),
            PaletteItem(
              label: common.downloadCv,
              icon: const Icon(Icons.download_rounded),
              keywords: const ['resume', 'pdf'],
              onSelect: _downloadCv,
            ),
            PaletteItem(
              label: _copy.contact.sendEmail,
              icon: const Icon(Icons.mail_outline_rounded),
              keywords: const ['contact'],
              onSelect: () => Launcher.email(_identity.email),
            ),
            PaletteItem(
              label: _copy.contact.whatsApp,
              icon: const BrandIcon(Brand.whatsApp),
              keywords: const ['chat', 'message', 'contact'],
              onSelect: _whatsApp,
            ),
            PaletteItem(
              label: _copy.contact.call,
              icon: const Icon(Icons.call_outlined),
              keywords: const ['phone', 'contact'],
              onSelect: _call,
            ),
          ],
        ),
        PaletteGroup(
          title: _copy.palette.linksGroup,
          items: [
            PaletteItem(
              label: common.linkedIn,
              icon: const BrandIcon(Brand.linkedIn),
              onSelect: () => Launcher.open(_identity.linkedInUrl),
            ),
            PaletteItem(
              label: common.gitHub,
              icon: const BrandIcon(Brand.gitHub),
              onSelect: () => Launcher.open(_identity.gitHubUrl),
            ),
            PaletteItem(
              label: Portfolio.openSource.name,
              hint: 'pub.dev',
              icon: const BrandIcon(Brand.dart),
              onSelect: () => Launcher.open(Portfolio.openSource.pubDevUrl),
            ),
            PaletteItem(
              label: _copy.palette.openLinksPage,
              icon: const Icon(Icons.link_rounded),
              onSelect: () => context.go('/links'),
            ),
          ],
        ),
      ],
    );
  }

  void _openMenu() => showMobileMenu(
    context,
    copy: _copy.nav,
    downloadLabel: _copy.common.downloadCv,
    onSelect: _scrollTo,
    onDownloadCv: _downloadCv,
  );

  void _onLogoTap() {
    _scrollTo(SectionId.home);
    DebugPaintScope.maybeOf(context)?.registerDeveloperTap(context);
  }

  Widget _section(SectionId id, Widget child) =>
      KeyedSubtree(key: _keys[id], child: child);

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(height: context.sectionGap);

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true):
            _openPalette,
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _openPalette,
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          body: Stack(
            children: [
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: PrimaryScrollController(
                  controller: _scroll,
                  automaticallyInheritForPlatforms: TargetPlatform.values
                      .toSet(),
                  child: SingleChildScrollView(
                    primary: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _section(
                          SectionId.home,
                          HeroSection(
                            identity: _identity,
                            copy: _copy.hero,
                            start: _heroStart,
                            topInset: NavBar.height,
                            onSeeWork: () => _scrollTo(SectionId.work),
                            onDownloadCv: _downloadCv,
                          ),
                        ),
                        AboutSection(
                          copy: _copy.about,
                          summary: Portfolio.summary,
                        ),
                        gap,
                        _section(
                          SectionId.work,
                          WorkSection(
                            copy: _copy.work,
                            common: _copy.common,
                            items: _showcase,
                            scroll: _scroll,
                            navHeight: NavBar.height,
                          ),
                        ),
                        gap,
                        _section(
                          SectionId.experience,
                          ExperienceSection(
                            copy: _copy.experience,
                            common: _copy.common,
                            roles: Portfolio.roles,
                            scroll: _scroll,
                          ),
                        ),
                        gap,
                        Footer(
                          identity: _identity,
                          copy: _copy.footer,
                          onBackToTop: () => _scrollTo(SectionId.home),
                          onAllLinks: () => context.go('/links'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: NavBar(
                  logoKey: _logoKey,
                  copy: _copy.nav,
                  paletteCopy: _copy.palette,
                  logo: _identity.logo,
                  logoVisible: _logoVisible,
                  scrolled: _scrolled,
                  active: _active,
                  onSelect: _scrollTo,
                  onLogoTap: _onLogoTap,
                  onOpenPalette: _openPalette,
                  onOpenMenu: _openMenu,
                ),
              ),
              Positioned(
                right: context.gutter,
                bottom: context.gutter,
                child: _BackToTop(
                  visible: _showBackToTop,
                  label: _copy.footer.backToTop,
                  onTap: () => _scrollTo(SectionId.home),
                ),
              ),
              if (_showIntro)
                Positioned.fill(
                  child: IntroOverlay(
                    logo: _identity.logo,
                    targetKey: _logoKey,
                    onHandoff: () => _heroStart.value = true,
                    onFinished: () {
                      _introPlayed = true;
                      _heroStart.value = true;
                      _logoVisible.value = true;
                      setState(() => _showIntro = false);
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

class _BackToTop extends StatelessWidget {
  const _BackToTop({
    required this.visible,
    required this.label,
    required this.onTap,
  });

  final ValueListenable<bool> visible;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, show, child) => IgnorePointer(
        ignoring: !show,
        child: AnimatedScale(
          scale: show ? 1 : 0.6,
          duration: const Duration(milliseconds: 320),
          curve: show ? SpringCurve(Springs.playful) : Curves.easeIn,
          child: AnimatedOpacity(
            opacity: show ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: child,
          ),
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(Radii.m),
          border: Border.all(color: t.lineStrong),
        ),
        child: IconAction(
          icon: const Icon(Icons.arrow_upward_rounded),
          label: label,
          onTap: onTap,
        ),
      ),
    );
  }
}
