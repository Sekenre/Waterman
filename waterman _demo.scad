use <Waterman/waterman.scad>;

for (r = [1:20]) {
    $fn = 15;
    echo(sf=waterman_scale(r));
    translate([(r-1)*2,0,0]) scale(waterman_scale(r)) waterman_spheres(r);
    translate([(r-1)*2,4,0]) scaled_waterman(r);
    #translate([(r-1)*2,4,0]) cube(2, center=true);
}
