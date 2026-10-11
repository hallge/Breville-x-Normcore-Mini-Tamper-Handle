// Breville Dual Boiler magnetic tamper handle - Normcore V4.1 MINI
// ===========================================================================
// A magnetic handle for the Normcore V4.1 spring cartridge with the V4.1
// MINI base, shaped to drop into the Breville Dual Boiler tamper recess.
// Sister file to tamper_snapin.scad (the V4 / full-height design).
//
// OUTSIDE: follows the Breville factory tamper's envelope - 92 mm
// circumference at the crown, flaring to 100 mm at 45 mm down. The crown is
// the Mini handle's own shallow arch (a R59 sphere, measured from Normcore's
// render), blended into the barrel by a tangent roundover. At the open end a
// concave finger-ledge flare sweeps out to a short lip, in the proportions of
// the ARO PortaStack's base; it stiffens the mouth of the skirt and stays
// below the part of the handle that enters the recess. Revolved from a 2D
// profile.
//
// INSIDE, from the open end up:
//   collar bore (takes the Mini base collar) -> soft tapered ledge ->
//   spring cavity -> SQUARED spring seat -> M14 x 0.75 thread ->
//   runout bore (sleeve extension + cap) -> funnel -> snap ring ->
//   O-ring -> magnet -> crown
//
// HOW THE HANDLE IS LOCATED ON THE CARTRIDGE, AND WHY IT MATTERS
// The handle's axial position on the core sleeve sets the outer spring's
// preload, and so the force at which the tamper clicks. In the Mini handle
// the female thread ends in a smooth bore that is smaller than the stud's
// major diameter, so the stud stops dead at the end of the thread (thread
// runout). The sleeve cap sits in that bore with its top at the pocket
// ceiling. This file reproduces both: the thread is the Mini's length, and
// runout_bore_d is below the stud major. Getting thread_len wrong moves the
// click force - see VERIFYING PRELOAD below.
//
// SOURCE OF THE CARTRIDGE DIMENSIONS
// Normcore publish no drawings. Every [V4.1 Mini cartridge] value below was
// measured from Normcore's own V4.1 Mini section render (800 x 800 px),
// scaled from the M14 thread: the bore wall of the threaded section is the
// thread major, 103.5 px = 14.00 mm, so 7.393 px/mm. Three independent
// checks agree within +/-1.3%:
//     75.0 mm published overall height  -> 7.520 px/mm
//     58.5 mm tamper base               -> 7.504 px/mm
//     0.75 mm pitch (5.5 px period)     -> 7.333 px/mm
// That leaves roughly +/-0.3 mm on the larger diameters. Print
// part="testfit" before committing to a full handle.
//
// VERIFYING PRELOAD
// Screw the stock Mini handle fully home and measure from its bottom face
// down to the base flange. Do the same with this handle. The two gaps should
// differ by exactly  mini_seat_z - z_seat  - the echo report prints the
// target and which way it goes. If the printed handle sits further from the
// flange than that, the thread is stopping short and the click is lighter;
// closer, and it is running too far and the click is heavier.
//
// Library (CC0 public domain):
use <threads.scad>   // https://github.com/rcolyer/threads-scad

$fn = 120;

/* [What to render] */
part = "handle";          // "handle", "pusher", "testfit", "both"
// crown_up (open end on the bed) is the only way the arched crown prints
// cleanly - it is the last surface laid down. Face-down, a R59 dome starts as
// a point and grows ~2 mm per layer, so the whole palm surface would need
// support. The cost is at the squared spring seat, which then faces down:
// seat_flat_w keeps a flat band under the spring's top coil and bevels the
// rest in to the thread at 45 deg. The stop, and so the preload, is unchanged.
print_orientation = "crown_up";     // or "crown_down" (crown needs support)

/* [Printer compensation - MEASURE THESE] */
hole_comp     = 0.15;     // diametral, added to every internal bore.
                          // Measure the lower bore on a test print and set
                          // hole_comp = lower_bore_d - measured.
shrink_comp   = 0;        // percent; leave 0 if the slicer compensates

/* [Overall] */
height        = 55.5;     // overall handle length, crown to open end.
                          // Internal layout follows Normcore's own Mini handle
                          // (~49.8 mm) with the magnet stack added above it.

