include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

tube(od = 24, h = 30, wall = 2, anchor = BOT);
right(0) yrot(90)
tube(od = 24, h = 12, wall = 2, anchor = BOT + RIGHT);