/// ════════════════════════════════════════════════════════════════════
///  YOUR CV DATA — THE ONLY FILE YOU NEED TO EDIT
///
///  Every section of the website renders from this file.
///  Update it, push to main, and CI/CD deploys automatically.
///
///  Search for "TODO" to find missing store links.
/// ════════════════════════════════════════════════════════════════════
library;

// ─── Models ───────────────────────────────────────────────────────────

enum AppPlatform { ios, android, web }

class ProjectApp {
  final String name;
  final String company;
  final String description;
  final List<AppPlatform> platforms;
  final String? iosUrl;
  final String? androidUrl;
  final String? webUrl;

  /// Link to an admin dashboard / control panel, if the product has one.
  /// Badges only render for non-null links, so leaving this null hides it.
  final String? adminUrl;
  final bool featured;

  const ProjectApp({
    required this.name,
    this.company = '',
    required this.description,
    required this.platforms,
    this.iosUrl,
    this.androidUrl,
    this.webUrl,
    this.adminUrl,
    this.featured = false,
  });
}

class ExperienceRecord {
  final String company;
  final String role;
  final String period;
  final String location;
  final bool isCurrent;
  final bool isPartTime;

  /// Optional grouping: bullets per project inside the company.
  final List<ExperienceProject> projects;

  const ExperienceRecord({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    this.isCurrent = false,
    this.isPartTime = false,
    required this.projects,
  });
}

class ExperienceProject {
  final String name;
  final List<String> bullets;

  const ExperienceProject({required this.name, required this.bullets});
}

class SkillCategory {
  final String title;
  final List<String> skills;

  const SkillCategory({required this.title, required this.skills});
}

class OpenSourceProject {
  final String name;
  final String description;
  final String url;
  final String tag;

  const OpenSourceProject({
    required this.name,
    required this.description,
    required this.url,
    required this.tag,
  });
}

class EducationRecord {
  final String degree;
  final String institution;
  final String period;

  const EducationRecord({
    required this.degree,
    required this.institution,
    required this.period,
  });
}

class StatRecord {
  final int value;
  final String suffix;
  final String label;

  const StatRecord({
    required this.value,
    this.suffix = '+',
    required this.label,
  });
}

class QuickLink {
  final String label;
  final String subtitle;
  final String url;

  const QuickLink({
    required this.label,
    required this.subtitle,
    required this.url,
  });
}

// ─── Data ─────────────────────────────────────────────────────────────

abstract final class CV {
  // ── Identity ────────────────────────────────────────────────────────
  static const String name = 'Ahmed AlaaEldin Atia';
  static const String shortName = 'Ahmed Alaa';
  static const String initials = 'AA';
  static const String title = 'Senior Mobile Engineer';
  static const String subtitle = 'Flutter | Android';
  static const String location = 'Saudi Arabia';

  /// Roles cycled by the typewriter in the hero section.
  static const List<String> heroRoles = [
    'Senior Mobile Engineer',
    'Flutter Expert',
    'Android Developer',
    'Team Lead',
    'Open Source Author',
  ];

  static const String summary =
      'Senior Mobile Engineer with 6+ years of experience and a proven track '
      'record of delivering 17+ production apps across fintech, logistics, '
      'healthcare, education, and government sectors. Expert in Flutter, '
      'Android, and Clean Architecture, with deep experience designing '
      'offline-first systems, secure payment flows, and scalable multi-role '
      'platforms. Builds and publishes open-source packages (pub.dev) and '
      'leads technical decision-making from concept through release.';

  // ── Contact ─────────────────────────────────────────────────────────
  static const String email = 'ahmedalaagenina@gmail.com';

  /// Multiple phone numbers → the UI shows a picker for Call / WhatsApp.
  static const List<({String label, String number})> phones = [
    (label: 'Saudi Arabia', number: '+966508509042'),
    (label: 'Egypt', number: '+201096796900'),
  ];

  static const String linkedinUrl =
      'https://www.linkedin.com/in/ahmedalaagenina';
  static const String githubUrl = 'https://github.com/AhmedAlaaGenina';
  static const String pubDevUrl = 'https://pub.dev/publishers/ahmedalaa.dev';