/* [Breville recess envelope] */
env_top_circ  = 92;       // circumference at the crown, mm
env_base_circ = 100;      // circumference env_len below the crown, mm
env_len       = 45;
outer_trim    = 0.50;     // diameter taken off the whole barrel. The first prints
                          // were 0.5 mm too wide for the recess, so every
                          // barrel diameter below is reduced by this much. The
                          // taper angle is unchanged. 0 restores the untrimmed
                          // 92 mm / 100 mm envelope.
recess_depth  = 40;       // measured vertical depth of the machine's recess
flare_limit   = 45;       // the flare must join the body at least this far
                          // below the crown - 5 mm clear of the recess rim

/* [Crown] */
dome_r        = 59.0;     // crown arch, sphere radius. Measured from the Mini
                          // render: R59, 0.007 mm rms. 0 = flat crown.
crown_fillet  = 3.00;     // tangent roundover from the arch into the barrel.
                          // 3 matches the Mini's silhouette to within 0.36 mm.
top_skin      = 1.00;     // MINIMUM crown thickness over the magnet, taken at
                          // the pocket edge where the arch is lowest. The
                          // apex is thicker by the arch's drop there.

/* [Base flare - finger ledge] */
// Proportions of the ARO PortaStack's base flare, measured from its product
// photo and scaled to this handle's base radius. Set flare_out = 0 for a
// plain open end.
flare_out     = 0;        // NO FLARE in this variant (flair file uses 4.90).
                          // Plain open end with a base_break chamfer.
flare_r       = 5.50;     // concave radius sweeping out from the barrel
lip_h         = 1.00;     // straight vertical band of the lip
lip_round     = 1.00;     // convex round on the lip's top edge
base_break    = 0.60;     // 45 deg chamfer on the bottom outer edge

/* [Magnet] */
magnet_d      = 11.94;    // Master Magnet 07046HD, 0.47 in
magnet_t      = 3.00;     // 0.118 in
magnet_n      = 1;
magnet_fit    = 0.40;

/* [O-ring] */
oring_od      = 12.70;    // #7, 3/8 ID x 1/2 OD x 1/16
oring_cord    = 1.5875;
oring_fit     = 0.20;
oring_squeeze = 0.35;     // ~22% of cord

/* [Snap ring] */
magnet_pass   = 0.25;     // diametral CLEARANCE, magnet drops straight through
land_h        = 0.40;
lead_in       = 0.80;     // funnel from the runout bore down to the ring

/* [Service notches] */
notch_n       = 2;
notch_w       = 4.00;
notch_d       = 14.40;
notch_lead    = 1.50;

/* [V4.1 Mini cartridge - measured, see header] */
spring_bore_d   = 23.74;  // spring cavity (outer spring coils measure 23.0)
lower_bore_d    = 27.60;  // takes the Mini base collar, which measures 26.78.
                          // The render shows 27.46; opened 0.14 for FDM.
// The collar bore only needs full diameter as high as the collar can ever
// get. The hard limit is the handle's bottom face landing on the base
// flange, and at that point the collar top sits collar_reach above the face
// - whatever the handle's height. Normcore's own handle keeps the full bore
// about 5 mm higher than that, which is where the thin wall was. Stopping
// it at collar_reach + collar_margin and tapering gently into the spring
// cavity moves the ledge down into thicker wall and removes the notch.
flange_below_seat = 50.72;// base flange top, below the seat, at rest
collar_margin   = 1.00;   // clearance above the collar at full bottom-out
taper_angle     = 25;     // from vertical - soft ledge into the spring cavity
lower_lead      = 0.50;   // 45 deg chamfer at the mouth of the collar bore
seat_to_stop    = 13.26;  // squared seat up to the pocket ceiling / cap top
stop_clear      = 0.30;   // gap between the cap and the funnel
runout_bore_d   = 13.45;  // smooth bore above the thread. Must be BELOW the
                          // stud major, or the stud never stops.
collar_below_seat = 30.71;// Mini base collar top sits this far below the
                          // seat at rest
mini_seat_z     = 35.03;  // seat height in Normcore's own Mini handle

