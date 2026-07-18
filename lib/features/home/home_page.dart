import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/launcher.dart';
import '../../core/responsive.dart';
import '../../data/cv_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/command_palette.dart';
import 'widgets/contact_section.dart';
import 'widgets/education_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/footer.dart';
import 'widgets/hero_section.dart';
import 'widgets/nav_bar.dart';
import 'widgets/open_source_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/stats_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll = ScrollController();

  final _heroKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _openSourceKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _contactKey = GlobalKey();

  bool _scrolled = false;
  bool _heroVisible = true;
  String _activeSection = 'Home';

  late final List<NavItem> _navItems = [
    NavItem(label: 'Home', targetKey: _heroKey),
    NavItem(label: 'Experience', targetKey: _experienceKey),
    NavItem(label: 'Projects', targetKey: _projectsKey),
    NavItem(label: 'Skills', targetKey: _skillsKey),
    NavItem(label: 'Education', targetKey: _educationKey),
    NavItem(label: 'Contact', targetKey: _contactKey),
  ];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scroll.offset;
    final vh = _heroKey.currentContext?.size?.height ?? 800;

    final scrolled = offset > 12;
    final heroVisible = offset < vh;
    if (scrolled != _scrolled || heroVisible != _heroVisible) {
      setState(() {
        _scrolled = scrolled;
        _heroVisible = heroVisible;
      });
    }
    _updateActiveSection();
  }

  void _updateActiveSection() {
    String active = _navItems.first.label;
    for (final item in _navItems) {
      final ctx = item.targetKey.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= 120) active = item.label;
    }
    if (active != _activeSection) {
      setState(() => _activeSection = active);
    }
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeInOutCubic,
    );
  }

  void _openPalette() {
    CommandPalette.show(context, [
      for (final item in _navItems)
        CommandItem(
          label: item.label,
          hint: 'Section',
          icon: FontAwesomeIcons.arrowRight,
          action: () => _scrollTo(item.targetKey),
        ),
      CommandItem(
        label: 'Quick Links',
        hint: 'Page',
        icon: FontAwesomeIcons.link,
        action: () => context.go('/links'),
      ),
      CommandItem(
        label: 'Download CV',
        hint: 'PDF',
        icon: FontAwesomeIcons.fileArrowDown,
        action: () => Launcher.open(CV.cvUrl),
      ),
      CommandItem(
        label: 'GitHub',
        hint: 'External',
        icon: FontAwesomeIcons.github,
        action: () => Launcher.open(CV.githubUrl),
      ),
      CommandItem(
        label: 'LinkedIn',
        hint: 'External',
        icon: FontAwesomeIcons.linkedinIn,
        action: () => Launcher.open(CV.linkedinUrl),
      ),
      CommandItem(
        label: 'Send Email',
        hint: CV.email,
        icon: FontAwesomeIcons.envelope,
        action: Launcher.email,
      ),
      CommandItem(
        label: 'WhatsApp',
        hint: 'Chat',
        icon: FontAwesomeIcons.whatsapp,
        action: () => Launcher.whatsapp(context),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final sectionGap = context.pick(desktop: 110.0, mobile: 72.0);

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
          backgroundColor: t.background,
          floatingActionButton: _scrolled
              ? FloatingActionButton.small(
                  onPressed: () => _scrollTo(_heroKey),
                  backgroundColor: t.surface,
                  foregroundColor: t.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: t.glassBorder),
                  ),
                  child: const Icon(Icons.keyboard_arrow_up_rounded),
                )
              : null,
          body: Stack(
            children: [
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KeyedSubtree(
                        key: _heroKey,
                        child: HeroSection(
                          particlesActive: _heroVisible,
                          onViewWork: () => _scrollTo(_projectsKey),
                          onContact: () => _scrollTo(_contactKey),
                        ),
                      ),
                      const StatsSection(),
                      SizedBox(height: sectionGap),
                      KeyedSubtree(
                        key: _experienceKey,
                        child: const ExperienceSection(),
                      ),
                      SizedBox(height: sectionGap),
                      KeyedSubtree(
                        key: _projectsKey,
                        child: const ProjectsSection(),
                      ),
                      SizedBox(height: sectionGap),
                      KeyedSubtree(
                        key: _skillsKey,
                        child: const SkillsSection(),
                      ),
                      SizedBox(height: sectionGap),
                      KeyedSubtree(
                        key: _openSourceKey,
                        child: const OpenSourceSection(),
                      ),
                      SizedBox(height: sectionGap),
                      KeyedSubtree(
                        key: _educationKey,
                        child: const EducationSection(),
                      ),
                      SizedBox(height: sectionGap),
                      KeyedSubtree(
                        key: _contactKey,
                        child: const ContactSection(),
                      ),
                      SizedBox(height: sectionGap),
                      const Footer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: NavBar(
                  items: _navItems,
                  scrolled: _scrolled,
                  activeSection: _activeSection,
                  onTapItem: (item) => _scrollTo(item.targetKey),
                  onOpenPalette: _openPalette,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
