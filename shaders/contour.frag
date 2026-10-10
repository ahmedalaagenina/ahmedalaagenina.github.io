// Topographic contour field for the hero background.
//
// A smooth height field drifts slowly over time; contour lines are drawn
// where the height crosses evenly spaced levels. The pointer raises a hill,
// so lines bunch up and glow around the cursor (or finger).
//
// Line width is kept ~1px everywhere by dividing the distance to the nearest
// level by the local gradient (a numeric derivative, because runtime-effect
// shaders don't get dFdx/fwidth).
#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;       // canvas size, logical px
uniform float uTime;      // seconds (wrapped on the Dart side)
uniform vec2 uPointer;    // pointer position, logical px
uniform float uPresence;  // 0..1, how strongly the pointer shapes the field
uniform vec3 uBg;         // background color
uniform vec3 uLine;       // contour color
uniform vec3 uGlow;       // accent color near the pointer
uniform float uLineAlpha; // base contour opacity

out vec4 fragColor;

const float LEVELS = 9.0;

float terrain(vec2 p, float t) {
  float v = 0.55 * sin(p.x * 1.15 + t * 0.21 + sin(p.y * 0.7 + t * 0.13) * 1.2);
  v += 0.45 * sin(p.y * 1.35 - t * 0.17 + sin(p.x * 0.9 - t * 0.11) * 1.1);
  v += 0.20 * sin((p.x - p.y) * 2.1 + t * 0.29);
  v += 0.12 * sin(length(p - vec2(2.2, 1.4)) * 3.2 - t * 0.37);
  return v;
}

float heightAt(vec2 p, vec2 m, float t) {
  vec2 d = p - m;
  return terrain(p, t) + exp(-dot(d, d) * 2.2) * 0.85 * uPresence;
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  float shortSide = min(uSize.x, uSize.y);
  float unit = 3.2 / shortSide; // map units per logical pixel
  vec2 p = frag * unit;
  vec2 m = uPointer * unit;

  float h = heightAt(p, m, uTime);
  float hx = heightAt(p + vec2(unit, 0.0), m, uTime);
  float hy = heightAt(p + vec2(0.0, unit), m, uTime);
  float gradient = length(vec2(hx - h, hy - h)) * LEVELS; // levels per px

  float level = h * LEVELS;
  float distLevels = abs(fract(level + 0.5) - 0.5);
  float distPx = distLevels / max(gradient, 0.0001);

  // Every 5th contour is an "index contour", drawn heavier, as on real maps.
  float isIndex = 1.0 - step(0.5, mod(floor(level + 0.5), 5.0));
  float halfWidth = mix(0.55, 1.05, isIndex);
  float line = 1.0 - smoothstep(halfWidth, halfWidth + 1.0, distPx);

  vec2 dp = (frag - uPointer) / shortSide;
  float near = exp(-dot(dp, dp) * 18.0) * uPresence;

  // Fade out at the bottom edge so the hero melts into the page, and a
  // little under the nav bar at the top.
  float y = frag.y / uSize.y;
  float edge = smoothstep(1.0, 0.72, y) * smoothstep(0.0, 0.12, y);

  float alpha = line * uLineAlpha * mix(1.0, 1.9, isIndex) * (1.0 + near * 2.2);
  alpha = clamp(alpha * edge, 0.0, 1.0);

  vec3 lineColor = mix(uLine, uGlow, clamp(near * 1.4, 0.0, 1.0));
  vec3 color = mix(uBg, lineColor, alpha) + uGlow * near * 0.035 * edge;
  fragColor = vec4(color, 1.0);
}
