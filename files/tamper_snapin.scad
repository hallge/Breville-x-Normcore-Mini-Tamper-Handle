// Breville Dual Boiler magnetic tamper handle for Normcore V4
// ===========================================================================
// SNAP-IN MAGNET VARIANT of the original tamper.scad, tuned for Nylon 6 CF.
//
// Original: sealed Ø20.1 x 8.95 magnet pocket, so the print must be paused
// mid-way to drop the magnet in.
//
// This version: magnet and a #7 O-ring are pushed up the existing bottom bore,
// through the M14 x 0.75 thread, into a pocket under the crown. No print
// pause, one piece, magnet fully hidden.
//
// Cavity from the crown downward:
//   crown skin -> magnet -> O-ring (axially squeezed) -> snap ring
//              -> funnel -> straight throat -> tamper thread
//
// Chain of retention:
//   the crown stops the magnet going up,
//   the O-ring stops the magnet coming down,
//   the snap ring stops the O-ring coming down.
// The snap ring is deliberately LARGER than the magnet - the magnet drops
// straight through it and is never press fit. Only the rubber O-ring deforms.
//
// SERVICING: notch_n gaps interrupt the snap ring, opened out to Ø notch_d.
// Slide a narrow slotted screwdriver up the bore into a notch, twist to
// collapse the O-ring inward, and it drops out - then the magnet follows.
//
// OUTER PROFILE is a 2D polygon revolved with rotate_extrude(). The crown
// edge is a true tangent fillet - tangent to the tapered barrel at one end
// and to the flat crown at the other, so there is no crease anywhere for the
// palm to feel. No external chamfer library, and no non-commercial licence.
//
// HARD CONSTRAINT that drives the whole design:
//   the M14 x 0.75 tamper thread has a minor diameter near Ø13.3, and it sits
//   directly under the magnet pocket. Anything loaded from the bottom opening
//   must fit through that throat. A 3/4" (19.05 mm) magnet never will.
//
// THREAD SPEC CAVEAT: Normcore publishes no dimensions for the V4 core sleeve
// stud. M14 x 0.75 is inherited from the original design, not from a
// manufacturer drawing. Print part="testfit" and check it on your own tamper
// before committing to a full handle. See the echo report for what to measure.
//
// Library (CC0 public domain):
// use <threads.scad>   // https://github.com/rcolyer/threads-scad
use <threads.scad>

$fn = 120;

/* [What to render] */
part = "handle";          // "handle", "pusher", "testfit", "both"
print_orientation = "crown_up";   // "crown_up"   = open end on the bed
                                  // "crown_down" = original orientation

/* [Printer compensation - MEASURE THESE, see echo report] */
// hole_comp is added to every internal diameter to cancel the usual FDM
// undersize. Measure the Ø20.2 bore on a test print and set:
//     hole_comp = 20.2 - (measured bore)
hole_comp     = 0.15;     // diametral, PA6-CF at 0.4 mm nozzle is ~0.10-0.20
// shrink_comp scales the whole part up so it lands on size after cooling.
// LEAVE AT 0 if your slicer already applies shrinkage compensation, or you
// will compensate twice. PA6-CF is typically 0.3-0.6 percent.
shrink_comp   = 0;        // percent

/* [Magnet] */
// Home Depot Master Magnet 07046HD: 0.47 in x 0.118 in neodymium disc.
magnet_d      = 11.94;    // 0.47 in  - magnet outside diameter
magnet_t      = 3.00;     // 0.118 in - thickness of ONE disc
magnet_n      = 1;        // how many are stacked
magnet_fit    = 0.40;     // diametral clearance of the magnet in its pocket

/* [O-ring] */
// #7 O-ring, 3/8 in ID x 1/2 in OD x 1/16 in wall.
oring_od      = 12.70;    // 1/2 in  - free outside diameter
oring_cord    = 1.5875;   // 1/16 in - cross section
oring_fit     = 0.20;     // diametral clearance in its counterbore
oring_squeeze = 0.35;     // axial compression when installed (~22% of cord)
                          // Both bounding faces quantise to the layer grid, so
                          // the as-built squeeze lands within about +/-0.2 mm
                          // of this. 22% nominal keeps the worst case inside
                          // the 10-35% static band.