/* [Thread - M14 x 0.75, the core sleeve's top thread] */
thread_d      = 14.00;
thread_pitch  = 0.75;
thread_tol    = 0.40;     // threads-scad tolerance, validated in the V4 file
thread_len    = 7.85;     // Mini handle, measured. Sets the runout stop.
// With the open end on the bed the squared seat is a downward-facing ledge.
// Printing that way, keep only the band the spring's top coil sits on flat
// and bevel the rest in to the thread at 45 deg.
seat_flat_w   = 2.20;     // flat band kept, measured in from the cavity wall

// ===========================================================================
// Derived
// ===========================================================================
function bore(d) = d + hole_comp;

stack_h    = magnet_n * magnet_t;
pocket_d   = magnet_d + magnet_fit;
oring_d    = oring_od + oring_fit;
oring_h    = oring_cord - oring_squeeze;
land_d     = magnet_d + magnet_pass;

// -- vertical stack, built down from the crown and up from the seat --------
function dome_drop(r) = dome_r > 0 ? dome_r - sqrt(dome_r*dome_r - r*r) : 0;
pocket_r   = bore(pocket_d)/2;
skin_drop  = dome_drop(pocket_r);                // arch is this much lower there
above_seat = seat_to_stop + stop_clear + lead_in + land_h + oring_h + stack_h
           + top_skin + skin_drop;
z_seat     = height - above_seat;

crown_bot  = height - top_skin - skin_drop;
magnet_bot = crown_bot - stack_h;
oring_bot  = magnet_bot - oring_h;
land_bot   = oring_bot - land_h;
cone_bot   = land_bot - lead_in;
cap_top    = z_seat + seat_to_stop;

thread_z0  = z_seat;
thread_z1  = z_seat + thread_len;

collar_top   = z_seat - collar_below_seat;       // at rest; <0 = below the face
flange_z     = z_seat - flange_below_seat;       // at rest; face lands here
collar_reach = flange_below_seat - collar_below_seat;  // collar top at full
                                                 // bottom-out, same at any height
taper_h    = (lower_bore_d - spring_bore_d) / 2 / tan(taper_angle);
taper_bot  = collar_reach + collar_margin;       // top of the full collar bore
taper_top  = taper_bot + taper_h;
mini_full_bore_top = mini_seat_z - 9.87;         // where Normcore's stops

notch_top  = magnet_bot;
notch_bot  = cone_bot - notch_lead;

// -- thread ----------------------------------------------------------------
thread_tol_eff = thread_tol + hole_comp/1.25;
thread_cut_d   = 1.01*thread_d + 1.25*thread_tol_eff;
thread_major   = thread_cut_d + 0.25*thread_tol_eff;
thread_minor   = thread_cut_d - thread_pitch/tan(30);
iso_major_max  = thread_d - 0.022;
iso_minor      = thread_d - 1.0825*thread_pitch;

seat_cone   = (print_orientation == "crown_up");
seat_cone_r = bore(spring_bore_d)/2 - seat_flat_w;
seat_cone_h = seat_cone ? seat_cone_r - thread_major/2 : 0;
thread_eng  = thread_len - seat_cone_h;

// -- outer profile: Breville envelope ------------------------------------
top_d      = env_top_circ / PI - outer_trim;
env_taper  = (env_base_circ - env_top_circ) / PI / env_len;   // dia per mm
base_d     = top_d + env_taper * height;
function env_d(z) = top_d + env_taper * (height - z);

base_r     = base_d / 2;
top_r      = top_d / 2;
taper_dr   = (top_r - base_r) / height;
nlen       = sqrt(1 + taper_dr*taper_dr);
nr         = 1 / nlen;
nz         = -taper_dr / nlen;
// Roundover circle: tangent to the barrel line, and tangent (internally) to
// the arch circle - or to the flat crown plane when dome_r = 0. The barrel
// condition puts its centre on the line  r = fA + fB*z; the arch condition
// puts it on a circle of radius dome_r - crown_fillet about the arch centre.
flat_crown = (dome_r <= 0);
dome_cz    = height - dome_r;                    // arch centre, on the axis
fA         = base_r - crown_fillet / nr;
fB         = -nz / nr;
fK         = dome_r - crown_fillet;
qa         = fB*fB + 1;
qb         = 2*fA*fB - 2*dome_cz;
qc         = fA*fA + dome_cz*dome_cz - fK*fK;
fil_cz     = flat_crown ? height - crown_fillet
                        : (-qb + sqrt(qb*qb - 4*qa*qc)) / (2*qa);
