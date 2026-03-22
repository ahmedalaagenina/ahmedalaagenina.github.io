import 'package:flutter/material.dart';

// ─── Models ───────────────────────────────────────────────────────────

class ProjectApp {
  final String name;
  final String? description;
  final List<String> highlights;
  final List<PlatformType> platforms;
  final String? iosUrl;
  final String? androidUrl;
  final String? webUrl;

  const ProjectApp({
    required this.name,
    this.description,
    this.highlights = const [],
    required this.platforms,
    this.iosUrl,
    this.androidUrl,
    this.webUrl,
  });
}

class ExperienceRecord {
  final String company;
  final String role;
  final String period;
  final String location;
  final List<String> descriptions;
  final List<ProjectApp> projects;

  const ExperienceRecord({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    required this.descriptions,
    this.projects = const [],
  });
}

enum PlatformType { iOS, Android, Web }

class SocialLink {
  final String label;
  final String url;
  final IconData icon;

  const SocialLink({
    required this.label,
    required this.url,
    required this.icon,
  });
}

class EducationRecord {
  final String degree;
  final String institution;
  final String period;
  final String? description;

  const EducationRecord({
    required this.degree,
    required this.institution,
    required this.period,
    this.description,
  });
}

class LanguageRecord {
  final String language;
  final String level;

  const LanguageRecord({required this.language, required this.level});
}

// ─── Data Constants ───────────────────────────────────────────────────

class CVData {
  static const String name = 'Ahmed AlaaEldin Atia';
  static const String title = 'Senior Mobile Engineer (Flutter | Android)';
  static const String location = 'Saudi Arabia';
  static const String phoneKsa = '+966508509042';
  static const String phoneEg = '+201096796900';
  static const String email = 'ahmedalaagenina@gmail.com';

  static const String linkedinUrl =
      'https://www.linkedin.com/in/ahmedalaagenina';
  static const String githubUrl = 'https://github.com/AhmedAlaaGenina';

  static const String briefBio =
      'Architecting high-scale mobile ecosystems with Flutter & Android. 6+ years of engineering excellence across 17+ production apps.';

  static const String summary =
      'Senior Mobile Engineer with 6+ years of experience and a proven track record of delivering 17+ production apps. Expert in Flutter, Android, and Clean Architecture, specializing in building scalable, maintainable systems and leading technical initiatives from concept to release across diverse industries.';

  // ─── Experience with Integrated Projects ────────────────────────────