/* [Snap ring] */
magnet_pass   = 0.25;     // diametral CLEARANCE for the magnet through the ring
land_h        = 0.40;     // height of the flat land on the ring
lead_in       = 1.20;     // height of the funnel below the ring

/* [Service notches] */
notch_n       = 2;        // gaps in the snap ring, evenly spaced
notch_w       = 4.00;     // tangential width - fits a 3.2 mm slotted blade
notch_d       = 14.40;    // local bore at a notch (0.85 mm clear of O-ring OD)
notch_lead    = 1.50;     // how far the notch runs below the funnel

/* [Crown] */
crown_fillet  = 6.00;     // tangent roundover radius on the crown edge
outer_trim    = 0.50;     // diameter taken off the whole barrel. The first Mini
                          // prints came out 0.5 mm too wide for the Breville
                          // recess, so the same trim is applied here. The
                          // taper is unchanged. 0 restores the 29 / 31 mm barrel.
base_break    = 0.50;     // small chamfer on the outer edge of the open end
top_skin      = 1.00;     // crown thickness over the magnet (original was 0.50)

/* [Tamper thread - M14 x 0.75 female, mates with the core sleeve stud] */
thread_d      = 14.00;    // nominal major diameter
thread_pitch  = 0.75;
thread_tol    = 0.40;     // threads-scad tolerance; 0.40 is the original value
// THE THREAD LENGTH IS THE STOP. The end of this thread is where the stud
// stops (see throat_d), and that fixes the handle's position on the
// cartridge, which fixes the outer spring's preload and the click force.
// 7.00 mm ends the thread at z 39.99, exactly where the original design's
// solid floor stopped the stud - so this handle sits on the cartridge
// exactly where the published, working original did. Do not lengthen it:
// every extra mm screws the handle a mm further down and stiffens the tamp.
thread_len    = 7.00;     // depth of the threaded hole = the stop position
stud_thread_len = 7.00;   // REFERENCE ONLY, for the engagement figure
// 45 deg conical lead-in at the bottom of the thread. Only needed when the
// open end is on the bed, where that transition is a downward-facing ledge.
// Printing crown-down the ledge is self-supporting, so no thread is given up.
thread_lead   = (print_orientation == "crown_up");

/* [Height] */
// THIS FILE IS V4 ONLY. A V4.1 cartridge will not fit it whatever the
// height: the V4.1 outer spring measures Ø23.0 and this handle's spring bore
// is Ø20.2. For a V4.1 use tamper_mini_flair.scad or tamper_mini_noflair.scad.
// On a V4 the top stud ends with its threads, so the space between the stop
// and the funnel is empty. 5.05 gives 55.00 mm overall; 0 gives the
// original 49.95 mm. Either works on a V4 - the stop does not move.
extra_height  = 5.05;     // makes the handle taller by pushing the crown and
                          // magnet up. Does not affect the stop.

/* [Original dimensions - do not change] */
shaft_height  = 33;       // start of the thread = top of the Ø20.2 bore
screw_height  = 7;        // original thread depth, kept for reference
tamper_height = 49.95 + extra_height;
bore_lower_d  = 21.4;     // counterbore, 0 .. 16
bore_lower_h  = 16;
bore_main_d   = 20.2;     // tamper body clearance, 0 .. 33

// ===========================================================================
// Derived
// ===========================================================================
function bore(d) = d + hole_comp;         // printer compensation on every bore

stack_h    = magnet_n * magnet_t;
pocket_d   = magnet_d + magnet_fit;
oring_d    = oring_od + oring_fit;
oring_h    = oring_cord - oring_squeeze;
land_d     = magnet_d + magnet_pass;      // BIGGER than the magnet