fil_cr     = fA + fB*fil_cz;
fil_a0     = atan2(nz, nr);                      // tangent to the barrel
fil_a1     = flat_crown ? 90 : atan2(fil_cz - dome_cz, fil_cr);  // to the arch
dome_edge_r = flat_crown ? fil_cr : dome_r*cos(fil_a1);
fil_seg    = max(16, ceil($fn/4));
dome_seg   = max(16, ceil($fn/4));

// Base flare: a concave circle tangent to the barrel line, and externally
// tangent to the convex round on the lip's top edge. Same construction as
// the crown - the barrel condition gives a line for the centre, the round
// gives a circle, and the centre is where they meet.
has_flare  = flare_out > 0;
lip_r      = base_r + (has_flare ? flare_out : 0);
lq_r       = lip_r - lip_round;                  // lip round centre
lq_z       = base_break + lip_h;
gA         = base_r + flare_r / nr;
gB         = -nz / nr;
ga         = gB*gB + 1;
gb         = 2*(gA - lq_r)*gB - 2*lq_z;
gc         = (gA - lq_r)*(gA - lq_r) + lq_z*lq_z - (flare_r + lip_round)*(flare_r + lip_round);
fl_cz      = has_flare ? (-gb + sqrt(gb*gb - 4*ga*gc)) / (2*ga) : 0;
fl_cr      = gA + gB*fl_cz;
fl_t0      = atan2(-nz, -nr) + 360;              // toward the barrel tangent
fl_t1      = atan2(lq_z - fl_cz, lq_r - fl_cr) + 360;   // toward the lip round
fl_top_z   = fl_cz - flare_r*nz;                 // where the flare meets the barrel
fl_seg     = max(16, ceil($fn/4));
lr_seg     = 8;

base_pts = has_flare
  ? concat(
      [[lip_r - base_break, 0],
       [lip_r, base_break]],
      [ for (i = [0 : lr_seg])                    // lip band top, then round
          let (a = (fl_t1 - 180) * i / lr_seg)
          [lq_r + lip_round*cos(a), lq_z + lip_round*sin(a)] ],
      [ for (i = [1 : fl_seg])                    // concave sweep up to barrel
          let (t = fl_t1 - (fl_t1 - fl_t0) * i / fl_seg)
          [fl_cr + flare_r*cos(t), fl_cz + flare_r*sin(t)] ])
  : [[base_r - base_break, 0],
     [base_r, base_break]];

profile = concat(
    [[0, 0]],
    base_pts,
    [ for (i = [0 : fil_seg])
        let (t = fil_a0 + (fil_a1 - fil_a0) * i / fil_seg)
        [fil_cr + crown_fillet*cos(t), fil_cz + crown_fillet*sin(t)] ],
    flat_crown ? [[0, height]]
               : [ for (i = [1 : dome_seg])
                     let (t = fil_a1 + (90 - fil_a1) * i / dome_seg)
                     [dome_r*cos(t), dome_cz + dome_r*sin(t)] ]
);

kscale = 1 / (1 - shrink_comp/100);

// ===========================================================================
// Report
// ===========================================================================
echo(str("== OVERALL ============================================="));
echo(str("  height ", height, "  crown d", top_d, "  open end d", base_d));
echo(str("  Breville envelope: d", top_d, " at crown -> d", env_d(height - env_len),
         " at ", env_len, " mm down"));
echo(str("  crown arch R", dome_r, " across d", 2*dome_edge_r, ", drops ",
         dome_drop(dome_edge_r), " to the roundover (R", crown_fillet, ")"));
echo(str("  crown over magnet: ", top_skin, " at the pocket edge, ",
         top_skin + skin_drop, " at the apex"));
echo(str("== CARTRIDGE ==========================================="));
echo(str("  squared seat       z ", z_seat, "   (Mini handle: ", mini_seat_z, ")"));
echo(str("  thread             z ", thread_z0, " .. ", thread_z1, "  (", thread_len, " mm)"));
echo(str("  runout bore d", runout_bore_d, "  stops stud major ", iso_major_max,
         " by ", (iso_major_max - runout_bore_d)/2, " radial"));
