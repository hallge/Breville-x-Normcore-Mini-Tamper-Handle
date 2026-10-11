# Breville x Normcore Mini tamper handle

Parametric OpenSCAD handles for the **Normcore spring-loaded tamper**, shaped
to sit in the tamper recess of a **Breville Dual Boiler** and hold a hidden
magnet, so the tamper hangs from the machine. The magnet is fitted **after**
printing - there is no mid-print pause.

| File | Fits | Notes |
|---|---|---|
| `files/tamper_mini_flair.scad` | Normcore **V4.1 Mini** cartridge and base | Finger-ledge flare at the open end. 55.5 mm. |
| `files/tamper_mini_noflair.scad` | same | Same handle with `flare_out = 0`. |
| `files/tamper_snapin.scad` | Normcore **V4** (not 4.1) | Full-height V4 handle with the same magnet retention. |

`files/tamper.scad` / `tamper.stl` are the original design these grew from
(see [NOTICE.md](NOTICE.md)).

## How the magnet is held

A Master Magnet 07046HD disc (0.47 in x 0.118 in) and a #7 O-ring
(3/8 x 1/2 x 1/16 in) are pushed up the open bottom, past the M14 thread, into
a pocket under the crown:

- the **crown** stops the magnet going up,
- the **squeezed O-ring** stops it coming down and clamps it against the crown,
- a **snap ring** stops the O-ring. The magnet itself passes through the ring
  freely.

Two service notches cut through the snap ring, so a narrow slotted screwdriver
can collapse the O-ring and let it out.

## Outside shape

The barrel follows the Breville factory tamper's recess: 92 mm circumference at
the crown flaring to 100 mm at 45 mm down, **less `outer_trim` (0.50 mm of
diameter)**. The first prints came out 0.5 mm too wide for the recess; the
trim fixes that without changing the taper. The Mini files add the Mini's own
R59 crown arch and an R3 corner. The flare joins the body 47.7 mm below the
crown, clear of the 40 mm deep recess.

## Printing

- Print **crown up** (open end on the bed). The arched crown is the last
  surface laid down and everything prints without supports.
- Material target: **PA6-CF**. `hole_comp` (0.15 mm) is added to every internal
  bore; **measure your own** and set `hole_comp = nominal - measured`.
  Leave `shrink_comp` at 0 if your slicer already compensates.
- `part = "testfit"` renders three short slices (collar bore, thread/stop,
  magnet stack) to check fits before committing to a full handle.
- `part = "pusher"` renders a rod for seating the magnet and O-ring.
- Render with the **Manifold** backend (Preferences > Features); CGAL takes
  minutes on the thread.
- Export STLs yourself - none are committed.

## Thread

The tamper's top stud is **M14 x 0.75**, right-hand. In the Mini files the
thread ends in a smooth bore narrower than the stud, which stops it dead and
sets the spring preload. Normcore publish no dimensions, so this was
cross-checked against other people's handles that fit the same stud. Normcore's
own Mini handle's squared spring seat is at z 35.03 mm; these are 0.14 mm off
that, and the echo report prints the exact preload check to do against the
stock handle.

## Status

The geometry has been checked numerically (tangent joins, wall thicknesses,
clearances and asserts), but **the 0.5 mm trim has not been printed yet**.
Mini cartridge dimensions were measured from Normcore's product render, so
expect about +/-0.3 mm on the larger diameters.

The thinnest part of the Mini handle is the wall at the top of the collar bore
(about 1.57 mm after the trim). The no-flare variant has a 1.06 mm rim at the
open end; the flare variant has 5.96 mm there.

## License

CC BY-NC-SA 3.0, inherited from the original design. See
[LICENSE.md](LICENSE.md) and [NOTICE.md](NOTICE.md).
