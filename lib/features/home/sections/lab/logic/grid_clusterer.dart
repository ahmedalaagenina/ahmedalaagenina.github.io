import 'dart:ui';

/// A group of points that fell into the same grid cell.
class Cluster {
  Cluster(this.members, this.center);

  /// Indexes into the input list.
  final List<int> members;

  /// Average position of the members (same space as the input).
  final Offset center;

  int get size => members.length;
}

/// Grid-based clustering in screen space.
///
/// Points are bucketed into square cells of [cellSize] pixels; every cell
/// with points becomes one cluster. It is O(n) per pass, which is why it
/// suits a map that re-clusters on every zoom step. As you zoom in, the
/// same world distance covers more pixels, points spread across more
/// cells, and clusters split.
///
/// Trade-off: two points just either side of a cell edge never merge, even
/// when they are 1px apart. Distance-based methods fix that at a higher
/// cost; at 200 vehicles the grid's speed and stability win.
class GridClusterer {
  const GridClusterer({this.cellSize = 56});

  final double cellSize;

  List<Cluster> cluster(List<Offset> screenPoints) {
    final cells = <int, List<int>>{};
    for (var i = 0; i < screenPoints.length; i++) {
      final p = screenPoints[i];
      final cx = (p.dx / cellSize).floor();
      final cy = (p.dy / cellSize).floor();
      // Pack the cell coordinates into one int key (cy offset keeps the
      // key unique for negative coordinates too).
      final key = (cx + 100000) * 200003 + (cy + 100000);
      (cells[key] ??= []).add(i);
    }
    return [
      for (final members in cells.values)
        Cluster(members, _centroid(screenPoints, members)),
    ];
  }

  static Offset _centroid(List<Offset> points, List<int> members) {
    var x = 0.0;
    var y = 0.0;
    for (final i in members) {
      x += points[i].dx;
      y += points[i].dy;
    }
    return Offset(x / members.length, y / members.length);
  }
}