echo(str("  sleeve cap top     z ", cap_top, "   funnel starts z ", cone_bot));
echo(str("  spring cavity d", spring_bore_d, "  z ", taper_top, " .. ", z_seat));
echo(str("  soft taper ", taper_angle, " deg  z ", taper_bot, " .. ", taper_top));
echo(str("  collar bore d", lower_bore_d, "  z 0 .. ", taper_bot,
         "  (Normcore's runs to ", mini_full_bore_top + (z_seat - mini_seat_z), ")"));
echo(str("  collar top at rest z ", collar_top,
         collar_top < 0 ? str("  -> ", -collar_top, " mm of spring shows below the handle")
                        : str("  -> ", collar_top, " mm inside the handle")));
echo(str("  base flange at rest z ", flange_z, "  -> stroke to bottom-out ", -flange_z, " mm"));
echo(str("  collar top at bottom-out z ", collar_reach, ", taper starts ", collar_margin, " above it"));
d_pre = mini_seat_z - z_seat;
echo(str("  PRELOAD CHECK: printed handle's bottom face should sit ", abs(d_pre),
         d_pre >= 0 ? " mm FURTHER from" : " mm CLOSER to",
         " the base flange than the stock Mini handle's"));
echo(str("== WALLS (as printed) =================================="));
echo(str("  at top of collar bore: ", (env_d(taper_bot) - lower_bore_d)/2,
         " mm  (was ", (env_d(mini_full_bore_top + (z_seat - mini_seat_z)) - lower_bore_d)/2,
         " with Normcore's layout)"));
echo(str("  at open-end rim    : ", (2*lip_r - 2*base_break - lower_bore_d - 2*lower_lead)/2, " mm"));
echo(str("== BASE FLARE ==========================================="));
echo(str("  lip d", 2*lip_r, " (barrel d", base_d, "), finger ledge ", flare_out, " mm deep"));
echo(str("  flare joins the body ", height - fl_top_z, " mm below the crown (limit ",
         flare_limit, "); recess rim is ", recess_depth, " mm below the crown, cleared by ",
         (height - recess_depth) - fl_top_z, " mm"));
echo(str("  at spring cavity   : ", (env_d(z_seat) - spring_bore_d)/2, " mm"));
echo(str("== THREAD ==============================================="));
echo(str("  as printed major d", thread_major - hole_comp, "  minor d", thread_minor - hole_comp));
echo(str("  root clearance ", (thread_minor - hole_comp - iso_minor)/2, " radial,  flank engagement ",
         100*(iso_major_max - (thread_minor - hole_comp))/(iso_major_max - iso_minor), " percent"));
echo(str("  engaged length ", thread_eng, " mm", seat_cone ? " (seat bevelled for crown_up)" : ""));
echo(str("== MAGNET ==============================================="));
echo(str("  funnel z ", cone_bot, "  land z ", land_bot, "  O-ring z ", oring_bot,
         "  magnet z ", magnet_bot, " .. ", crown_bot));
echo(str("  O-ring squeeze ", 100*oring_squeeze/oring_cord, " percent, shelf ",
         (oring_d - land_d)/2, " radial"));
echo(str("  pusher rod d", land_d - 0.40, " x ", magnet_bot + 2));

assert(taper_top < z_seat - 2,
  "Handle too short for the cartridge - the taper runs into the spring seat.");
assert(taper_bot > lower_lead + 0.5,
  "Collar bore is shorter than its own lead-in chamfer.");
assert(flange_z < 0,
  "Base flange sits inside the handle at rest - the handle is too long below the seat.");
assert(runout_bore_d < iso_major_max - 0.25,
  "Runout bore too big - the stud will not stop at the end of the thread.");
assert(runout_bore_d > oring_od + 0.4,
  "Runout bore too small for the O-ring to pass.");
assert(thread_minor - hole_comp > oring_od + 0.3,
  "Thread minor too small for the O-ring to pass.");
assert(land_d > magnet_d && land_d < oring_od,
  "Snap ring must clear the magnet and catch the O-ring.");
assert(cone_bot >= cap_top + 0.1,
  "Funnel would hit the sleeve cap.");
