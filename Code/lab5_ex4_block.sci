
clc;
clear;

// ========================================
// Lab 5 - Exercise 4
// First-Order LTI System - Block Diagram
// ========================================

folder = get_absolute_file_path("lab5_ex4_block.sci");
imageDir = folder + "../Images/";

if ~isdir(imageDir) then
    mkdir(imageDir);
end

figureFile = imageDir + "lab5_ex4_block.png";

// ========================================
// Drawing functions
// ========================================

function line4(x1, y1, x2, y2)
    h = xpoly([x1 x2], [y1 y2]);
    h.foreground = color("blue");
    h.thickness = 2;
endfunction

function arrow4(x1, y1, x2, y2)
    xarrows([x1 x2], [y1 y2], 0.22, color("blue"));
endfunction

function block4(x, y, w, h, txt)
    xrect(x, y+h, w, h);
    xstringb(x, y, txt, w, h, "fill");
endfunction

function sum4(cx, cy)
    r = 0.35;
    xarc(cx-r, cy+r, 2*r, 2*r, 0, 360*64);
    xstringb(cx-r, cy-r, "+", 2*r, 2*r);
endfunction

// ========================================
// Create figure
// ========================================

scf(12);
clf();

gcf().figure_size = [1200 650];

plot2d(0, 0, -1, ...
       rect=[0 0 14 9], ...
       frameflag=1, axesflag=0);

xstring(4.0, 7.8, "First-Order LTI System");

// Input and summing junction
sum4(6.7, 5.8);

xstring(1.2, 6.15, "x(n)");
arrow4(1.7, 5.8, 6.35, 5.8);

// Output
arrow4(7.05, 5.8, 12.6, 5.8);
xstring(12.1, 6.15, "y(n)");

// Feedback branch
line4(11.6, 5.8, 11.6, 2.7);
arrow4(11.6, 2.7, 10.8, 2.7);

// Unit delay
block4(9.4, 2.3, 1.4, 0.8, "z^-1");

arrow4(9.4, 2.7, 8.3, 2.7);

// Feedback gain
block4(7.3, 2.3, 1.0, 0.8, "0.7");

line4(7.3, 2.7, 6.7, 2.7);
arrow4(6.7, 2.7, 6.7, 5.45);

// Export image
xs2png(gcf(), figureFile);

mprintf("Lab 5 - Exercise 4\n");
mprintf("System: y(n) = 0.7*y(n-1) + x(n)\n");
mprintf("Saved figure: %s\n", figureFile);
