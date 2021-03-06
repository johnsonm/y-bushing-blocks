The SCS8UU bearing blocks that came with my acrylic HICTOP
i3 clone were not particularly precise and have bearings
that chatter, leaving artifacts in the print. I bought
two kinds of bronze bearings for smoother movement; [graphite
inserts](https://www.amazon.com/Micromake-Printer-Ultimaker-Graphite-Bearing/dp/B06XV28WHG)
and [oil-impregnated
self-lubricating](https://www.amazon.com/uxcell-Self-lubricating-Bushing-Sleeve-Bearings/dp/B076P9PD2B)
bronze. However, I found that when I mounted them in printed
SCS8UU-style pillow blocks, they were insufficiently aligned and
over-constrained and the print bed did not move smoothly. This design
resolves that by printing one piece for the left side of the bed
where two SCS8UU blocks are normally mounted, and by constraining
a much shorter section of the individual bushings. The default
settings here are for the 30mm-long bushings, but can be set to
other normal lengths easily.  The preview (F5) mode in OpenSCAD
shows where the bearings go.

The long bearing holders should be attached by only four (or perhaps
fewer) screws. You can print two long holders and use one on each
side, in which case you fasten one with the outer screws and one
with the inner screws to match the holes in the "frog," or you can
print one of each.  Printing two long holders should make the Y
friction loads more even, resulting in less bed yaw, except that
they are very easy to make or install to be over-constraining,
which will result in terrible yaw.

I used an M4 spiral tap to cut the threads; it clears plastic
out better than a straight flute tap. You can use melt-in inserts
instead, but sufficient alignment may be very hard to maintain,
and the base is thick enough for working plastic threads in my
experience so far.
