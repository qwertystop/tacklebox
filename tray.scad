// (c) by David Heyman 2017
//
// THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

// ******************************************
// Start of Configuration Area:
// Instructions: Set the configuration according to the size of box you want.
// The base will be twice the width of a tier.
// The lid will be twice the pin thickness in height.
// Thus, parts will all fit together without changing anything other than Build.
// If you want, Wall can be changed per-part without affecting the fit.
// Other parameters will affect the fit if changed.
Build = 2; // 0: Base, 1: Tier, 2: Lid, TODO struts
Width = 20; // width of a tier
Depth = 8; // depth of a tier
Height = 5; // height of each level
Wall = 0.2; // wall thickness
// TODO pin parameters will need reevaluating when pin library is brought in
Pin_Thickness = 0.5; // thickness of a pin (diameter)
Pin_Length = 1; // length of a pin
// End of Configuration Area
// ******************************************

module box (x, y, z, wall) {
  // hollow rect prism with bottom
  // positive quadrant
  translate([x/2, y/2, z/2])
    difference() {
      cube([x, y, z], true);
      translate([0, 0, wall])
        cube([x - (wall*2), y - (wall*2), z], true);
    }
}

module pinned_box(x, y, z, wall, pin_long, pin_thick, pin_spacings) {
    // a box with pins on the outside along one end
    union() {
        box(x, y, z, wall);
        for(dx=pin_spacings)
            for(dy=[0, y + pin_long])
                translate([dx, dy, z/2])
                    rotate(a=[90, 0, 0])
                        // TODO replace cylinder with a snap-fit pin from library
                        cylinder(h=pin_long, r=pin_thick/2);
    }
}

module base(x, y, z, wall, pin_long, pin_thick) {
    // base of the tiered box
    // four pins on each end
    // pins at 1/8, 2/8, 6/8, 7/8
    pin_increment = x/8;
    pin_spacings=[pin_increment, 2*pin_increment, 6*pin_increment, 7*pin_increment];
    pinned_box(x, y, z, wall, pin_long, pin_thick, pin_spacings);
}

module tier(x, y, z, wall, pin_long, pin_thick, open_fraction) {
    // tiers one and two of the tiered box, also lid
    // partially open on one side
    // pins at 1/4, 3/4
    closed_fraction=1 - open_fraction;
    pin_increment = x/4;
    pin_spacings=[pin_increment, 3*pin_increment];
    difference() {
        pinned_box(x, y, z, wall, pin_long, pin_thick, pin_spacings);
        translate([0, wall, (z * closed_fraction) + wall])
            cube([x - (wall*2), y - (wall*2), (z - wall) * open_fraction]);
    }
}

// TODO struts
// TODO pin library for pinned_box
// TODO pins should be on struts, holes in box, not vice versa

if (Build == 0) {
    base(Depth * 2, Width, Height, Wall, Pin_Length, Pin_Thickness);
} else if (Build == 1) {
    tier(Depth, Width, Height, Wall, Pin_Length, Pin_Thickness, 3/4);
} else if (Build == 2) {
    tier(Depth, Width, Pin_Thickness * 2, Wall, Pin_Length, Pin_Thickness, 1);
}