assert(!has_flare || gb*gb - 4*ga*gc >= 0,
  "Base flare cannot be solved - reduce lip_round or increase flare_r.");
assert(!has_flare || fl_top_z <= height - flare_limit,
  str("Base flare joins the body ", height - fl_top_z, " mm below the crown - it must be at least ",
      flare_limit, " mm down to stay clear of the recess rim at ", recess_depth, " mm."));
assert(dome_edge_r >= pocket_r,
  "crown_fillet too large - the roundover reaches in over the magnet pocket.");
assert(flat_crown || qb*qb - 4*qa*qc >= 0,
  "No roundover fits between this arch and the barrel - increase dome_r.");
assert((env_d(taper_bot) - lower_bore_d)/2 >= 1.2,
  "Wall at the lower bore is under 1.2 mm - too thin inside the Breville envelope.");
assert(thread_minor - hole_comp > iso_minor + 0.10,
  "Thread will bind on the stud roots.");

// ===========================================================================
// Geometry
// ===========================================================================
module body() {
    rotate_extrude(convexity = 4) polygon(points = profile);
}

// open end, collar bore, soft taper, spring cavity - ends exactly at the
// squared seat
module lower_cavity() {
    translate([0, 0, -.01])
        cylinder(h = taper_bot + .02, d = bore(lower_bore_d));
    translate([0, 0, -.01])
        cylinder(h = lower_lead + .01,
                 d1 = bore(lower_bore_d) + 2*lower_lead, d2 = bore(lower_bore_d));
    translate([0, 0, taper_bot])
        cylinder(h = taper_h + .01, d1 = bore(lower_bore_d), d2 = bore(spring_bore_d));
    translate([0, 0, taper_top])
        cylinder(h = z_seat - taper_top, d = bore(spring_bore_d));
}

module thread_cut() {
    extra = 0.001 * thread_len;
    translate([0, 0, thread_z0 - extra/2])
        ScrewThread(thread_cut_d, thread_len + extra, thread_pitch, 30, thread_tol_eff);
    if (seat_cone)
        translate([0, 0, z_seat - .01])
            cylinder(h = seat_cone_h + .01, r1 = seat_cone_r, r2 = thread_major/2);
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
    // runout bore: holds the sleeve extension and cap, and stops the stud
    translate([0, 0, thread_z1 - .01])
        cylinder(h = cone_bot - thread_z1 + .02, d = bore(runout_bore_d));
    translate([0, 0, cone_bot])
        cylinder(h = lead_in + .01, d1 = bore(runout_bore_d), d2 = bore(land_d));
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
        lower_cavity();
        thread_cut();
        magnet_channel();
    }
}

// A slice of the real handle, dropped onto the bed in the handle's print
// orientation so it reproduces the same walls and overhangs.
module coupon_raw(z0, z1) {
    intersection() {
        handle();
        translate([0, 0, z0]) cylinder(h = z1 - z0, d = 60);
    }
}
module coupon(z0, z1) {
    if (print_orientation == "crown_down")
        translate([0, 0, z1]) rotate([180, 0, 0]) coupon_raw(z0, z1);
    else
        translate([0, 0, -z0]) coupon_raw(z0, z1);
}

module pusher() {
    union() {
        cylinder(h = magnet_bot + 2, d = land_d - 0.40);
        cylinder(h = 3, d = 24);
    }
}

module oriented() {
    if (print_orientation == "crown_down")
        translate([0, 0, height]) rotate([180, 0, 0]) children();
    else
        children();
}

// ===========================================================================
scale([kscale, kscale, kscale]) {
    if (part == "handle" || part == "both")
        oriented() handle();

    if (part == "pusher" || part == "both")
        translate([part == "both" ? 45 : 0, 0, 0]) pusher();

    if (part == "testfit") {
        // collar fit: open end, collar bore, taper
        translate([-38, 0, 0]) coupon(0, taper_top + 1.5);
        // cartridge fit: spring seat, full thread, runout stop, cap clearance
        translate([  0, 0, 0]) coupon(z_seat - 3, cone_bot + 0.5);
        // magnet + O-ring + snap ring
        translate([ 38, 0, 0]) coupon(cone_bot - 1, height);
    }
}