  static const List<ExperienceRecord> experience = [
    // 1) IDaraNet
    ExperienceRecord(
      company: 'IDaraNet',
      role: 'Senior Software Engineer',
      period: 'Feb 2026 – Present',
      location: 'Saudi Arabia',
      descriptions: [
        'Architected a multi-role trip management system using modular MVVM and Provider, establishing scalable engineering standards for vehicle workflows.',
        'Engineered mission-critical features including session persistence, auto-recovery flows, and role-based navigation for cross-platform reliability.',
        'Leading architecture and development of multi-role document workflow system.',
        'Designed deep linking and App/Web fallback strategies for cross-platform experience.',
      ],
      projects: [
        ProjectApp(
          name: 'iDara Trip',
          description:
              'Multi-role trip management with session persistence and auto-recovery.',
          platforms: [PlatformType.iOS, PlatformType.Android],
          iosUrl: 'https://apps.apple.com/us/app/idara-trip/id6760389320',
          androidUrl:
              'https://play.google.com/store/apps/details?id=net.idara.trip',
        ),
        ProjectApp(
          name: 'iDara Sign',
          description:
              'Multi-role document workflow with deep linking and App/Web fallback.',
          platforms: [PlatformType.iOS, PlatformType.Android, PlatformType.Web],
          // TODO: INSERT iOS STORE LINK HERE
          iosUrl: null,
          // TODO: INSERT Android STORE LINK HERE
          androidUrl: null,
          // TODO: INSERT WEB LINK HERE
          webUrl: null,
        ),
      ],
    ),

    // 2) CyShield
    ExperienceRecord(
      company: 'CyShield',
      role: 'Software Engineer I',
      period: 'Feb 2025 – Feb 2026',
      location: 'Egypt',
      descriptions: [
        'Architected modular HR platform supporting ticketing, RFC, reservations, and attendance workflows.',
        'Led modernization of legacy modules into clean architecture, improving maintainability by 60%.',
        'Conducted code reviews, ensuring architectural consistency across mobile team.',
      ],
      projects: [
        ProjectApp(
          name: 'HR App (CyShield)',
          description:
              'Core HR modules: ticketing, RFC, reservations, attendance management.',
          platforms: [PlatformType.iOS, PlatformType.Android],
          // TODO: INSERT iOS STORE LINK HERE
          iosUrl: null,
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.cyapps.hr_app',
        ),
      ],
    ),

    // 3) Aramex International
    ExperienceRecord(
      company: 'Aramex International',
      role: 'Software Engineer',
      period: 'Oct 2022 – Jan 2025',
      location: 'Egypt',
      descriptions: [
        'Contributed to the architecture and implementation of real-time tracking systems with maps, routing, barcode scanning, and multi-payment workflows.',
        'Optimized performance for high-traffic production (10K+ daily operations).',
        'Developed driver workflows with real-time updates, REST APIs, and push notifications.',
      ],
      projects: [
        ProjectApp(
          name: 'Aramex Champion App',
          description:
              'Courier operations platform with offline-first sync, maps, routing, and barcode scanning.',
          platforms: [PlatformType.iOS, PlatformType.Android],
          iosUrl:
              'https://apps.apple.com/us/app/delivery-champions/id6502755328',
          // TODO: INSERT Android STORE LINK HERE
          androidUrl: null,
        ),
        ProjectApp(
          name: 'Aramex Freight App',
          description:
              'Truck management platform with real-time updates and REST APIs.',
          platforms: [PlatformType.iOS, PlatformType.Android],
          iosUrl:
              'https://apps.apple.com/us/app/aramex-freight-app/id6479978455',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.aramex.truckqueuingapp',
        ),
      ],
    ),

    // 4) Alrazi
    ExperienceRecord(
      company: 'Alrazi',
      role: 'Senior Software Engineer (Part-Time)',
      period: 'Sept 2023 – Present',
      location: 'Jordan',
      descriptions: [
        'Built buying, renting, and listing features with secure payment integration.',
        'Integrated ChatGPT assistant, video streaming, TTS, and assessment systems.',
        'Built complete backend using Firebase and Cloud Functions.',
      ],
      projects: [
        ProjectApp(
          name: 'Stylee (Alrazi)',
          description:
              'Fashion e-commerce marketplace with buying, renting, and listing.',
          platforms: [PlatformType.iOS, PlatformType.Android, PlatformType.Web],
          iosUrl:
              'https://apps.apple.com/eg/app/stylee-rent-buy-and-earn/id6499165037',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.yousef.stylee',
          webUrl: 'https://fashion-ae0a0.web.app/#/auth',
        ),
        ProjectApp(
          name: 'Alrazi Education Platform',
          description:
              'AI-powered education with ChatGPT assistant, video streaming, and TTS.',
          platforms: [PlatformType.iOS, PlatformType.Android, PlatformType.Web],
          iosUrl:
              'https://apps.apple.com/eg/app/alrazi-%D8%A7%D9%84%D8%B1%D8%A7%D8%B2%D9%8A/id6445819822',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.yousef.sciophile',
          webUrl: 'https://alrazi-academy.com/#/landing',
        ),
      ],
    ),

    // 5) SanadRewards
    ExperienceRecord(
      company: 'SanadRewards',
      role: 'Software Engineering Team Lead (Part-Time)',
      period: 'Dec 2022 – Present',
      location: 'Egypt',
      descriptions: [
        'Leading cross-functional team (Mobile, Backend, UI/UX) driving sprint execution.',
        'Architected HealthKit/Google Health Connect integrations with sensors and rewards.',
        'Mentoring engineers and aligning technical roadmap with business strategy.',
      ],
      projects: [
        ProjectApp(
          name: 'SanadRewards',
          description:
              'Gamified health and rewards platform with HealthKit integration.',
          platforms: [PlatformType.iOS, PlatformType.Android],
          iosUrl: 'https://apps.apple.com/eg/app/sanad-rewards/id6448073834',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.ubd.sanad',
        ),
      ],
    ),

    // 6) One Solution
    ExperienceRecord(
      company: 'One Solution',
      role: 'Flutter Developer',
      period: 'Jan 2021 – Jun 2023',
      location: 'Egypt',
      descriptions: [
        'Delivered 9+ production apps across health, e-commerce, education, and booking domains.',
      ],
      projects: [
        ProjectApp(
          name: 'Macro',
          description: 'Health & Nutrition platform.',
          platforms: [PlatformType.Android, PlatformType.iOS, PlatformType.Web],
          iosUrl: 'https://apps.apple.com/kw/app/try-macro/id1602597534',
          androidUrl:
              'https://docs.google.com/document/d/12BwTIDLNaUGYLrG6ruflYCp0l58M3SKF/edit',
          webUrl: 'https://trymacro.com/',
        ),
        ProjectApp(
          name: 'Challenge Center',
          description: 'Health & Nutrition application.',
          platforms: [PlatformType.Android, PlatformType.iOS],
          iosUrl: 'https://apps.apple.com/kw/app/challenge-center/id1602439876',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.onesolution.challenge',
        ),
        ProjectApp(
          name: 'Light Options',
          description: 'Health & Nutrition tracking.',
          platforms: [PlatformType.Android, PlatformType.iOS, PlatformType.Web],
          iosUrl: 'https://apps.apple.com/kw/app/light-options/id1614157720',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.onesolution.light_option',
          webUrl: 'http://3.251.4.121/',
        ),
        ProjectApp(
          name: "Let's Diet",
          description: 'Health & Nutrition planning.',
          platforms: [PlatformType.Android, PlatformType.iOS, PlatformType.Web],
          iosUrl: 'https://apps.apple.com/eg/app/lets-diet/id1598732448',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.onesolutionc.lets_diet',
          webUrl: 'http://3.134.54.171/',
        ),
        ProjectApp(
          name: 'One Edu',
          description: 'School management system.',
          platforms: [PlatformType.Android, PlatformType.iOS],
          iosUrl: 'https://apps.apple.com/kw/app/one-edu/id1614161401',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.onesolutionc.one_edu',
        ),
        ProjectApp(
          name: 'Yabila Chalet',
          description: 'Booking platform for chalets and resorts.',
          platforms: [PlatformType.Android, PlatformType.iOS, PlatformType.Web],
          iosUrl: 'https://apps.apple.com/eg/app/yabilachalet/id1596577791',
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.onesolutionc.yabilachalet',
          webUrl: 'http://54.170.130.161/',
        ),
        ProjectApp(
          name: 'Al-Sibiya Station',
          description:
              'Ministry of Electricity & Water and Renewable Energy in Kuwait.',
          platforms: [PlatformType.Android],
          androidUrl:
              'https://play.google.com/store/apps/details?id=com.onesolutionc.ministry_of_electricity_and_water_kuwait',
        ),
        ProjectApp(
          name: 'Makkah Region Dev. Authority',
          description: 'Smart government services app.',
          platforms: [PlatformType.Web],
          webUrl: 'http://52.31.207.253',
        ),
      ],
    ),
  ];

