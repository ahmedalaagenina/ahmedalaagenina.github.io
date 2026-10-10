/// ════════════════════════════════════════════════════════════════════
///  THE ONLY FILE YOU EDIT TO CHANGE WHAT THE SITE SAYS
///
///  Content is copied from the CV. Accuracy rule: never add a number or a
///  claim here that the CV does not contain (test/data_accuracy_test.dart
///  guards the ones that were removed).
/// ════════════════════════════════════════════════════════════════════
library;

import 'copy.dart';
import 'models.dart';

export 'copy.dart';
export 'models.dart';

abstract final class Portfolio {
  // ── Identity ──────────────────────────────────────────────────────────
  static const identity = Identity(
    fullName: 'Ahmed Alaaeldin Atia',
    displayName: 'Ahmed Alaa',
    logo: '<AA />',
    title: 'Senior Mobile Engineer',
    specialty: '(Flutter | Android)',
    location: 'Saudi Arabia',
    email: 'ahmedalaagenina@gmail.com',
    phones: [
      Phone(label: 'KSA', display: '+966 50 850 9042', e164: '+966508509042'),
      Phone(label: 'Egypt', display: '+20 109 679 6900', e164: '+201096796900'),
    ],
    linkedInUrl: 'https://www.linkedin.com/in/ahmedalaagenina',
    gitHubUrl: 'https://github.com/AhmedAlaaGenina',
    siteUrl: 'https://ahmedalaagenina.github.io',
    cvPath: 'assets/Ahmed-Alaa-Senior-Mobile-Engineer-CV.pdf',
    cvFileName: 'Ahmed Alaa - Senior Mobile Engineer CV.pdf',
  );

  static const summary =
      'Senior Mobile Engineer with ~6 years of experience and 20+ production '
      'apps shipped across logistics, healthcare, education, e-commerce and '
      'government. Expert in Flutter, Android and Clean Architecture, with '
      'deep experience in offline-first systems, real-time maps, secure '
      'payment flows and multi-role platforms. Leads technical decisions from '
      'concept to App Store / Google Play release, and authors open-source '
      'packages on pub.dev.';

