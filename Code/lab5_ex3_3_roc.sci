
clc;
clear;

// ===============================================
// LAB 5 - EXERCISE 3.3
// Regions of Convergence (ROC)
// Textbook-style visualization
// ===============================================

// Output folder
folder = get_absolute_file_path("lab5_ex3_3_roc.sci");
imageDir = folder + "../Images/";

if ~isdir(imageDir) then
    mkdir(imageDir);
end

figureFile = imageDir + "lab5_ex3_3_roc.png";

// ===============================================
// 1. Color palette
// ===============================================

// 1: White background
// 2: Light blue ROC region
// 3: Dark blue ROC boundary
// 4: Gray coordinate axes
// 5: Red poles
// 6: Dark text

palette = [
    1.00 1.00 1.00;
    0.85 0.93 1.00;
    0.10 0.35 0.67;
    0.45 0.48 0.53;
    0.80 0.18 0.18;
    0.10 0.22 0.37
];

cWhite = 1;
cROC = 2;
cBoundary = 3;
cAxis = 4;
cPole = 5;
cText = 6;

// ===============================================
// 2. Helper functions
// ===============================================

// Draw a colored annular ROC
function fill_ring(r1, r2, fillColor)

    N = 180;
    th = linspace(0, 2*%pi, N+1);

    XX = zeros(4, N);
    YY = zeros(4, N);

    for k = 1:N

        t1 = th(k);
        t2 = th(k+1);

        XX(:,k) = [
            r1*cos(t1);
            r2*cos(t1);
            r2*cos(t2);
            r1*cos(t2)
        ];

        YY(:,k) = [
            r1*sin(t1);
            r2*sin(t1);
            r2*sin(t2);
            r1*sin(t2)
        ];

    end

    // Negative color index: fill without outlines
    xfpolys(XX, YY, -fillColor*ones(1,N));

endfunction

// Draw ROC outside a circle
function fill_outside(r, lim, fillColor, whiteColor)

    // Fill the visible square
    xfpoly( ...
        [-lim lim lim -lim], ...
        [-lim -lim lim lim], ...
        -fillColor);

    // Remove the disk inside radius r
    th = linspace(0, 2*%pi, 361);

    xfpoly(r*cos(th), r*sin(th), -whiteColor);

endfunction

// Draw dashed circle boundary
function draw_boundary(r, lineColor)

    th = linspace(0, 2*%pi, 361);

    h = xpoly(r*cos(th), r*sin(th));

    h.foreground = lineColor;
    h.line_style = 2;
    h.thickness = 2;

endfunction

// Draw pole as a red cross
function draw_pole(x, y, poleColor)

    s = 0.10;

    h = xpoly([x-s x+s], [y-s y+s]);
    h.foreground = poleColor;
    h.thickness = 3;

    h = xpoly([x-s x+s], [y+s y-s]);
    h.foreground = poleColor;
    h.thickness = 3;

endfunction

// Draw coordinate axes
function draw_axes(lim, axisColor, textColor)

    h = xpoly([-lim lim], [0 0]);
    h.foreground = axisColor;
    h.thickness = 1;

    h = xpoly([0 0], [-lim lim]);
    h.foreground = axisColor;
    h.thickness = 1;

    xstring(lim-0.7, 0.15, "Re(z)");
    e = gce();
    e.foreground = textColor;
    e.font_size = 2;

    xstring(0.15, lim-0.35, "Im(z)");
    e = gce();
    e.foreground = textColor;
    e.font_size = 2;

endfunction

// Draw one ROC subplot
function draw_roc_panel(idx, r1, r2, titleStr, outside, lim)

    subplot(2,2,idx);

    plot2d(0, 0, -1, ...
           rect=[-lim -lim lim lim], ...
           frameflag=3, axesflag=0);

    a = gca();
    a.auto_scale = "off";
    a.tight_limits = "on";
    a.auto_clear = "off";
    a.isoview = "on";
    a.background = cWhite;
    a.margins = [0.05 0.05 0.12 0.06];

    // Shade the ROC
    if outside then
        fill_outside(r2, lim, cROC, cWhite);
    else
        fill_ring(r1, r2, cROC);
    end

    // Draw coordinate axes above the shading
    draw_axes(lim, cAxis, cText);

    // Draw ROC boundaries
    if ~outside then
        draw_boundary(r1, cBoundary);
    end

    draw_boundary(r2, cBoundary);

    // Draw poles at boundary radii
    draw_pole(r1, 0, cPole);
    draw_pole(r2, 0, cPole);

    // ROC label, placed away from boundaries
    if outside then
        labelX = -2.95;
        labelY = 1.05;
    else
        if r2 < 2.5 then
            labelX = -1.55;
            labelY = 0.75;
        else
            labelX = -2.15;
            labelY = 1.0;
        end
    end

    xstring(labelX, labelY, "ROC");
    e = gce();
    e.foreground = cText;
    e.font_size = 3;

    xtitle(titleStr);
    a.title.font_size = 3;

endfunction

// ===============================================
// 3. Create Figure
// ===============================================

scf(1);
clf();

f = gcf();
f.figure_size = [1300 1000];
f.color_map = palette;
f.background = cWhite;

// 3.3(a): 1/3 < |z| < 2
draw_roc_panel( ...
    1, 1/3, 2, ...
    "3.3(a)   1/3 < |z| < 2", ...
    %f, 2.75);

// 3.3(b): |z| > 2
draw_roc_panel( ...
    2, 1/3, 2, ...
    "3.3(b)   |z| > 2", ...
    %t, 3.4);

// 3.3(c): 1/3 < |z| < 2
draw_roc_panel( ...
    3, 1/3, 2, ...
    "3.3(c)   1/3 < |z| < 2", ...
    %f, 2.75);

// 3.3(d): 1/2 < |z| < 3
draw_roc_panel( ...
    4, 1/2, 3, ...
    "3.3(d)   1/2 < |z| < 3", ...
    %f, 3.6);

// ===============================================
// 4. Save image
// ===============================================

xs2png(gcf(), figureFile);

mprintf("=== LAB 5 - EXERCISE 3.3 ===\n");
mprintf("ROC diagrams generated.\n");
mprintf("a) 1/3 < |z| < 2\n");
mprintf("b) |z| > 2\n");
mprintf("c) 1/3 < |z| < 2\n");
mprintf("d) 1/2 < |z| < 3\n");
mprintf("Saved figure: %s\n", figureFile);