  /// Link to your CV on Google Drive (share → "Anyone with the link").
  static const String cvUrl =
      'https://drive.google.com/file/d/1k2GvxDL2WYdCMx-EZevlhW_xU20EAI5v/view?usp=drive_link';

  // ── Hero stats (animated counters) ──────────────────────────────────
  static const List<StatRecord> stats = [
    StatRecord(value: 6, label: 'Years of Experience'),
    StatRecord(value: 17, label: 'Production Apps'),
    StatRecord(value: 5, label: 'Industries Served'),
    StatRecord(value: 10, suffix: 'K+', label: 'Daily Users Supported'),
  ];

  // ── Experience ──────────────────────────────────────────────────────
  static const List<ExperienceRecord> experience = [
    ExperienceRecord(
      company: 'IDaraNet',
      role: 'Senior Software Engineer',
      period: 'Feb 2026 – Present',
      location: 'Saudi Arabia',
      isCurrent: true,
      projects: [
        ExperienceProject(
          name:
              'iDara Sign — E-Signature Platform (iOS | Android | Web | Admin)',
          bullets: [
            'Leading architecture and development of a multi-role document '
                'workflow system spanning mobile and Flutter Web, using Clean '
                'Architecture, BLoC, GoRouter, and GetIt.',
            'Engineered an offline-first caching architecture (Dio interceptor '
                '+ Hive) with read/write request splitting and optimistic local '
                'execution, reducing live-API calls by 40% through cache-first reads.',
            'Designed a cross-app duplicate-request prevention system (custom '
                'interceptor + BLoC-level guard) across 2 apps, eliminating '
                'duplicate-submission incidents from repeated taps and network retries.',
            'Built a continuous PDF signing experience (pdfrx) with draggable '
                'signature-field placement across multi-page documents, cutting '
                'signing-flow crash reports by 100%.',
            'Designed deep linking and App/Web fallback strategies for seamless '
                'cross-platform sign-in and document-signing journeys.',
            'Owned the release lifecycle end-to-end — code review through App '
                'Store and Google Play submission, managing privacy labels, OTP '
                'review requirements, and deeplink configuration.',
          ],
        ),
        ExperienceProject(
          name: 'iDara Trip — Trip Management Platform (iOS | Android)',
          bullets: [
            'Architected a multi-role trip management system using modular MVVM '
                'and Provider, establishing scalable engineering standards for '
                'vehicle workflows.',
            'Engineered mission-critical features including session persistence, '
                'auto-recovery flows, and role-based navigation for '
                'cross-platform reliability.',
          ],
        ),
      ],
    ),
    ExperienceRecord(
      company: 'CyShield',
      role: 'Software Engineer I',
      period: 'Jan 2025 – Feb 2026',
      location: 'Egypt',
      projects: [
        ExperienceProject(
          name: 'HR App Management Platform (iOS | Android)',
          bullets: [
            'Architected a modular HR platform supporting ticketing, RFC, '
                'reservations, attendance, and additional workflow modules.',
            'Led modernization of legacy modules into Clean Architecture, '
                'improving maintainability by 60%.',
            'Conducted code reviews, ensuring architectural consistency across '
                'the mobile team.',
          ],
        ),
      ],
    ),
    ExperienceRecord(
      company: 'Aramex International',
      role: 'Software Engineer',
      period: 'Oct 2022 – Jan 2025',
      location: 'Egypt',
      projects: [
        ExperienceProject(
          name: 'Champion App (Courier Ops) & Freight App (Truck Management)',
          bullets: [
            'Architected a full offline-first synchronization engine, ensuring '
                '100% data integrity and seamless operation for couriers in '
                'zero-connectivity zones.',
            'Bridged native Driver SDKs (Kotlin/Swift) into Flutter via Platform '
                'Channels, enabling advanced telematics and real-time mapping '
                'for 10K+ daily activities.',
            'Reduced device battery consumption by 15% by optimizing location '
                'polling and background sync logic, maintaining 99.9% app uptime.',
            'Engineered secure multi-payment workflows and real-time '
                'notification systems for high-concurrency courier and freight '
                'operations.',
          ],
        ),
      ],
    ),
    ExperienceRecord(
      company: 'SanadRewards',
      role: 'Software Engineering Team Lead',
      period: 'Dec 2022 – Present',
      location: 'Egypt',
      isCurrent: true,
      isPartTime: true,
      projects: [
        ExperienceProject(
          name: 'SanadRewards — Gamified Health & Rewards (iOS | Android)',
          bullets: [
            'Leading a cross-functional team (Mobile, Backend, UI/UX), driving '
                'sprint execution.',
            'Architected HealthKit / Google Health Connect integrations with '
                'sensors and rewards logic.',
            'Mentoring engineers and aligning the technical roadmap with '
                'business strategy.',
          ],
        ),
      ],
    ),
    ExperienceRecord(
      company: 'Alrazi',
      role: 'Senior Software Engineer',
      period: 'Sept 2023 – Jan 2026',
      location: 'Jordan',
      isPartTime: true,
      projects: [
        ExperienceProject(
          name: 'Stylee — Fashion E-commerce Marketplace (iOS | Android | Web)',
          bullets: [
            'Built buying, renting, and listing features with secure payment '
                'integration.',
          ],
        ),
        ExperienceProject(
          name: 'Alrazi Education Platform (iOS | Android | Web)',
          bullets: [
            'Integrated a ChatGPT assistant, video streaming, TTS, and '
                'assessment systems.',
            'Built the complete backend using Firebase and Cloud Functions.',
          ],
        ),
      ],
    ),
    ExperienceRecord(
      company: 'One Solution',
      role: 'Flutter Developer',
      period: 'Jan 2021 – Jun 2023',
      location: 'Egypt',
      projects: [
        ExperienceProject(
          name: '9+ Production Apps',
          bullets: [
            'Delivered 9+ production apps across health, e-commerce, education, '
                'booking, and government sectors, including Macro, Challenge '
                'Center, Light Options, Let\'s Diet, One Edu, Yabila Chalet, '
                'Al-Sibiya Station, and Makkah Region Development Authority '
                'platforms.',
          ],
        ),
      ],
    ),
  ];