  // ─── Skills ─────────────────────────────────────────────────────────

  static const List<String> skillsMobile = [
    'Flutter',
    'Dart',
    'Android',
    'Kotlin',
    'Java',
    'Jetpack Compose',
  ];

  static const List<String> skillsArchitecture = [
    'Clean Architecture',
    'MVC',
    'MVVM',
    'BLoC',
    'Provider',
    'Riverpod',
    'GetX',
    'SOLID',
  ];

  static const List<String> skillsBackend = [
    'Firebase',
    'Firestore',
    'Cloud Functions',
    'REST APIs',
    'Authentication',
    'FCM',
    'Odoo RPC',
  ];

  static const List<String> skillsEngineering = [
    'Git',
    'CI/CD Basics',
    'Testing (Unit, Widget, Integration)',
    'Code Review',
    'Performance Optimization',
  ];

  static const List<String> skillsAdditional = [
    'Localization',
    'Maps',
    'Payments',
    'Sensors',
    'NFC/QR',
    'WebView',
    'Custom UI',
  ];

  // ─── Education ──────────────────────────────────────────────────────

  static const List<EducationRecord> education = [
    EducationRecord(
      degree: "Bachelor's Degree – Computer Science",
      institution: 'Mansoura University',
      period: '2016 – 2020',
    ),
    EducationRecord(
      degree: 'Android Mobile Development',
      institution: 'Information Technology Institute (ITI)',
      period: 'Oct 2020 – Feb 2021',
    ),
  ];

  // ─── Certifications ─────────────────────────────────────────────────

  static const List<String> certifications = [
    'Flutter Mobile Development – ITI',
    'Clean Architecture & Testing Masterclass – Udemy',
    'Flutter BLoC Pattern – Udemy',
    'Flutter Development – London App Brewery',
    'Android Development – New Horizons',
    'Java SE – New Horizons',
  ];

  // ─── Languages ──────────────────────────────────────────────────────

  static const List<LanguageRecord> languages = [
    LanguageRecord(language: 'Arabic', level: 'Native'),
    LanguageRecord(language: 'English', level: 'Professional'),
  ];
}
