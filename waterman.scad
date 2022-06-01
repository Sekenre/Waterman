/*  © 2022 Kio Smallwood <kio@mothers-arms.co.uk>

    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

/*
 Skip roots generated using the following formula in python:

 >>> def empty_root_table(m, n):
 ...    """Using Waterman's formula for roots with missing spheres
 ...    http://watermanpolyhedron.com/MISSING.html"""
 ...    f = lambda a, b: 6*a**2  +  8*a**2*(2*b - 1)
 ...    bases = []
 ...    for y in range(1, m+1):
 ...        for x in range(1, n+1):
 ...            r = f(x, y)
 ...            bases.append(r)
 ...    return sorted(bases)

 >>> print(empty_root_table(130, 13)[:200])
 
 The parameters m & n were found with trial and error.
*/

skip_roots = [14, 30, 46, 56, 62, 78, 94, 110, 120, 126, 126, 142, 158,
174, 184, 190, 206, 222, 224, 238, 248, 254, 270, 270, 286, 302, 312,
318, 334, 350, 350, 366, 376, 382, 398, 414, 414, 430, 440, 446, 462,
478, 480, 494, 504, 504, 510, 526, 542, 558, 558, 568, 574, 590, 606,
622, 632, 638, 654, 670, 686, 686, 696, 702, 702, 718, 734, 736, 750,
750, 760, 766, 782, 798, 814, 824, 830, 846, 846, 862, 878, 888, 894,
896, 910, 926, 942, 952, 958, 974, 990, 990, 992, 1006, 1016, 1022, 1038,
1054, 1070, 1080, 1080, 1086, 1102, 1118, 1134, 1134, 1134, 1144, 1150,
1150, 1166, 1182, 1198, 1208, 1214, 1230, 1246, 1248, 1262, 1272, 1278,
1278, 1294, 1310, 1326, 1336, 1342, 1358, 1374, 1390, 1400, 1400, 1406,
1422, 1422, 1438, 1454, 1464, 1470, 1470, 1486, 1502, 1504, 1518, 1528,
1534, 1550, 1550, 1566, 1566, 1582, 1592, 1598, 1614, 1630, 1646, 1656,
1656, 1662, 1678, 1694, 1694, 1710, 1710, 1720, 1726, 1742, 1758, 1760,
1774, 1784, 1790, 1806, 1822, 1838, 1848, 1854, 1854, 1870, 1886, 1902,
1912, 1918, 1920, 1934, 1950, 1950, 1966, 1976, 1982, 1998, 1998, 2014, 
2016, 2016, 2030, 2040, 2046, 2062, 2078];


/*
  These functions check whether a point in the grid corresponds to the centre
  of a sphere or a gap
*/
function even(x, y, z) = (x+y+z) % 2 == 0;
function check(x, y, z, r2) = even(x,y,z) && (x^2 + y^2 + z^2) == r2;
function check_lt(x, y, z, r2) = even(x,y,z) && (x^2 + y^2 + z^2) < r2;

/*
   creates a list of points that are inside the enclosing sphere
   draw_inner=true returns all points,
   draw_inner=false returns only the points at the enclosing sphere
   surface.
*/
function waterman_points(root=6, draw_inner=false)
    = let(r2 = 2*root)
      let(r = round(sqrt(r2)) + 2)
      let(r_range=[-r-1:r+1])
      [
        for (x = r_range)
        for (y = r_range)
        for (z = r_range)
           if ( check(x,y,z,r2) || (draw_inner && check_lt(x, y, z, r2) ) ) [x, y, z]
      ];

/*
    Draw the spheres with the centres at the points defined by the grid of points
    This can be good for layout since spheres with low $fn values are quick to preview
*/
module waterman_spheres(root=6,draw_inner=false) {
    root_step = len(search(root-1, skip_roots)) > 0 ? 2 : 1;
    points=waterman_points(root=root, draw_inner=false);
    points2=waterman_points(root=root-root_step, draw_inner=draw_inner);
    for (i = points) {
        color("lightblue") translate(i) sphere(1/sqrt(2));
    }
    for (j = points2) {
        color("pink") translate(j) sphere(1/sqrt(2));
    }
}

// This is just to make rendering the hull of the polygon easier.
module spike(p){
    points = [p, [0,1,0], [1,0,0], [0,0,1]];
    polyhedron(points, [[0,2,1], [0,1,3], [1,2,3], [0,3,2]]);
}

module waterman_spikes(root=6) {
    root_step = len(search(root-1, skip_roots)) > 0 ? 2 : 1;
    points=waterman_points(root=root, draw_inner=false);
    points2=waterman_points(root=root-root_step, draw_inner=false);
    //points2=[];
    for (i = points) {
        color("lightblue") spike(i);
    }
    for (j = points2) {
        color("pink") spike(j);
    }
}

// Convex hull of the set of points contained within a sphere that are
// in a Cubic Closest Packing arrangement.
module waterman(root=6){
   hull() waterman_spikes(root);
}

// scales a waterman polyhedron to fit exactly inside a
// bounding box centred at the origin with side length = 2
function waterman_scale(r) = 1/floor(sqrt(2*r));

module scaled_waterman(root=6){
    scale(waterman_scale(root)) waterman(root=root);
}
