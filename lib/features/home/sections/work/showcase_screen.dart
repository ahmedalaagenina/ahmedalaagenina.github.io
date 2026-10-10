import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/motion/springs.dart';
import '../../../../theme/app_theme.dart';
import 'showcase_item.dart';

/// What the phone displays for one entry: its screenshots, cycling while
/// [cycle] is true, or a designed cover (real app icon + name) when the
/// store has no usable screenshots. Never fake UI.
///
/// Images are only decoded once [load] is true (the section is near the
/// viewport), and at the size they are displayed ([decodeWidth]), not at
/// their file size: decoding a 540px image for a 280px slot wastes memory.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({
    super.key,
    required this.item,
    required this.load,
    required this.cycle,
    required this.decodeWidth,
  });

  final ShowcaseItem item;
  final bool load;
  final bool cycle;
  final int decodeWidth;

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  Timer? _timer;
  int _index = 0;
  bool _precached = false;

  List<String> get _screens => widget.item.entry.screens;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(ShowcaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _sync() {
    if (widget.load && !_precached) {
      _precached = true;
      // Decode the other screens ahead of time so cycling never flashes.
      for (final s in _screens.skip(1)) {
        precacheImage(_provider(s), context);
      }
    }
    final run =
        widget.cycle &&
        widget.load &&
        _screens.length > 1 &&
        !context.reduceMotion;
    if (run && _timer == null) {
      _timer = Timer.periodic(const Duration(milliseconds: 3200), (_) {
        setState(() => _index = (_index + 1) % _screens.length);
      });
    } else if (!run && _timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  ImageProvider _provider(String asset) =>
      ResizeImage(AssetImage(asset), width: widget.decodeWidth);

  @override
  Widget build(BuildContext context) {
    final entry = widget.item.entry;
    if (_screens.isEmpty || !widget.load) {
      return _CoverScreen(item: widget.item);
    }
    final curve = SpringCurve(Springs.gentle);
    return ColoredBox(
      color: Color(entry.screenBackground),
      child: AnimatedSwitcher(
        duration: curve.duration,
        switchInCurve: curve,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 1.04, end: 1.0).animate(animation),
            child: child,
          ),
        ),
        child: LayoutBuilder(
          key: ValueKey(_index),
          builder: (context, constraints) => Padding(
            padding: EdgeInsets.only(
              // Cropped screenshots start below the status bar.
              top: entry.screensStartBelowStatusBar
                  ? constraints.maxHeight * 0.073
                  : 0,
            ),
            // fitWidth, not cover: a screenshot must never lose content at
            // its sides. Taller shots clip at the bottom like a scrolling
            // screen; shorter ones fade their cut edge into the app's own
            // background color (the mask is sized to the image, not the
            // screen, so the fade always sits on the image's last pixels).
            child: Align(
              alignment: Alignment.topCenter,
              child: ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.9, 1.0],
                  colors: [Colors.black, Colors.black, Colors.transparent],
                ).createShader(bounds),
                child: Image(
                  image: _provider(_screens[_index]),
                  width: constraints.maxWidth,
                  fit: BoxFit.fitWidth,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CoverScreen extends StatelessWidget {
  const _CoverScreen({required this.item});

  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final tint = Color(item.entry.tint);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(tint, Colors.black, 0.25)!,
            Color.lerp(tint, Colors.black, 0.78)!,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: w * 0.32,
                  height: w * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w * 0.075),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image(
                    image: ResizeImage(
                      AssetImage(item.entry.icon),
                      width: (w * 0.32 * 3).round(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: w * 0.08),
                Text(
                  item.product.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: Fonts.body,
                    fontWeight: FontWeight.w600,
                    fontSize: w * 0.075,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                if (item.product.category != null) ...[
                  SizedBox(height: w * 0.025),
                  Text(
                    item.product.category!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.body,
                      fontSize: w * 0.048,
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
