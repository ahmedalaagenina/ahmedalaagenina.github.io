# Ahmed Alaa — Portfolio & CV

Personal portfolio built with Flutter Web, deployed automatically to
GitHub Pages at **https://ahmedalaagenina.github.io**.

## ✏️ How to update your CV (the only thing you'll usually do)

**Everything on the site renders from one file:**

```
lib/data/cv_data.dart
```

1. Open `lib/data/cv_data.dart`
2. Edit any text, add a job, add an app, add a skill — it's all plain Dart
   constants with clear sections
3. Commit and push to `main`
4. CI/CD builds and deploys automatically (~3 min)

Search the file for `TODO` to find missing store links (iDara Sign,
CyShield HR iOS, Aramex Champion Android, iDara Sign Admin). Paste a URL in
place of `null` and the badge appears automatically — badges with `null`
links are simply hidden.

### Adding your CV PDF

Copy your latest CV PDF into the `web/` folder named exactly `cv.pdf`.
The "Download CV" buttons already point to it.

### Adding a new job

Add an `ExperienceRecord` to the `experience` list. Flags:
`isCurrent: true` shows a green CURRENT chip, `isPartTime: true` shows a
PART-TIME chip.

### Adding a new app

Add a `ProjectApp` to the `projects` list. `featured: true` shows it in the
default grid; others appear behind "Show All". Fill only the links that
exist (`iosUrl`, `androidUrl`, `webUrl`, `adminUrl`) — missing ones are
hidden automatically.

## 🏃 Run locally

```bash
flutter pub get
flutter run -d chrome
```

## 🧪 Checks

```bash
flutter analyze
flutter test          # includes desktop + phone rendering smoke tests
```

## 🚀 Deployment

Push to `main` → `.github/workflows/deploy.yml` builds
(`flutter build web --release --wasm`) and publishes `build/web` to the
`gh-pages` branch. `index.html` is copied to `404.html` so deep links like
`/links` work on GitHub Pages.

## 🗺 Pages

- `/` — main portfolio (hero, stats, experience timeline, projects grid,
  skills, open source, education, contact)
- `/links` — Linktree-style quick links page for sharing one URL

## ⚡ Performance notes

- Instant branded splash screen in `web/index.html` (pure CSS — paints
  before Flutter loads, no more blank white screen)
- Fonts (Inter + Space Grotesk) are bundled and subset to Latin (~45KB per
  weight instead of ~325KB); no runtime Google Fonts downloads
- Icon fonts tree-shaken to a few KB at build time
- WASM build with automatic JS fallback for older browsers
- Service worker caches everything — repeat visits load instantly
- Particle animation pauses when the hero scrolls out of view

## ⌨️ Easter eggs

- Press **⌘K / Ctrl+K** anywhere for the command palette
- Particles in the hero react to your cursor
- Theme toggle (dark/light) persists across visits