// -- thread ----------------------------------------------------------------
// ScrewHole() internally cuts ScrewThread(1.01*d + 1.25*tol, ...), and
// ScrewThread adds a further 0.25*tol. Replicated here as a plain solid so
// the same cut can be reused by the test coupons.
thread_tol_eff = thread_tol + hole_comp/1.25;   // fold bore compensation in
thread_cut_d   = 1.01*thread_d + 1.25*thread_tol_eff;
thread_major   = thread_cut_d + 0.25*thread_tol_eff;
thread_minor   = thread_cut_d - thread_pitch/tan(30);
thread_z0      = shaft_height - .01;             // 32.99
thread_z1      = thread_z0 + thread_len;

// ISO M14 x 0.75 external thread (6g) for comparison in the echo report
iso_major_max  = thread_d - 0.022;
iso_pitch_dia  = thread_d - 0.6495*thread_pitch;
iso_minor      = thread_d - 1.0825*thread_pitch;

// 45 deg conical lead-in converts the flat annular ledge at the bottom of the
// thread into a printable overhang when the open end is on the bed.
lead_r0    = bore(bore_main_d)/2;
lead_r1    = thread_major/2;
lead_h     = thread_lead ? (lead_r0 - lead_r1) : 0;
thread_eng = min(stud_thread_len, thread_len) - lead_h;   // stud limits this, not hole depth
stud_clear = cone_bot - thread_z1;   // empty runout bore above the stop

// -- cavity, referenced down from the underside of the crown ---------------
crown_bot  = tamper_height - top_skin;
magnet_bot = crown_bot - stack_h;
oring_bot  = magnet_bot - oring_h;
land_bot   = oring_bot - land_h;
cone_bot   = land_bot - lead_in;
// RUNOUT BORE - this is the handle's positive stop. It is narrower than the
// stud's major diameter, so the stud stops dead at the end of the thread,
// the same way Normcore's own Mini handle does it. It is still wide enough
// for the O-ring and magnet to pass on their way up. An earlier revision
// opened this to Ø14.20 to let a long stud run on, which removed the stop:
// the handle then screwed down until it felt tight, and the preload changed
// every time it was fitted.
throat_d   = 13.45;
notch_top  = magnet_bot;
notch_bot  = cone_bot - notch_lead;
head_room  = crown_bot - oring_h - land_h - lead_in - thread_z1;

// -- outer profile ---------------------------------------------------------
base_r     = (31 - outer_trim)/2;
top_r      = (29 - outer_trim)/2;
taper_dr   = (top_r - base_r) / tamper_height;
nlen       = sqrt(1 + taper_dr*taper_dr);
nr         = 1 / nlen;                    // outward wall normal, radial part
nz         = -taper_dr / nlen;            // outward wall normal, axial part
fil_cz     = tamper_height - crown_fillet;
fil_cr     = base_r + (-crown_fillet - fil_cz*nz) / nr;
fil_a0     = atan2(nz, nr);               // wall tangent angle, ~1.15 deg
fil_seg    = max(16, ceil($fn/4));
crown_flat_d = 2*fil_cr;

function crown_cover(r) =
    (r <= fil_cr) ? top_skin
    : fil_cz + sqrt(max(0, crown_fillet*crown_fillet - pow(r - fil_cr, 2))) - crown_bot;

profile = concat(
    [[0, 0],
     [base_r - base_break, 0],
     [base_r, base_break]],
    [ for (i = [0 : fil_seg])
        let (t = fil_a0 + (90 - fil_a0) * i / fil_seg)
        [fil_cr + crown_fillet*cos(t), fil_cz + crown_fillet*sin(t)] ],
    [[0, tamper_height]]
);

kscale = 1 / (1 - shrink_comp/100);

// ===========================================================================
// Report
// ===========================================================================
echo(str("== CROWN ================================================"));
echo(str("  fillet radius        : R", crown_fillet, " tangent to barrel at z ",
         fil_cz + crown_fillet*nz, ", to crown at r ", fil_cr));
