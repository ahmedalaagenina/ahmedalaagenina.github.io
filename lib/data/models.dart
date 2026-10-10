/// Plain, immutable content models.
///
/// No Flutter imports on purpose: the data layer describes *what* the site
/// says, never *how* it looks. Widgets receive these objects through their
/// constructors, which keeps every section testable with fake data.
library;

/// Where an app can be opened.
enum LinkKind { ios, android, web, admin }

/// One platform of a product. A null [url] means the platform exists but has
/// no public link (the UI renders it as a plain label, not a button).
class StoreLink {
  const StoreLink(this.kind, [this.url]);

  final LinkKind kind;
  final String? url;

  bool get hasUrl => url != null;
}

/// A product line inside a role, e.g. "iDara Sign".
class Product {
  const Product({
    required this.id,
    required this.name,
    this.category,
    this.links = const [],
    this.bullets = const [],
  });

  /// Stable id used to reference the product from the showcase.
  final String id;
  final String name;

  /// Short descriptor shown next to the name, e.g. "E-Signature Platform".
  final String? category;
  final List<StoreLink> links;
  final List<String> bullets;
}

enum Employment { fullTime, partTime }

class Role {
  const Role({
    required this.title,
    required this.company,
    required this.period,
    required this.location,
    required this.employment,
    required this.employmentLabel,
    this.isCurrent = false,
    this.products = const [],
    this.bullets = const [],
  });

  final String title;
  final String company;
  final String period;
  final String location;

  /// Drives the timeline lane: full-time roles sit on the solid main line,
  /// part-time roles on the parallel dashed lane.
  final Employment employment;

  /// Exact label shown on the card, e.g. "Part-Time".
  final String employmentLabel;
  final bool isCurrent;
  final List<Product> products;

  /// Role-level bullets that apply to every product of the role.
  final List<String> bullets;
}

/// A skill plus extra terms used to find it in the experience text, so the
/// skills section can show where each skill was used.
class Skill {
  const Skill(this.name, {this.alsoMatches = const []});

  final String name;
  final List<String> alsoMatches;

  List<String> get terms => [name, ...alsoMatches];
}

class SkillGroup {
  const SkillGroup({required this.title, required this.skills});

  final String title;
  final List<Skill> skills;
}

class Education {
  const Education({
    required this.title,
    required this.institution,
    required this.period,
    this.detail,
    this.note,
  });

  final String title;
  final String institution;
  final String period;

  /// Secondary line under the institution.
  final String? detail;
  final EducationNote? note;
}

class EducationNote {
  const EducationNote({required this.label, required this.text});

  final String label;
  final String text;
}

class Certification {
  const Certification({required this.name, required this.issuer});

  final String name;
  final String issuer;
}

class Language {
  const Language({required this.name, required this.level});

  final String name;
  final String level;
}

class Recognition {
  const Recognition({required this.title, required this.detail});

  final String title;
  final String detail;
}

class OpenSourcePackage {
  const OpenSourcePackage({
    required this.name,
    required this.description,
    required this.pubDevUrl,
    required this.githubUrl,
    required this.installCommand,
    required this.installOutput,
  });

  final String name;
  final String description;
  final String pubDevUrl;
  final String githubUrl;

  /// Typed out in the terminal card.
  final String installCommand;

  /// Lines printed after the command finishes. The last one is the success
  /// line.
  final List<String> installOutput;
}

class Phone {
  const Phone({required this.label, required this.display, required this.e164});

  /// e.g. "KSA".
  final String label;

  /// Human formatting, e.g. "+966 50 850 9042".
  final String display;

  /// Dialable form, e.g. "+966508509042".
  final String e164;
}

class Identity {
  const Identity({
    required this.fullName,
    required this.displayName,
    required this.logo,
    required this.title,
    required this.specialty,
    required this.location,
    required this.email,
    required this.phones,
    required this.linkedInUrl,
    required this.gitHubUrl,
    required this.siteUrl,
    required this.cvPath,
    required this.cvFileName,
  });

  final String fullName;
  final String displayName;

  /// Monogram used by the loader and the nav, e.g. `<AA />`.
  final String logo;
  final String title;
  final String specialty;
  final String location;
  final String email;
  final List<Phone> phones;
  final String linkedInUrl;
  final String gitHubUrl;
  final String siteUrl;

  /// Path of the CV PDF relative to the site root (served from `web/`).
  final String cvPath;

  /// File name used when the visitor downloads the CV.
  final String cvFileName;

  String get fullTitle => '$title $specialty';
}

/// One phone-showcase entry. It points at a [Product] by id so the name,
/// category, bullets and links are never duplicated.
class ShowcaseEntry {
  const ShowcaseEntry({
    required this.productId,
    required this.company,
    required this.icon,
    required this.tint,
    this.screens = const [],
    this.screensStartBelowStatusBar = false,
    this.screenBackground = 0xFFFFFFFF,
    this.highlights = const [0],
  });

  final String productId;

  /// Company shown above the product name.
  final String company;

  /// App icon asset (the real store artwork).
  final String icon;

  /// Brand tint (ARGB) used for the designed screen when there are no
  /// screenshots, and for the phone's glow.
  final int tint;

  /// Screenshot assets. Empty means a designed cover screen (icon + name),
  /// never fake UI.
  final List<String> screens;

  /// True when the screenshots were cropped below the status bar, so the
  /// phone fills the top with [screenBackground].
  final bool screensStartBelowStatusBar;
  final int screenBackground;

  /// Indexes of the product bullets (or role bullets when the product has
  /// none) shown beside the phone.
  final List<int> highlights;
}

class QuickLink {
  const QuickLink({
    required this.label,
    required this.subtitle,
    required this.url,
  });

  final String label;
  final String subtitle;
  final String url;
}
