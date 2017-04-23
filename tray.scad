module loop (x, y, z, wall) {
  // hollow rect prism loop
  // positive quadrant
  translate([x/2, y/2, z/2])
    difference() {
      cube([x, y, z], true);
      cube([x - wall, y - wall, z + 1], true);
    }
}

module box (x, y, z, wall) {
  // hollow rect prism with bottom
  // positive quadrant
  translate([x/2, y/2, z/2])
    difference() {
      cube([x, y, z], true);
      translate([0, 0, wall])
        cube([x - wall, y - wall, z], true);
    }
}

module grid (width, numwide, depth, numdeep) {
  // grid of an object, the first child
  for (d=[0:depth:(numdeep-1)*depth])
    for(t=[0:width:(numwide-1)*width])
      translate([t, d, 0])
        children(0);
}

module tray (x, y, z, wall, wide, deep, floor=true) {
  // overlap by very slightly less than wall
  // to avoid overlapping faces
  over = (wall/2) - (wall/1000);
  grid(x-over, wide, y-over, deep)
    if(floor) {
      box(x, y, z, wall);
    }
    else {
      loop(x, y, z, wall);
    }
}

