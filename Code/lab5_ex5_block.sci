
clc;
clear;

// ==========================================
// Lab 5 - Exercise 5
// Second-Order LTI System - Direct Form I
// ==========================================

// Output folder
folder = get_absolute_file_path("lab5_ex5_block.sci");
imageDir = folder + "../Images/";

if ~isdir(imageDir) then
    mkdir(imageDir);
end

figureFile = imageDir + "lab5_ex5_block.png";

// ==========================================
// Drawing functions
// ==========================================

// Draw a line
function wire5(x1, y1, x2, y2)
    h = xpoly([x1 x2], [y1 y2]);
    h.foreground = color("blue");
    h.thickness = 2;
endfunction

// Draw an arrow with a visible arrowhead
function arrow5(x1, y1, x2, y2)
    wire5(x1, y1, x2, y2);

    dx = x2 - x1;
    dy = y2 - y1;
    L = sqrt(dx^2 + dy^2);

    ux = dx / L;
    uy = dy / L;

    head = 0.17;
    wing = 0.085;

    bx = x2 - head*ux;
    by = y2 - head*uy;

    wire5(bx - wing*uy, by + wing*ux, x2, y2);
    wire5(bx + wing*uy, by - wing*ux, x2, y2);
endfunction

// Draw a rectangular block
function block5(x, y, w, h, txt)
    r = xrect(x, y+h, w, h);
    r.thickness = 2;
    xstringb(x, y, txt, w, h, "fill");
endfunction

// Draw a summing junction
function sum5(cx, cy)
    r = 0.34;
    a = xarc(cx-r, cy+r, 2*r, 2*r, 0, 360*64);
    a.thickness = 2;
    xstringb(cx-r, cy-r, "+", 2*r, 2*r, "fill");
endfunction

// Draw a branching point
function junction5(x, y)
    r = 0.065;
    xfarc(x-r, y+r, 2*r, 2*r, 0, 360*64);
endfunction

// ==========================================
// Create figure
// ==========================================

scf(13);
clf();

gcf().figure_size = [1400 800];

plot2d(0, 0, -1, ...
       rect=[0 0 16 10], ...
       frameflag=1, axesflag=0);

xstring(5.4, 8.8, ...
        "Second-Order LTI System - Direct Form I");

// ==========================================
// 1. Main signal path
// ==========================================

// Summing junctions
sum5(5.2, 7.4);
sum5(8.2, 7.4);
sum5(11.5, 7.4);

// Input
xstring(0.65, 7.75, "x(n)");

arrow5(1.25, 7.4, 4.86, 7.4);
arrow5(5.54, 7.4, 7.86, 7.4);
arrow5(8.54, 7.4, 11.16, 7.4);

// Output
arrow5(11.84, 7.4, 15.2, 7.4);
xstring(14.4, 7.75, "y(n)");

// ==========================================
// 2. Feedforward path: x(n-1)
// ==========================================

// Branch from input x(n)
junction5(1.9, 7.4);

wire5(1.9, 7.4, 1.9, 5.25);
arrow5(1.9, 5.25, 3.0, 5.25);

// Unit delay
block5(3.0, 4.85, 1.2, 0.8, "z^-1");

// Connect delayed input to first adder
wire5(4.2, 5.25, 5.2, 5.25);
arrow5(5.2, 5.25, 5.2, 7.06);

xstring(4.25, 5.55, "x(n-1)");

// ==========================================
// 3. Feedback path: y(n-1)
// ==========================================

// Branch from system output
junction5(13.7, 7.4);

wire5(13.7, 7.4, 13.7, 3.6);
arrow5(13.7, 3.6, 13.0, 3.6);

// First output delay
block5(12.0, 3.2, 1.0, 0.8, "z^-1");

// Delayed output
arrow5(12.0, 3.6, 10.7, 3.6);

xstring(10.2, 3.95, "y(n-1)");

// Branch to gain +2
junction5(11.5, 3.6);

wire5(11.5, 3.6, 11.5, 5.05);

// Gain block
block5(11.05, 5.05, 0.9, 0.8, "2");

// Connect to third adder
arrow5(11.5, 5.85, 11.5, 7.06);

// ==========================================
// 4. Feedback path: y(n-2)
// ==========================================

// Branch from y(n-1)
junction5(10.7, 3.6);

wire5(10.7, 3.6, 10.7, 2.0);
arrow5(10.7, 2.0, 9.7, 2.0);

// Second output delay
block5(8.6, 1.6, 1.1, 0.8, "z^-1");

// Delayed signal
arrow5(8.6, 2.0, 8.2, 2.0);

xstring(7.1, 2.35, "y(n-2)");

// Gain -3
wire5(8.2, 2.0, 8.2, 5.05);
block5(7.75, 5.05, 0.9, 0.8, "-3");

// Connect to second adder
arrow5(8.2, 5.85, 8.2, 7.06);

// ==========================================
// 5. Export figure
// ==========================================

xs2png(gcf(), figureFile);

mprintf("=== LAB 5 - EXERCISE 5 ===\n");
mprintf("Structure: Direct Form I\n");
mprintf("System: y(n) = 2*y(n-1) - 3*y(n-2)");
mprintf(" + x(n) + x(n-1)\n");
mprintf("Number of delay blocks: 3\n");
mprintf("Saved figure: %s\n", figureFile);
