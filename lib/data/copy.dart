/// Typed containers for interface copy: section titles, button labels, toasts.
///
/// The values live in `portfolio_data.dart`; this file only defines their
/// shape. Templates use `{name}` placeholders, filled with [Fill.fill].
library;

extension Fill on String {
  /// `'{n} vehicles'.fill({'n': 200})` → `'200 vehicles'`.
  String fill(Map<String, Object> values) {
    var out = this;
    values.forEach((key, value) => out = out.replaceAll('{$key}', '$value'));
    return out;
  }
}

class SiteCopy {
  const SiteCopy({
    required this.nav,
    required this.hero,
    required this.about,
    required this.work,
    required this.experience,
    required this.lab,
    required this.skills,
    required this.openSource,
    required this.education,
    required this.contact,
    required this.footer,
    required this.palette,
    required this.common,
    required this.easterEgg,
    required this.links,
  });

  final NavCopy nav;
  final HeroCopy hero;
  final SectionCopy about;
  final WorkCopy work;
  final ExperienceCopy experience;
  final LabCopy lab;
  final SkillsCopy skills;
  final OpenSourceCopy openSource;
  final EducationCopy education;
  final ContactCopy contact;
  final FooterCopy footer;
  final PaletteCopy palette;
  final CommonCopy common;
  final EasterEggCopy easterEgg;
  final LinksCopy links;
}

class NavCopy {
  const NavCopy({
    required this.home,
    required this.work,
    required this.experience,
    required this.lab,
    required this.skills,
    required this.openSource,
    required this.education,
    required this.contact,
    required this.menu,
    required this.closeMenu,
    required this.openPalette,
    required this.homeLink,
  });

  final String home;
  final String work;
  final String experience;
  final String lab;
  final String skills;
  final String openSource;
  final String education;
  final String contact;
  final String menu;
  final String closeMenu;

  /// Tooltip template, `{shortcut}` is ⌘K or Ctrl + K.
  final String openPalette;

  /// Semantic label of the logo button.
  final String homeLink;
}

class SectionCopy {
  const SectionCopy({required this.title, this.intro});

  final String title;
  final String? intro;
}

class HeroCopy {
  const HeroCopy({
    required this.roles,
    required this.oneLiner,
    required this.primaryCta,
    required this.secondaryCta,
    required this.locationPrefix,
  });

  /// Cycled under the name.
  final List<String> roles;
  final String oneLiner;
  final String primaryCta;
  final String secondaryCta;
  final String locationPrefix;
}

class WorkCopy {
  const WorkCopy({
    required this.title,
    required this.intro,
    required this.screenLabel,
  });

  final String title;
  final String intro;

  /// Semantic label of the phone screen, `{name}` is the product.
  final String screenLabel;
}

class ExperienceCopy {
  const ExperienceCopy({
    required this.title,
    required this.fullTimeLane,
    required this.partTimeLane,
    required this.showHighlights,
    required this.showHighlight,
    required this.hideHighlights,
    required this.appsHeading,
    required this.current,
  });

  final String title;
  final String fullTimeLane;
  final String partTimeLane;

  /// `{n}` is the number of bullets.
  final String showHighlights;

  /// Used when there is exactly one bullet.
  final String showHighlight;
  final String hideHighlights;
  final String appsHeading;
  final String current;
}

class LabCopy {
  const LabCopy({
    required this.title,
    required this.intro,
    required this.loading,
    required this.fleet,
    required this.offline,
    required this.sign,
  });

  final String title;
  final String intro;
  final String loading;
  final FleetCopy fleet;
  final OfflineCopy offline;
  final SignCopy sign;
}

class DemoTabCopy {
  const DemoTabCopy({required this.tab, required this.caption});

  final String tab;
  final String caption;
}

class FleetCopy {
  const FleetCopy({
    required this.tab,
    required this.zoomIn,
    required this.zoomOut,
    required this.resetView,
    required this.vehicles,
    required this.clusters,
    required this.zoom,
    required this.hint,
    required this.mapLabel,
  });

  final DemoTabCopy tab;
  final String zoomIn;
  final String zoomOut;
  final String resetView;

  /// `{n}` templates.
  final String vehicles;
  final String clusters;
  final String zoom;
  final String hint;
  final String mapLabel;
}

class OfflineCopy {
  const OfflineCopy({
    required this.tab,
    required this.appTitle,
    required this.online,
    required this.offline,
    required this.networkLabel,
    required this.offlineBanner,
    required this.actions,
    required this.queued,
    required this.synced,
    required this.emptyQueue,
    required this.emptySynced,
    required this.syncing,
  });