  // ── App Portfolio (the projects grid) ───────────────────────────────
  static const List<ProjectApp> projects = [
    ProjectApp(
      name: 'iDara Sign',
      company: 'IDaraNet',
      description:
          'Multi-role e-signature platform (iOS, Android, Web + Admin) with '
          'offline-first caching, continuous PDF signing, and deep-linked '
          'App/Web journeys.',
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      featured: true,
      iosUrl: 'https://apps.apple.com/us/app/idara-sign/id6759380839',
      androidUrl:
          'https://play.google.com/store/apps/details?id=net.idara.sign',
      webUrl: 'https://sign.idara.sa',
      adminUrl: 'https://sign.idara.sa/admin',
    ),
    ProjectApp(
      name: 'iDara Trip',
      company: 'IDaraNet',
      description:
          'Multi-role trip management with session persistence, auto-recovery '
          'flows, and role-based navigation.',
      platforms: [AppPlatform.ios, AppPlatform.android],
      featured: true,
      iosUrl: 'https://apps.apple.com/us/app/idara-trip/id6760389320',
      androidUrl:
          'https://play.google.com/store/apps/details?id=net.idara.trip',
    ),
    ProjectApp(
      name: 'Aramex Champion',
      company: 'Aramex International',
      description:
          'Courier operations platform with offline-first sync, telematics, '
          'real-time mapping, and multi-payment workflows.',
      platforms: [AppPlatform.ios, AppPlatform.android],
      featured: true,
      iosUrl: 'https://apps.apple.com/us/app/delivery-champions/id6502755328',
      // TODO: ADD Aramex Champion GOOGLE PLAY LINK HERE
      androidUrl: null,
    ),
    ProjectApp(
      name: 'Aramex Freight',
      company: 'Aramex International',
      description:
          'Truck management platform with real-time updates and '
          'high-concurrency freight operations.',
      platforms: [AppPlatform.ios, AppPlatform.android],
      featured: true,
      iosUrl: 'https://apps.apple.com/us/app/aramex-freight-app/id6479978455',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.aramex.truckqueuingapp',
    ),
    ProjectApp(
      name: 'HR Platform',
      company: 'CyShield',
      description:
          'Modular HR platform: ticketing, RFC, reservations, and attendance '
          'workflows in Clean Architecture.',
      platforms: [AppPlatform.ios, AppPlatform.android],
      featured: true,
      // TODO: ADD CyShield HR APP STORE LINK HERE
      iosUrl: null,
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.cyapps.hr_app',
    ),
    ProjectApp(
      name: 'SanadRewards',
      company: 'SanadRewards',
      description:
          'Gamified health & rewards platform with HealthKit / Google Health '
          'Connect integrations.',
      platforms: [AppPlatform.ios, AppPlatform.android],
      featured: true,
      iosUrl: 'https://apps.apple.com/eg/app/sanad-rewards/id6448073834',
      androidUrl: 'https://play.google.com/store/apps/details?id=com.ubd.sanad',
    ),
    ProjectApp(
      name: 'Stylee',
      company: 'Alrazi',
      description:
          'Fashion e-commerce marketplace with buying, renting, listing, and '
          'secure payments.',
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      featured: true,
      iosUrl:
          'https://apps.apple.com/eg/app/stylee-rent-buy-and-earn/id6499165037',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.yousef.stylee',
      webUrl: 'https://fashion-ae0a0.web.app/#/auth',
    ),
    ProjectApp(
      name: 'Alrazi Education',
      company: 'Alrazi',
      description:
          'AI-powered education platform with ChatGPT assistant, video '
          'streaming, TTS, and assessments.',
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      featured: true,
      iosUrl:
          'https://apps.apple.com/eg/app/alrazi-%D8%A7%D9%84%D8%B1%D8%A7%D8%B2%D9%8A/id6445819822',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.yousef.sciophile',
      webUrl: 'https://alrazi-academy.com/#/landing',
    ),
    ProjectApp(
      name: 'Macro',
      company: 'One Solution',
      description: 'Health & nutrition platform.',
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      iosUrl: 'https://apps.apple.com/kw/app/try-macro/id1602597534',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.onesolution.macroapp',
      webUrl: 'https://trymacro.com/',
    ),
    ProjectApp(
      name: 'Challenge Center',
      company: 'One Solution',
      description: 'Health & nutrition application.',
      platforms: [AppPlatform.ios, AppPlatform.android],
      iosUrl: 'https://apps.apple.com/kw/app/challenge-center/id1602439876',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.onesolution.challenge',
    ),
    ProjectApp(
      name: 'Light Options',
      company: 'One Solution',
      description: 'Health & nutrition tracking.',
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      iosUrl: 'https://apps.apple.com/kw/app/light-options/id1614157720',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.onesolution.light_option',
      webUrl: 'http://3.251.4.121/',
    ),
    ProjectApp(
      name: "Let's Diet",
      company: 'One Solution',
      description: 'Health & nutrition planning.',
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      iosUrl: 'https://apps.apple.com/eg/app/lets-diet/id1598732448',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.onesolutionc.lets_diet',
      webUrl: 'http://3.134.54.171/',
    ),
    ProjectApp(
      name: 'One Edu',
      company: 'One Solution',
      description: 'School management system.',
      platforms: [AppPlatform.ios, AppPlatform.android],
      iosUrl: 'https://apps.apple.com/kw/app/one-edu/id1614161401',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.onesolutionc.one_edu',
    ),
    ProjectApp(
      name: 'Yabila Chalet',
      company: 'One Solution',
      description: 'Booking platform for chalets and resorts.',
      platforms: [AppPlatform.ios, AppPlatform.android, AppPlatform.web],
      iosUrl: 'https://apps.apple.com/eg/app/yabilachalet/id1596577791',
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.onesolutionc.yabilachalet',
      webUrl: 'http://54.170.130.161/',
    ),
    ProjectApp(
      name: 'Al-Sibiya Station',
      company: 'One Solution',
      description:
          'Ministry of Electricity & Water and Renewable Energy in Kuwait.',
      platforms: [AppPlatform.android],
      androidUrl:
          'https://play.google.com/store/apps/details?id=com.onesolutionc.ministry_of_electricity_and_water_kuwait',
    ),
    ProjectApp(
      name: 'Makkah Region Dev. Authority',
      company: 'One Solution',
      description: 'Smart government services platform.',
      platforms: [AppPlatform.web],
      webUrl: 'http://52.31.207.253',
    ),
  ];