echo(str("  flat crown face      : d", crown_flat_d));
echo(str("  crown thickness      : ", top_skin, " over the whole magnet"));
echo(str("  cover at pocket edge : ", crown_cover(pocket_d/2), " mm"));
echo(str("== CAVITY (design sizes, as printed) ===================="));
echo(str("  magnet   d", magnet_d, " x ", stack_h, "  z ", magnet_bot, " .. ", crown_bot));
echo(str("  pocket   d", pocket_d));
echo(str("  O-ring   d", oring_d, " x ", oring_h, "  squeeze ",
         100*oring_squeeze/oring_cord, " percent"));
echo(str("  land     d", land_d, "  magnet clears by ", land_d - magnet_d,
         ", O-ring interferes by ", oring_od - land_d));
echo(str("  shelf under O-ring   : ", (oring_d - land_d)/2, " mm radial"));
echo(str("  notches  ", notch_n, " x ", notch_w, " wide to d", notch_d,
         ", blade room ", (notch_d - oring_od)/2, " per side"));
echo(str("  head room            : ", head_room, " mm (=", floor(head_room/magnet_t), " discs)"));
echo(str("== THREAD ==============================================="));
echo(str("  modelled  major d", thread_major, "  minor d", thread_minor));
echo(str("  as printed major d", thread_major - hole_comp,
         "  minor d", thread_minor - hole_comp));
echo(str("  ISO M14x0.75-6g stud: major<=", iso_major_max,
         "  pitch d", iso_pitch_dia, "  minor d", iso_minor));
echo(str("  crest clearance on stud major : ",
         (thread_major - hole_comp - iso_major_max)/2, " mm radial"));
echo(str("  root clearance at stud minor  : ",
         (thread_minor - hole_comp - iso_minor)/2, " mm radial  (want > 0.05)"));
echo(str("  flank engagement              : ",
         100*(iso_major_max - (thread_minor - hole_comp))/(iso_major_max - iso_minor),
         " percent of stud thread depth"));
echo(str("  lead-in ", thread_lead ? "45 deg" : "none", ", engaged length ",
         thread_eng, " mm of ", thread_len));
echo(str("== STOP ================================================"));
echo(str("  thread runs z ", thread_z0, " .. ", thread_z1, "  (", thread_len, " mm deep)"));
echo(str("  STUD STOPS at z ", thread_z1, "  (original design: 39.99)"));
echo(str("  runout bore d", throat_d, " stops stud major ", iso_major_max, " by ",
         (iso_major_max - throat_d)/2, " radial; O-ring passes by ", (throat_d - oring_od)/2));
echo(str("  empty runout bore above the stop: ", stud_clear, " mm"));
echo(str("  overall height ", tamper_height, " (extra_height ", extra_height, ")"));
echo(str("== PRINTER =============================================="));
echo(str("  hole_comp ", hole_comp, " added to every bore; shrink_comp ",
         shrink_comp, " percent -> scale ", kscale));
echo(str("  orientation: ", print_orientation,
         print_orientation == "crown_up"
           ? "  (open end on bed; crown roundover prints clean)"
           : "  (crown on bed; roundover NEEDS SUPPORT)"));
echo(str("  pusher rod d", land_d - 0.40, " x ", magnet_bot + 2, " long"));

assert(magnet_d < thread_minor - hole_comp - 0.2,
  "Magnet is too big to pass the tamper thread.");
assert(oring_od < throat_d,
  "O-ring will not pass the throat.");
assert(throat_d < iso_major_max - 0.25,
  "Runout bore too big - the stud will not stop at the end of the thread.");
assert(throat_d > oring_od + 0.4,
  "Runout bore too small for the O-ring to pass.");
assert(land_d > magnet_d,
  "Snap ring must clear the magnet - the O-ring is what holds the magnet in.");
assert(land_d < oring_od,
  "Snap ring must be narrower than the O-ring or it will not retain it.");
assert(notch_d > oring_od + 1.0,
  "Service notch is too shallow to get a blade past the O-ring.");