  final DemoTabCopy tab;
  final String appTitle;
  final String online;
  final String offline;
  final String networkLabel;
  final String offlineBanner;
  final List<String> actions;
  final String queued;
  final String synced;
  final String emptyQueue;
  final String emptySynced;
  final String syncing;
}

class SignCopy {
  const SignCopy({
    required this.tab,
    required this.documentTitle,
    required this.pageLabel,
    required this.field,
    required this.dragHint,
    required this.sign,
    required this.reset,
    required this.coordinates,
    required this.fieldSemantics,
  });

  final DemoTabCopy tab;
  final String documentTitle;
  final String pageLabel;
  final String field;
  final String dragHint;
  final String sign;
  final String reset;

  /// `{x}` and `{y}` in PDF points.
  final String coordinates;

  /// Screen reader label for the draggable field.
  final String fieldSemantics;
}

class SkillsCopy {
  const SkillsCopy({required this.title, required this.usedIn});

  final String title;

  /// `{skill}` and `{places}`.
  final String usedIn;
}

class OpenSourceCopy {
  const OpenSourceCopy({
    required this.title,
    required this.pubDev,
    required this.gitHub,
    required this.replay,
    required this.terminalLabel,
  });

  final String title;
  final String pubDev;
  final String gitHub;
  final String replay;
  final String terminalLabel;
}

class EducationCopy {
  const EducationCopy({
    required this.title,
    required this.certifications,
    required this.languages,
    required this.recognition,
  });

  final String title;
  final String certifications;
  final String languages;
  final String recognition;
}

class ContactCopy {
  const ContactCopy({
    required this.headline,
    required this.copyEmail,
    required this.copied,
    required this.emailCopiedToast,
    required this.sendEmail,
    required this.whatsApp,
    required this.call,
    required this.phonesHeading,
    required this.chooseNumber,
  });

  final String headline;
  final String copyEmail;
  final String copied;
  final String emailCopiedToast;
  final String sendEmail;
  final String whatsApp;
  final String call;
  final String phonesHeading;
  final String chooseNumber;
}

class FooterCopy {
  const FooterCopy({
    required this.rights,
    required this.builtWith,
    required this.paletteHint,
    required this.backToTop,
    required this.allLinks,
  });

  /// `{year}` and `{name}`.
  final String rights;
  final String builtWith;

  /// `{shortcut}`.
  final String paletteHint;
  final String backToTop;
  final String allLinks;
}

class PaletteCopy {
  const PaletteCopy({
    required this.searchHint,
    required this.sectionsGroup,
    required this.actionsGroup,
    required this.linksGroup,
    required this.noMatches,
    required this.switchToLight,
    required this.switchToDark,
    required this.openLinksPage,
  });

  final String searchHint;
  final String sectionsGroup;
  final String actionsGroup;
  final String linksGroup;
  final String noMatches;
  final String switchToLight;
  final String switchToDark;
  final String openLinksPage;
}

/// Labels reused across sections.
class CommonCopy {
  const CommonCopy({
    required this.appStore,
    required this.googlePlay,
    required this.web,
    required this.admin,
    required this.ios,
    required this.android,
    required this.noPublicLink,
    required this.openOn,
    required this.downloadCv,
    required this.linkedIn,
    required this.gitHub,
    required this.email,
  });

  final String appStore;
  final String googlePlay;
  final String web;
  final String admin;

  /// Plain labels for platforms that have no public link.
  final String ios;
  final String android;

  /// `{platform}`.
  final String noPublicLink;

  /// `{name}` and `{platform}`.
  final String openOn;
  final String downloadCv;
  final String linkedIn;
  final String gitHub;
  final String email;
}

class EasterEggCopy {
  const EasterEggCopy({
    required this.stepsAway,
    required this.enabled,
    required this.disabled,
  });

  /// `{n}` taps left.
  final String stepsAway;
  final String enabled;
  final String disabled;
}

class LinksCopy {
  const LinksCopy({
    required this.pageTitle,
    required this.portfolio,
    required this.portfolioSubtitle,
    required this.whatsAppSubtitle,
    required this.callSubtitle,
    required this.cvSubtitle,
  });

  final String pageTitle;
  final String portfolio;
  final String portfolioSubtitle;
  final String whatsAppSubtitle;
  final String callSubtitle;
  final String cvSubtitle;
}
