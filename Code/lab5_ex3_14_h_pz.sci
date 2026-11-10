
clc;
clear;

// ========================================
// LAB 5 - EXERCISE 3.14(h)
// Pole-Zero Diagram
// ========================================

folder = get_absolute_file_path("lab5_ex3_14_h_pz.sci");
imageDir = folder + "../Images/";

if ~isdir(imageDir) then
    mkdir(imageDir);
end

figureFile = imageDir + "lab5_ex3_14_h_pz.png";

// ========================================
// Color palette
// ========================================

palette = [
    1.00 1.00 1.00;
    0.65 0.69 0.73;
    0.12 0.38 0.72;
    0.82 0.20 0.22;
    0.12 0.17 0.24
];

// 1 = white, 2 = gray, 3 = blue
// 4 = red, 5 = dark text

// ========================================
// Drawing functions
// ========================================

function line14(x1, y1, x2, y2, col)
    h = xpoly([x1 x2], [y1 y2]);
    h.foreground = col;
    h.thickness = 2;
endfunction

function circle14(x, y, r, col, dashed)
    t = linspace(0, 2*%pi, 361);

    h = xpoly(x+r*cos(t), y+r*sin(t));
    h.foreground = col;
    h.thickness = 2;

    if dashed then
        h.line_style = 2;
    end
endfunction

function pole14(x, y)
    s = 0.055;

    line14(x-s, y-s, x+s, y+s, 4);
    line14(x-s, y+s, x+s, y-s, 4);
endfunction

function label14(x, y, txt)
    xstring(x, y, txt);
    e = gce();
    e.foreground = 5;
    e.font_size = 3;
endfunction

// ========================================
// Figure
// ========================================

scf(2);
clf();

f = gcf();
f.figure_size = [1000 820];
f.color_map = palette;
f.background = 1;

plot2d(0, 0, -1, ...
    rect=[-1.35 -1.35 1.35 1.35], ...
    frameflag=3, axesflag=0);

a = gca();
a.isoview = "on";
a.auto_scale = "off";
a.tight_limits = "on";
a.margins = [0.07 0.07 0.12 0.06];

// Coordinate axes
line14(-1.25, 0, 1.25, 0, 2);
line14(0, -1.25, 0, 1.25, 2);

// Unit circle (reference)
circle14(0, 0, 1, 2, %t);

// ROC boundary (outermost pole radius)
circle14(0, 0, 1/sqrt(2), 3, %t);

// Zeros: blue circles
circle14(-0.5, 0, 0.045, 3, %f);
circle14(-0.25, 0, 0.045, 3, %f);

// Poles: red crosses
pole14(0.5, 0);
pole14(0.5, 0.5);
pole14(0.5, -0.5);

// Labels
label14(-0.91, 0.15, "z1 = -1/2");
label14(-0.55, -0.24, "z2 = -1/4");

label14(0.59, 0.10, "p1");
label14(0.62, 0.54, "p2");
label14(0.62, -0.64, "p3");

label14(0.98, 0.10, "Re(z)");
label14(0.08, 1.12, "Im(z)");

label14(-1.20, 1.15, "Unit circle: |z|=1");
label14(-1.20, -1.22, "Causal ROC: |z| > 1/sqrt(2)");

// Title
xtitle("3.14(h) - Pole-Zero Diagram");
a.title.font_size = 4;

// Save Figure
xs2png(gcf(), figureFile);

mprintf("=== LAB 5 - EXERCISE 3.14(h) ===\n");
mprintf("Zeros: -0.5, -0.25\n");
mprintf("Poles: 0.5, 0.5+0.5j, 0.5-0.5j\n");
mprintf("Causal ROC: |z| > 1/sqrt(2)\n");
mprintf("Saved figure: %s\n", figureFile);