  // ── Open Source ─────────────────────────────────────────────────────
  static const List<OpenSourceProject> openSource = [
    OpenSourceProject(
      name: 'noon_payments',
      tag: 'pub.dev package',
      description:
          'Published and maintained Flutter plugin for Noon Payments '
          'integration, including Swift Package Manager support. Full pub.dev '
          'publishing lifecycle managed end-to-end.',
      url: 'https://pub.dev/packages/noon_payments',
    ),
  ];

  // ── Skills ──────────────────────────────────────────────────────────
  static const List<SkillCategory> skills = [
    SkillCategory(
      title: 'Mobile Development',
      skills: [
        'Flutter',
        'Dart',
        'Android',
        'Kotlin',
        'Java',
        'Jetpack Compose',
      ],
    ),
    SkillCategory(
      title: 'Architecture & State',
      skills: [
        'Clean Architecture',
        'MVVM',
        'MVC',
        'BLoC',
        'Provider',
        'Riverpod',
        'GetX',
        'GoRouter',
        'GetIt',
        'Dartz (Either)',
        'Equatable',
        'SOLID',
      ],
    ),
    SkillCategory(
      title: 'Backend & Cloud',
      skills: [
        'Firebase',
        'Firestore',
        'Cloud Functions',
        'REST APIs',
        'Authentication',
        'FCM',
        'Odoo RPC',
      ],
    ),
    SkillCategory(
      title: 'Engineering Practices',
      skills: [
        'Git',
        'CI/CD (GitHub Actions)',
        'Fastlane',
        'Testing (Unit · Widget · Integration)',
        'Code Review',
        'Performance Optimization',
      ],
    ),
    SkillCategory(
      title: 'Additional',
      skills: [
        'Localization',
        'Maps',
        'Payments',
        'Sensors',
        'NFC/QR',
        'WebView',
        'Custom UI Components',
      ],
    ),
  ];