  // ── Experience (order as in the CV) ───────────────────────────────────
  static const roles = <Role>[
    Role(
      title: 'Senior Mobile Engineer',
      company: 'iDara.NET',
      period: 'Feb 2026 – Present',
      location: 'Saudi Arabia',
      employment: Employment.fullTime,
      employmentLabel: 'Full-Time',
      isCurrent: true,
      products: [
        Product(
          id: 'idara-sign',
          name: 'iDara Sign',
          category: 'E-Signature Platform',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/us/app/idara-sign/id6759380839',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=net.idara.sign',
            ),
            StoreLink(LinkKind.web, 'https://sign.idara.sa/'),
            StoreLink(LinkKind.admin, 'https://sign.idara.sa/admin/'),
          ],
          bullets: [
            'Leading architecture and development of a multi-role document '
                'workflow system spanning mobile (iOS/Android) and Flutter Web, '
                'using Clean Architecture, BLoC, GoRouter, and GetIt.',
            'Engineered an offline-first caching architecture (Dio interceptor '
                '+ Hive) with read/write request splitting and optimistic local '
                'execution, serving reads cache-first to cut redundant network '
                'calls.',
            'Designed a cross-app duplicate-request prevention system (custom '
                'interceptor + BLoC-level guard) across 2 apps, eliminating '
                'duplicate-submission incidents caused by repeated taps and '
                'network retries.',
            'Built a continuous PDF signing experience (pdfrx) with draggable '
                'signature-field placement across multi-page documents, '
                'resolving coordinate-accuracy, overlay-lifecycle, and '
                'cross-page gesture-crash issues, eliminating the crashes '
                'reported in the signing flow.',
            'Designed deep linking and App/Web fallback strategies for seamless '
                'cross-platform sign-in and document-signing journeys.',
            'Owned the release lifecycle for iDara Sign end-to-end — from code '
                'review through App Store and Google Play submission, managing '
                'privacy labels, OTP review requirements, and deep-link '
                'configuration — shipping both platforms through multiple '
                'review cycles.',
          ],
        ),
        Product(
          id: 'idara-tracking',
          name: 'iDara Tracking',
          category: 'Real-Time Fleet Tracking Platform',
          links: [
            StoreLink(LinkKind.ios, 'https://apps.apple.com/app/id1632179914'),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.idaratrackingclient.android',
            ),
          ],
          bullets: [
            'Rebuilt the legacy native Android fleet-tracking app in Flutter as '
                'sole developer (Clean Architecture, BLoC, GetIt/Injectable), '
                'integrating a third-party GPSWOX backend with no staging '
                'environment and no server-side control; shipped v2.0 to both '
                'stores.',
            'Engineered a real-time fleet map scaling to 2,000+ vehicles per '
                'fleet using client-side marker clustering, cached marker '
                'bitmaps, animated marker interpolation between polls, and '
                'adaptive frame throttling to keep the UI smooth.',
            'Built per-vehicle history playback with route segments, trip '
                'summaries, and date-range filtering, plus live events, push '
                'notifications, and fleet search/filtering.',
            'Designed per-endpoint caching and retry policies (Dio + Hive), '
                'enforcing at-most-once delivery for safety-critical vehicle '
                'commands (e.g. remote engine cut-off) so a delayed retry can '
                'never override a newer command.',
          ],
        ),
        Product(
          id: 'idara-trip',
          name: 'iDara Trip',
          category: 'Trip Management Platform',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/us/app/idara-trip/id6760389320',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=net.idara.trip',
            ),
          ],
          bullets: [
            'Architected a multi-role trip management system using modular '
                'MVVM and Provider, establishing scalable engineering standards '
                'for vehicle workflows.',
            'Engineered mission-critical features including session '
                'persistence, auto-recovery flows, and role-based navigation '
                'for cross-platform reliability.',
          ],
        ),
      ],
    ),
    Role(
      title: 'Software Engineer',
      company: 'Cyshield',
      period: 'Jan 2025 – Feb 2026',
      location: 'Egypt',
      employment: Employment.fullTime,
      employmentLabel: 'Full-Time',
      products: [
        Product(
          id: 'cyshield-hr',
          name: 'HR App Management Platform',
          links: [
            StoreLink(LinkKind.ios),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.cyapps.hr_app',
            ),
          ],
          bullets: [
            'Architected a modular HR platform supporting ticketing, RFC, '
                'reservations, attendance, and additional workflow modules.',
            'Led migration of ~80% of legacy modules to Clean Architecture, '
                'separating data, domain, and presentation layers for '
                'testability and maintainability.',
            'Conducted code reviews, ensuring architectural consistency across '
                'the mobile team.',
          ],
        ),
      ],
    ),
    Role(
      title: 'Software Engineer',
      company: 'Aramex International',
      period: 'Oct 2022 – Jan 2025',
      location: 'Egypt',
      employment: Employment.fullTime,
      employmentLabel: 'Full-Time',
      products: [
        Product(
          id: 'aramex-champion',
          name: 'Aramex Champion App',
          category: 'Courier Operations',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/us/app/delivery-champions/id6502755328',
            ),
            StoreLink(LinkKind.android),
          ],
        ),
        Product(
          id: 'aramex-freight',
          name: 'Aramex Freight App',
          category: 'Truck Management',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/us/app/aramex-freight-app/id6479978455',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.aramex.truckqueuingapp',
            ),
          ],
        ),
      ],
      bullets: [
        'Architected an offline-first synchronization engine with a persistent '
            'action queue and automatic sync on reconnect, letting couriers '
            'keep working in zero-connectivity zones without losing data.',
        'Bridged native Driver SDKs (Kotlin/Swift) into Flutter via Platform '
            'Channels, enabling advanced telematics and real-time mapping for '
            '10K+ daily activities.',
        'Optimized location polling and background sync logic to reduce '
            'battery drain during long courier shifts.',
        'Engineered secure multi-payment workflows and real-time notification '
            'systems, streamlining high-concurrency courier and freight '
            'management operations.',
      ],
    ),
    Role(
      title: 'Software Engineering Team Lead',
      company: 'Sanad Rewards',
      period: 'Dec 2022 – Present',
      location: 'Egypt (Remote)',
      employment: Employment.partTime,
      employmentLabel: 'Part-Time',
      isCurrent: true,
      products: [
        Product(
          id: 'sanad-rewards',
          name: 'Sanad Rewards',
          category: 'Gamified Health & Rewards Platform',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/eg/app/sanad-rewards/id6448073834',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.ubd.sanad',
            ),
          ],
          bullets: [
            'Leading a cross-functional team (Mobile, Backend, UI/UX), driving '
                'sprint execution.',
            'Architected HealthKit / Google Health Connect integrations with '
                'sensors and rewards logic.',
            'Mentoring engineers and aligning the technical roadmap with '
                'business strategy.',
          ],
        ),
        Product(
          id: 'sanad-business',
          name: 'Sanad Business',
          category: 'Corporate Wellness Platform',
          links: [
            StoreLink(LinkKind.ios, 'https://apps.apple.com/app/id6805096924'),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.sanadrewards.business',
            ),
          ],
          bullets: [
            'Contributed to a ground-up Flutter rewrite of the Sanad Rewards '
                'employee app with behavioral parity to the live app, '
                'delivering the challenge-teams feature, HealthKit '
                'integration, and push-notification and flavor fixes.',
            'Owned release engineering: Android signing, build flavors, '
                'deep-link configuration, and Shorebird code push for '
                'over-the-air updates.',
          ],
        ),
        Product(
          id: 'pulse',
          name: 'Pulse',
          category: 'Health Coaching & Programs App',
          links: [
            StoreLink(LinkKind.ios, 'https://apps.apple.com/app/id6767938059'),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.sanadrewards.sanad.pulse',
            ),
          ],
          bullets: [
            'Established the app foundation (Clean Architecture, BLoC, GoRouter '
                'navigation shell) for Home, Profile, Program, and Inbox, and '
                'built the Program feature end-to-end plus FCM push '
                'notifications.',
          ],
        ),
      ],
    ),
    Role(
      title: 'Senior Software Engineer',
      company: 'Alrazi',
      period: 'Sep 2023 – Jan 2026',
      location: 'Jordan (Remote)',
      employment: Employment.partTime,
      employmentLabel: 'Part-Time',
      products: [
        Product(
          id: 'stylee',
          name: 'Stylee',
          category: 'Fashion E-commerce Marketplace',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/eg/app/stylee-rent-buy-and-earn/id6499165037',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.yousef.stylee',
            ),
            StoreLink(LinkKind.web, 'https://fashion-ae0a0.web.app/'),
          ],
          bullets: [
            'Built buying, renting, and listing features with secure payment '
                'integration.',
          ],
        ),
        Product(
          id: 'alrazi-education',
          name: 'Alrazi Education Platform',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/eg/app/alrazi-%D8%A7%D9%84%D8%B1%D8%A7%D8%B2%D9%8A/id6445819822',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.yousef.sciophile',
            ),
            StoreLink(LinkKind.web, 'https://alrazi-academy.com/'),
          ],
          bullets: [
            'Integrated a ChatGPT assistant, video streaming, TTS, and '
                'assessment systems.',
            'Built the complete backend using Firebase and Cloud Functions.',
          ],
        ),
      ],
    ),
    Role(
      title: 'Flutter Developer',
      company: 'One Solution',
      period: 'Jan 2021 – Jun 2023',
      location: 'Egypt',
      employment: Employment.fullTime,
      employmentLabel:
          'Full-Time Jan 2021 – Sep 2022; Part-Time Oct 2022 – Jun 2023',
      bullets: [
        'Delivered 9+ production apps across health, e-commerce, education, '
            'booking, and government sectors, including Macro, Challenge '
            'Center, Light Options, Let’s Diet, One Edu, Yabila Chalet, '
            'Al-Sibiya Station, and Makkah Region Development Authority '
            'platforms.',
        'Built features end-to-end: REST API integration, Firebase, '
            'Arabic/English localization, maps, push notifications and custom '
            'UI. Recognized as Employee of the Month (January 2022).',
      ],
      products: [
        Product(
          id: 'macro',
          name: 'Macro',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/kw/app/try-macro/id1602597534',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.onesolution.macroapp',
            ),
          ],
        ),
        Product(
          id: 'challenge-center',
          name: 'Challenge Center',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/kw/app/challenge-center/id1602439876',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.onesolution.challenge',
            ),
          ],
        ),
        Product(
          id: 'one-edu',
          name: 'One Edu',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/kw/app/one-edu/id1614161401',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.onesolutionc.one_edu',
            ),
          ],
        ),
        Product(
          id: 'yabila-chalet',
          name: 'Yabila Chalet',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/eg/app/yabilachalet/id1596577791',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.onesolutionc.yabilachalet',
            ),
          ],
        ),
        Product(
          id: 'lets-diet',
          name: 'Let’s Diet',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/eg/app/lets-diet/id1598732448',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.onesolutionc.lets_diet',
            ),
          ],
        ),
        Product(
          id: 'light-options',
          name: 'Light Options',
          links: [
            StoreLink(
              LinkKind.ios,
              'https://apps.apple.com/kw/app/light-options/id1614157720',
            ),
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.onesolution.light_option',
            ),
          ],
        ),
        Product(
          id: 'mew-kuwait',
          name: 'Ministry of Electricity & Water Kuwait',
          links: [
            StoreLink(
              LinkKind.android,
              'https://play.google.com/store/apps/details?id=com.onesolutionc.ministry_of_electricity_and_water_kuwait',
            ),
          ],
        ),
      ],
    ),
  ];

  // ── Phone showcase (references products above by id) ─────────────────
  static const showcase = <ShowcaseEntry>[
    ShowcaseEntry(
      productId: 'idara-sign',
      company: 'iDara.NET',
      icon: 'assets/screens/idara-sign-icon.webp',
      tint: 0xFF4DA2D0,
      screens: [
        'assets/screens/idara-sign-1.webp',
        'assets/screens/idara-sign-2.webp',
        'assets/screens/idara-sign-3.webp',
      ],
      screensStartBelowStatusBar: true,
      screenBackground: 0xFFF7F9FC,
      highlights: [3, 1],
    ),
    ShowcaseEntry(
      productId: 'idara-tracking',
      company: 'iDara.NET',
      icon: 'assets/screens/idara-tracking-icon.webp',
      tint: 0xFFDE292F,
      screens: [
        'assets/screens/idara-tracking-1.webp',
        'assets/screens/idara-tracking-2.webp',
      ],
      highlights: [1, 0],
    ),
    ShowcaseEntry(
      productId: 'aramex-freight',
      company: 'Aramex International',
      icon: 'assets/screens/aramex-freight-icon.webp',
      tint: 0xFFDD281D,
      screens: [
        'assets/screens/aramex-freight-1.webp',
        'assets/screens/aramex-freight-2.webp',
      ],
      highlights: [0, 1],
    ),
    ShowcaseEntry(
      productId: 'sanad-rewards',
      company: 'Sanad Rewards',
      icon: 'assets/screens/sanad-rewards-icon.webp',
      tint: 0xFFFA5105,
      screens: [
        'assets/screens/sanad-rewards-1.webp',
        'assets/screens/sanad-rewards-2.webp',
        'assets/screens/sanad-rewards-3.webp',
      ],
      highlights: [1, 0],
    ),
    ShowcaseEntry(
      productId: 'pulse',
      company: 'Sanad Rewards',
      icon: 'assets/screens/pulse-icon.webp',
      tint: 0xFF89C738,
      screens: ['assets/screens/pulse-1.webp', 'assets/screens/pulse-2.webp'],
      screenBackground: 0xFF000000,
      highlights: [0],
    ),
    ShowcaseEntry(
      productId: 'stylee',
      company: 'Alrazi',
      icon: 'assets/screens/stylee-icon.webp',
      tint: 0xFFD08C84,
      screens: ['assets/screens/stylee-1.webp', 'assets/screens/stylee-2.webp'],
      highlights: [0],
    ),
  ];

  // ── Open source ───────────────────────────────────────────────────────
  static const openSource = OpenSourcePackage(
    name: 'noon_payments',
    description:
        'Published and maintain a Flutter plugin for Noon Payments '
        'integration, wrapping the native Android and iOS SDKs, including Swift '
        'Package Manager support; managed the full pub.dev publishing '
        'lifecycle.',
    pubDevUrl: 'https://pub.dev/packages/noon_payments',
    githubUrl: 'https://github.com/ahmedalaagenina/noon_payments',
    installCommand: 'flutter pub add noon_payments',
    installOutput: [
      'Resolving dependencies...',
      '+ noon_payments',
      'Changed 1 dependency!',
    ],
  );

  // ── Skills (wording exactly as in the CV) ─────────────────────────────
  static const skills = <SkillGroup>[
    SkillGroup(
      title: 'Mobile Development',
      skills: [
        Skill('Flutter'),
        Skill('Dart'),
        Skill('Android'),
        Skill('Kotlin'),
        Skill('Java'),
        Skill('Jetpack Compose'),
        Skill('iOS (Swift)', alsoMatches: ['Swift']),
        Skill('Platform Channels'),
      ],
    ),
    SkillGroup(
      title: 'Architecture & State Management',
      skills: [
        Skill('Clean Architecture'),
        Skill('MVC'),
        Skill('MVVM'),
        Skill('BLoC'),
        Skill('Provider'),
        Skill('Riverpod'),
        Skill('GetX'),
        Skill('GoRouter'),
        Skill('GetIt'),
        Skill('SOLID'),
      ],
    ),
    SkillGroup(
      title: 'Backend & Cloud',
      skills: [
        Skill('Firebase'),
        Skill('Firestore'),
        Skill('Cloud Functions'),
        Skill('REST APIs', alsoMatches: ['REST API']),
        Skill('Authentication'),
        Skill('FCM'),
        Skill('Odoo RPC'),
        Skill('Dio'),
        Skill('Hive'),
      ],
    ),
    SkillGroup(
      title: 'Engineering Practices',
      skills: [
        Skill('Git'),
        Skill(
          'CI/CD (GitHub Actions, Fastlane, Shorebird)',
          alsoMatches: ['Shorebird'],
        ),
        Skill('Testing (Unit, Widget, Integration)'),
        Skill('Code Review', alsoMatches: ['code reviews']),
        Skill('Performance Optimization'),
      ],
    ),
    SkillGroup(
      title: 'Additional Skills',
      skills: [
        Skill('Localization'),
        Skill('Maps', alsoMatches: ['map', 'mapping']),
        Skill('Payments', alsoMatches: ['payment']),
        Skill('Sensors'),
        Skill(
          'HealthKit / Health Connect',
          alsoMatches: ['HealthKit', 'Health Connect'],
        ),
        Skill('NFC/QR'),
        Skill('WebView'),
        Skill('Custom UI Components', alsoMatches: ['custom UI']),
      ],
    ),
  ];

  // ── Education, certifications, languages, recognition ─────────────────
  static const education = <Education>[
    Education(
      title: 'Bachelor’s Degree, Computer Science',
      institution:
          'Faculty of Computer and Information Science (FCIS), Mansoura '
          'University',
      period: '2016 – 2020',
      note: EducationNote(
        label: 'Graduation Project',
        text:
            '3D Reconstruction Dressing Room on Mobile Phone — a virtual '
            'dressing room simulation on a mobile phone using a single camera, '
            'built with AI, ML, OpenSfM, Image Processing, and Flutter.',
      ),
    ),
    Education(
      title: 'Android Mobile Development',
      institution: 'Information Technology Institute (ITI)',
      detail: 'Ministry of Communications and Information Technology',
      period: 'Oct 2020 – Feb 2021',
    ),
  ];

  static const certifications = <Certification>[
    Certification(
      name: 'Flutter Mobile Development',
      issuer: 'Information Technology Institute (ITI)',
    ),
    Certification(
      name: 'Clean Architecture & Testing Masterclass',
      issuer: 'Udemy',
    ),
    Certification(
      name: 'Advanced Flutter State Management (BLoC)',
      issuer: 'Udemy',
    ),
    Certification(name: 'Android Development', issuer: 'New Horizons'),
  ];

  static const languages = <Language>[
    Language(name: 'Arabic', level: 'Native'),
    Language(name: 'English', level: 'Professional'),
  ];

  static const recognition = <Recognition>[
    Recognition(
      title: 'Employee of the Month',
      detail: 'One Solution (January 2022)',
    ),
  ];

  // ── Links page (/links) ───────────────────────────────────────────────
  static const quickLinks = <QuickLink>[
    QuickLink(
      label: 'LinkedIn',
      subtitle: 'Professional profile',
      url: 'https://www.linkedin.com/in/ahmedalaagenina',
    ),
    QuickLink(
      label: 'GitHub',
      subtitle: 'Code and open source',
      url: 'https://github.com/AhmedAlaaGenina',
    ),
    QuickLink(
      label: 'noon_payments',
      subtitle: 'My Flutter plugin on pub.dev',
      url: 'https://pub.dev/packages/noon_payments',
    ),
  ];

  // ── Interface copy ────────────────────────────────────────────────────
  static const copy = SiteCopy(
    nav: NavCopy(
      home: 'Home',
      work: 'Work',
      experience: 'Experience',
      lab: 'Lab',
      skills: 'Skills',
      openSource: 'Open source',
      education: 'Education',
      contact: 'Contact',
      menu: 'Open menu',
      closeMenu: 'Close menu',
      openPalette: 'Search and jump ({shortcut})',
      homeLink: 'Ahmed Alaa, back to top',
    ),
    hero: HeroCopy(
      roles: [
        'Senior Mobile Engineer',
        'Flutter Specialist',
        'pub.dev Package Author',
      ],
      oneLiner:
          'I build Flutter apps that hold up in the real world — offline in a '
          'courier’s van, live-tracking 2,000+ vehicles on one map, and '
          'running on iOS, Android and Web from a single codebase.',
      primaryCta: 'See my work',
      secondaryCta: 'Download CV',
      locationPrefix: 'Based in',
    ),
    about: SectionCopy(title: 'About'),
    work: WorkCopy(
      title: 'Selected work',
      intro:
          'Apps I built and shipped. Every one is live on the App Store, '
          'Google Play or the web.',
      screenLabel: '{name} screenshot',
    ),
    experience: ExperienceCopy(
      title: 'Experience',
      fullTimeLane: 'Full-time',
      partTimeLane: 'Part-time, in parallel',
      showHighlights: 'Show {n} highlights',
      showHighlight: 'Show highlight',
      hideHighlights: 'Hide highlights',
      appsHeading: 'Apps',
      current: 'Current',
    ),
    lab: LabCopy(
      title: 'Lab',
      intro:
          'Small, live versions of problems I solved in production. The data '
          'is simulated, the engineering ideas are real.',
      loading: 'Loading demo',
      fleet: FleetCopy(
        tab: DemoTabCopy(
          tab: 'Fleet map',
          caption:
              'Inspired by iDara Tracking, where the real map scales to '
              '2,000+ vehicles per fleet. Zoom in to split clusters, zoom out '
              'to merge them.',
        ),
        zoomIn: 'Zoom in',
        zoomOut: 'Zoom out',
        resetView: 'Reset view',
        vehicles: '{n} vehicles',
        clusters: '{n} clusters',
        zoom: '{n}× zoom',
        hint: 'Double-tap to zoom, drag to pan',
        mapLabel:
            'Simulated fleet map with {n} moving vehicles grouped into '
            'clusters',
      ),
      offline: OfflineCopy(
        tab: DemoTabCopy(
          tab: 'Offline sync',
          caption:
              'Inspired by the Aramex offline-first sync engine. Turn the '
              'network off, queue a few actions, then turn it back on.',
        ),
        appTitle: 'Today’s route',
        online: 'Online',
        offline: 'Offline',
        networkLabel: 'Network',
        offlineBanner: 'You’re offline. Actions are saved on this device.',
        actions: ['Scan parcel', 'Mark delivered', 'Collect payment'],
        queued: 'Waiting to sync',
        synced: 'Synced',
        emptyQueue: 'Nothing waiting',
        emptySynced: 'Tap an action above',
        syncing: 'Syncing',
      ),
      sign: SignCopy(
        tab: DemoTabCopy(
          tab: 'PDF signing',
          caption:
              'Inspired by iDara Sign. Drag the signature field anywhere on '
              'the page, then sign. The readout shows the field in PDF '
              'coordinates.',
        ),
        documentTitle: 'Service Agreement',
        pageLabel: 'Page 1 of 1',
        field: 'Signature',
        dragHint: 'Drag to place',
        sign: 'Sign',
        reset: 'Reset',
        coordinates: 'x {x} pt  y {y} pt',
        fieldSemantics:
            'Signature field. Drag it, or use the arrow keys to move it.',
      ),
    ),
    skills: SkillsCopy(title: 'Skills', usedIn: '{skill}: {places}'),
    openSource: OpenSourceCopy(
      title: 'Open source',
      pubDev: 'View on pub.dev',
      gitHub: 'View on GitHub',
      replay: 'Run again',
      terminalLabel: 'Terminal running {command}',
    ),
    education: EducationCopy(
      title: 'Education',
      certifications: 'Certifications',
      languages: 'Languages',
      recognition: 'Recognition',
    ),
    contact: ContactCopy(
      headline: 'Have an app that has to work in the real world? Let’s talk.',
      copyEmail: 'Copy email',
      copied: 'Copied',
      emailCopiedToast: 'Email copied to clipboard',
      sendEmail: 'Send email',
      whatsApp: 'WhatsApp',
      call: 'Call',
      phonesHeading: 'Phone',
      chooseNumber: 'Choose a number',
    ),
    footer: FooterCopy(
      rights: '© {year} {name}',
      builtWith: 'Built with Flutter',
      paletteHint: 'Press {shortcut} to jump anywhere',
      backToTop: 'Back to top',
      allLinks: 'All links',
    ),
    palette: PaletteCopy(
      searchHint: 'Search sections and actions',
      sectionsGroup: 'Sections',
      actionsGroup: 'Actions',
      linksGroup: 'Links',
      noMatches: 'No matches. Try “skills” or “email”.',
      switchToLight: 'Switch to light mode',
      switchToDark: 'Switch to dark mode',
      openLinksPage: 'Open links page',
    ),
    common: CommonCopy(
      appStore: 'App Store',
      googlePlay: 'Google Play',
      web: 'Web',
      admin: 'Admin',
      ios: 'iOS',
      android: 'Android',
      noPublicLink: '{platform}, no public link',
      openOn: 'Open {name} on {platform}',
      downloadCv: 'Download CV',
      linkedIn: 'LinkedIn',
      gitHub: 'GitHub',
      email: 'Email',
    ),
    easterEgg: EasterEggCopy(
      stepsAway: 'You are now {n} steps away from being a developer.',
      enabled: 'You are now a developer! Debug paint is on.',
      disabled: 'Debug paint is off.',
    ),
    links: LinksCopy(
      pageTitle: 'Links',
      portfolio: 'Portfolio',
      portfolioSubtitle: 'Experience, apps and live demos',
      whatsAppSubtitle: 'Chat directly',
      callSubtitle: 'KSA or Egypt',
      cvSubtitle: 'PDF',
    ),
  );

  /// Finds a product by id across all roles.
  static Product product(String id) =>
      roles.expand((r) => r.products).firstWhere((p) => p.id == id);

  /// The role that owns a product.
  static Role roleOf(String productId) =>
      roles.firstWhere((r) => r.products.any((p) => p.id == productId));
}
