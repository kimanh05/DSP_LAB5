
clc;
clear;

// ========================================
// LAB 5 - EXERCISE 3.20
// Pole-Zero Diagram
// Example: r = 0.8, omega0 = pi/4
// ========================================

folder = get_absolute_file_path("lab5_ex3_20_pz.sci");
imageDir = folder + "../Images/";

if ~isdir(imageDir) then
    mkdir(imageDir);
end

figureFile = imageDir + "lab5_ex3_20_pz.png";

// ========================================
// Parameters
// ========================================

r = 0.8;
omega0 = %pi/4;

px = r*cos(omega0);
py = r*sin(omega0);

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

// ========================================
// Drawing functions
// ========================================

function line20(x1, y1, x2, y2, col)
    h = xpoly([x1 x2], [y1 y2]);
    h.foreground = col;
    h.thickness = 2;
endfunction

function circle20(x, y, radius, col, dashed)
    t = linspace(0, 2*%pi, 361);

    h = xpoly( ...
        x+radius*cos(t), ...
        y+radius*sin(t));

    h.foreground = col;
    h.thickness = 2;

    if dashed then
        h.line_style = 2;
    end
endfunction

function pole20(x, y)
    s = 0.055;

    line20(x-s, y-s, x+s, y+s, 4);
    line20(x-s, y+s, x+s, y-s, 4);
endfunction

function label20(x, y, txt)
    xstring(x, y, txt);
    e = gce();
    e.foreground = 5;
    e.font_size = 3;
endfunction

// ========================================
// Create Figure
// ========================================

scf(3);
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
line20(-1.25, 0, 1.25, 0, 2);
line20(0, -1.25, 0, 1.25, 2);

// Unit circle
circle20(0, 0, 1, 2, %t);

// Circle containing the poles: |z| = r
circle20(0, 0, r, 3, %t);

// Zero at origin
circle20(0, 0, 0.045, 3, %f);

// Two conjugate poles
pole20(px, py);
pole20(px, -py);

// Labels
label20(-0.43, -0.16, "z0 = 0");

label20(0.68, 0.64, "p1");
label20(0.68, -0.69, "p2");

label20(0.98, 0.10, "Re(z)");
label20(0.08, 1.12, "Im(z)");

label20(-1.20, 1.16, "Example: r = 0.8, omega0 = pi/4");
label20(-1.20, -1.22, "Causal ROC: |z| > r");

// Title
xtitle("3.20 - Pole-Zero Diagram");
a.title.font_size = 4;

// ========================================
// Save Figure
// ========================================

xs2png(gcf(), figureFile);

mprintf("=== LAB 5 - EXERCISE 3.20 ===\n");
mprintf("r = %.4f\n", r);
mprintf("omega0 = pi/4\n");

mprintf("Zero: z = 0\n");

mprintf("Pole 1: %.4f + j%.4f\n", px, py);
mprintf("Pole 2: %.4f - j%.4f\n", px, py);

mprintf("Causal ROC: |z| > %.4f\n", r);
mprintf("Saved figure: %s\n", figureFile);