  // ── Education & Certifications ──────────────────────────────────────
  static const List<EducationRecord> education = [
    EducationRecord(
      degree: "Bachelor's Degree in Computer Science",
      institution: 'Mansoura University',
      period: '2016 – 2020',
    ),
    EducationRecord(
      degree: 'Android Mobile Development',
      institution: 'Information Technology Institute (ITI)',
      period: 'Oct 2020 – Feb 2021',
    ),
  ];

  static const List<String> certifications = [
    'Flutter Mobile Development — Information Technology Institute (ITI)',
    'Clean Architecture & Testing Masterclass — Udemy',
    'Advanced Flutter State Management (BLoC) — Udemy',
    'Android Development — New Horizons',
  ];

  static const List<({String language, String level})> languages = [
    (language: 'Arabic', level: 'Native'),
    (language: 'English', level: 'Professional'),
  ];

  // ── Quick Links page (/links) ───────────────────────────────────────
  static const List<QuickLink> quickLinks = [
    QuickLink(
      label: 'LinkedIn',
      subtitle: 'Professional profile & network',
      url: linkedinUrl,
    ),
    QuickLink(label: 'GitHub', subtitle: 'Open source & code', url: githubUrl),
    QuickLink(
      label: 'noon_payments on pub.dev',
      subtitle: 'My published Flutter plugin',
      url: 'https://pub.dev/packages/noon_payments',
    ),
  ];
}
