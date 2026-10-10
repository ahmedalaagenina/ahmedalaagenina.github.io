import '../../../data/copy.dart';

/// Every scroll target on the home page, in page order.
enum SectionId {
  home,
  work,
  experience,
  lab,
  skills,
  openSource,
  education,
  contact;

  String label(NavCopy copy) => switch (this) {
    SectionId.home => copy.home,
    SectionId.work => copy.work,
    SectionId.experience => copy.experience,
    SectionId.lab => copy.lab,
    SectionId.skills => copy.skills,
    SectionId.openSource => copy.openSource,
    SectionId.education => copy.education,
    SectionId.contact => copy.contact,
  };

  /// Sections linked from the desktop nav (the rest are reachable through
  /// the palette and the mobile menu).
  static const navItems = [work, experience, lab, skills, openSource, contact];
}