assert(cone_bot >= thread_z1,
  str("Thread is too deep for the space available. Reduce thread_len, or raise ",
      "extra_height by at least ", thread_z1 - cone_bot, " mm."));
assert(fil_cr >= pocket_d/2,
  "crown_fillet is too large - the roundover thins the crown over the magnet.");
assert(thread_minor - hole_comp > iso_minor + 0.10,
  "Thread will bind on the stud roots. Raise thread_tol or hole_comp.");

// ===========================================================================
// Geometry
// ===========================================================================
module body() {
    rotate_extrude(convexity = 4) polygon(points = profile);
}

module lower_bores() {
    translate([0, 0, -.01]) cylinder(h = bore_lower_h, d = bore(bore_lower_d));
    translate([0, 0, -.01]) cylinder(h = shaft_height, d = bore(bore_main_d));
}

// Replicates ScrewHole()'s internal cut as a standalone solid.
module thread_cut() {
    extra = 0.001 * thread_len;
    translate([0, 0, thread_z0 - extra/2])
        ScrewThread(thread_cut_d, thread_len + extra, thread_pitch, 30, thread_tol_eff);
    if (thread_lead)
        translate([0, 0, thread_z0 - .01])
            cylinder(h = lead_h + .01, r1 = lead_r0, r2 = lead_r1);
}

module service_notches() {
    h = notch_top - notch_bot;
    intersection() {
        translate([0, 0, notch_bot]) cylinder(h = h, d = bore(notch_d));
        union() {
            for (i = [0 : notch_n - 1])
                rotate([0, 0, i * 360 / notch_n])
                    translate([0, -notch_w/2, notch_bot])
                        cube([bore(notch_d)/2, notch_w, h]);
        }
    }
}

module magnet_channel() {
    translate([0, 0, thread_z1 - .01])
        cylinder(h = cone_bot - thread_z1 + .02, d = bore(throat_d));
    translate([0, 0, cone_bot])
        cylinder(h = lead_in + .01, d1 = bore(throat_d), d2 = bore(land_d));
    translate([0, 0, land_bot])
        cylinder(h = land_h + .01, d = bore(land_d));
    translate([0, 0, oring_bot])
        cylinder(h = oring_h + .01, d = bore(oring_d));
    translate([0, 0, magnet_bot])
        cylinder(h = stack_h + .01, d = bore(pocket_d));
    service_notches();
}

module handle() {
    difference() {
        body();
        lower_bores();
        thread_cut();
        magnet_channel();
    }
}

// Short section of the real internal geometry, printed in the same
// orientation as the handle, for checking fits before a full print.
module coupon_raw(z0, z1, od) {
    intersection() {
        difference() {
            cylinder(h = tamper_height, d = od);
            lower_bores();
            thread_cut();
            magnet_channel();
        }
        translate([0, 0, z0]) cylinder(h = z1 - z0, d = od + 1);
    }
}

// Drops the slice onto the bed in whichever orientation the handle uses, so
// the coupon reproduces the same overhangs as the real print.
module coupon(z0, z1, od) {
    if (print_orientation == "crown_down")
        translate([0, 0, z1]) rotate([180, 0, 0]) coupon_raw(z0, z1, od);
    else
        translate([0, 0, -z0]) coupon_raw(z0, z1, od);
}

module pusher() {
    union() {
        cylinder(h = magnet_bot + 2, d = land_d - 0.40);
        cylinder(h = 3, d = 24);
    }
}

// ===========================================================================
module oriented() {
    if (print_orientation == "crown_down")
        translate([0, 0, tamper_height]) rotate([180, 0, 0]) children();
    else
        children();
}

scale([kscale, kscale, kscale]) {
    if (part == "handle" || part == "both")
        oriented() handle();

    if (part == "pusher" || part == "both")
        translate([part == "both" ? 45 : 0, 0, 0]) pusher();

    if (part == "testfit") {
        translate([-16, 0, 0]) coupon(24, 42, 26);                 // thread fit
        translate([ 16, 0, 0]) coupon(40.5, tamper_height, 26);     // magnet + O-ring fit
    }
}
