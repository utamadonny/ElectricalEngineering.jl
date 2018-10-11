export j, pol, phasor, phasorsine, angulardimension, phasordimension

doc"""
`j = 1im` equals the imaginary unit
"""
const j=1im

doc"""
# Function call

`pol(r, phi)`

# Description

Creates a complex quantity with length `r` and angle `phi`

# Variables

`r` Length of complex quantity; r may be utilized including a unit generated by
Unitful

`phi` Angle of complex quantity; if module Unitful is utilized, the angle may be
specified in degrees, by using unit `°`

# Examples

```julia
julia> using Unitful, Unitful.DefaultSymbols, EE
julia> U1 = pol(2V,pi)
-2 + 0im V
julia> U2 = pol(sqrt(2)*1V,45°)
1 + 1im V
```
"""
function pol(r, phi)
  return r*cos(phi) + 1im*r*sin(phi)
end

doc"""
# Function call

```
phasor(c;origin=0.0+0.0im, ref=1, par=0,
    labelrsep=0.5, labeltsep=0.1, label="", ha="center", va="center",
    labelrelrot=false, labelrelangle=0,
    color="black", backgroundcolor="none", linesstyle="-", linewidth=1,
    width=0.2, headlength=10, headwidth=5)
```

# Description

This function draws a phasor from a starting point `origin` and end point
`origin`+`c`. The phasor consists of a shaft and an arrow head.

Each phasor c is plotted as a relative quantity, i.e., `c/ref` is actually
shown the plot figure. This concept of plotting a per unit phasor is used to
be able to plot phasor with different quantities, e.g., voltage and current
phasors. It is important that the variables `c`, `origin` and `ref` have the
same units (defined through Unitful).

# Variables

`c` Complex phasor, drawn relative relative to `origin`

`origin` Complex number representing the origin of the phasor; this variable
needs to have the same unit as `c`

`ref` Reference length of scaling; this is required as in a phasor diagram
voltages and currents may be included; in order to account for the different
voltage and current scales, one (constant)  `ref` is used for voltage
phasors and another (constant) `ref` is used for current phasors; this
variable needs to have the same unit as `c`

`par` In order to be able to plot parallel phasors, par is used to specify
the per unit tangential shift (offset) of a phasor, with respect to `ref`;
so typically `ref` will be selected to be around 0.05 to 0.1;
default value = 0 (no shift of phasor)

`labelrsep` Radial per unit location of label (in direction of the phasor):
`labelrsep = 0` represents the shaft of the phasor and `labelrsep = 1` represents
the arrow hear of the phasor; default value = 0.5, i.e., the radial center
of the phasor

`labeltsep` Tangential per unit location of label: `labeltsep = 0` means that the
label is plotted onto the phasor; `labeltsep = 0.1` plots the label on top of
the phasor applying a displacement of 10% with respect to `ref`;
`labeltsep = -0.2` Plots the label below the
phasor applying a displacement of 20% with respect to `ref`; default value
= 0.1

`ha` Horizontal alignment of label; actually represents the tangential
alignment of the label; default value = "center"

`va` Vertical alignment of label; actually represents the radial
alignment of the label; default value = "center"

`labelrelrot` Relative rotation of label; if `labelrelrot == false` (default
value) then the label is not rotated relative to the orientation of the phasor;
otherwise the label is rotated relative to the phasor by the angle
`labelrelangle`

`labelrelangle` Relative angle of label  with respect to phasor orientation;
this angle is only applied, it `labelrelrot == true`; this angle the indicates
the relative orientation of the label with respect to the orientation of the
phasor; default value = 0

`color` Color of the phasor; i.e., shaft and arrow head color; default
value = "black"

`backgroundcolor` Background color of the label; if labelrsep is equal to 0, the
background color "white" can be used; default value = "none"

`linestyle` Line style of the phasor; default value = "-"

`linewidth` Line width of the phasor; default value = 1

`width` Line width of the shaft line; default value = 0.2

`headlength` Length of arrow head; default value = 10

`headwidth` Width of arrow head; default value = 5

# Example

Copy and paste code:

```julia
using Unitful, Unitful.DefaultSymbols, PyPlot, EE
figure(figsize=(3.3, 2.5))
rc("text", usetex=true); rc("font", family="serif")
V1 = 100V + j*0V # Voltage
Z1 = 30Ω + j*40Ω # Impedance
I1 = V1/Z1 # Current
Vr = real(Z1)*I1
Vx = V1 - Vr
refV = abs(V1); refI=abs(I1)*0.8
phasor(V1, label=L"$\underline{V}_1$", labeltsep=0.1, ref=refV,
    labelrelrot=true)
phasor(Vr, label=L"$\underline{V}_r$", labeltsep=-0.25, ref=refV,
    labelrelrot=true)
phasor(Vx, origin=Vr, label=L"$\underline{V}_x$", labeltsep=-0.2, ref=refV,
    labelrelrot=true)
phasor(I1, label=L"$\underline{I}_1$", labeltsep=-0.2, labelrsep=0.7, ref=refI,
    labelrelrot=true, linestyle="--", par=-0.05)
phi1=angle(I1)
phi2=angle(V1)
angulardimension(0.3,phi1,phi2,arrowstyle1=".",arrowstyle2="-|>",ha="left",
    label=L"$\varphi_1$", labelrsep=0.05)
axis("square"); xlim(-1,1); ylim(-1,1)
removeaxes(); # Remove axis
# save3fig("phasordiagram",crop=true);
```
"""
function phasor(c;
    origin = (0.0+0.0im).*c./ustrip(c),
    ref = abs(c./ustrip(c)),
    par = 0.0,
    labelrsep = 0.5,
    labeltsep = 0.1,
    label = "",
    ha = "center",
    va = "center",
    labelrelrot = false,
    labelrelangle = 0.0,
    color = "black",
    backgroundcolor = "none",
    linestyle = "-",
    linewidth = 1,
    width = 0.2,
    headlength = 10.0,
    headwidth = 5.0)

    # Check if units of c, origin and ref are compatible
    # Starting point (origin) of phase
    xorigin = 0.0
    yorigin = 0.0
    xend = 0.0
    yend = 0.0
    try
        xorigin = uconvert(Unitful.NoUnits, real(origin)./ref)
        yorigin = uconvert(Unitful.NoUnits, imag(origin)./ref)
        # End point of phasor
        xend = uconvert(Unitful.NoUnits, real(origin+c)./ref)
        yend = uconvert(Unitful.NoUnits, imag(origin+c)./ref)
    catch err
        error("module EE: function phasor: Dimension mismatch of arguments `c`, `origin` and `ref`\n    The arguments `c`, `origin` and `ref` must have the same dimension (koherent SI unit)")
    end

    # Draw phasor only if length of c is greater than zero, see
    # https://github.com/christiankral/EE.jl/issues/1
    if upstrip(c)>0
        # Length of phasor
        dr = sqrt((xend-xorigin)^2 + (yend-yorigin)^2)
        # Real part of phasor
        drx = (xend - xorigin)/dr # = real(c)./ref
        # Imag part of phasor
        dry = (yend - yorigin)/dr # = imag(c)./ref
        # Angle of phasor
        absangle = atan2(dry, drx)
        # Orientation tangential to phasor (lagging by 90°)
        # Real part of tangential component with respect to length
        dtx = +dry
        # Imag part of tangential component with respect to length
        dty = -drx
        # Real part of parallel shift of phasor
        dpx = -par*dtx
        # Imag part of parallel shift of phasor
        dpy = -par*dty
        # Origin of head
        xoriginHead = xorigin + dr*drx*0.999
        yoriginHead = yorigin + dr*dry*0.999
        # Draw arrow shaft and head
        # https://matplotlib.org/api/_as_gen/matplotlib.pyplot.annotate.html?highlight=annotate#matplotlib.pyplot.annotate
        # Draw shaft separately: otherwise, the arrow contour will be drawn as in
        # https://matplotlib.org/users/annotations.html#basic-annotation
        # so that the back and forth paths overlap and the line style does not
        # appear correctly; replace
        plot([xorigin+dpx,xend+dpx], [yorigin+dpy,yend+dpy],
            color=color, linestyle=linestyle, linewidth=linewidth, clip_on=false)
        # Code based on plot replaces the previous implementation inspired by:
        # https://stackoverflow.com/questions/51746400/linestyle-in-plot-and-annotate-are-not-equal-in-matplotlib
        # Previous (obsolete) implementation:
        # annotate("", xy=(xend+dpx,yend+dpy),
        #     xytext=(xorigin+dpx,yorigin+dpy), xycoords="data",
        #     arrowprops=Dict("arrowstyle"=>"-",
        #         "linestyle"=>linestyle,
        #         "linewidth"=>linewidth,
        #         "color"=>color,
        #         "facecolor"=>color),
        #     annotation_clip=false)

        # Draw arrow head without line style; this is a workaround explained in
        # https://stackoverflow.com/questions/47180328/pyplot-dotted-line-with-fancyarrowpatch/47205418#47205418
        annotate("", xy=(xend+dpx, yend+dpy),
            xytext=(xoriginHead+dpx, yoriginHead+dpy), xycoords="data",
            arrowprops=Dict("edgecolor"=>color, "facecolor"=>color,
                "width"=>width, "linestyle"=>"-",
                "headlength"=>headlength,
                "headwidth"=>headwidth),
            annotation_clip=false)

        # Plot label
        if labelrelrot == false
            # Without relative rotation of label
            text(xorigin + dr*drx*labelrsep - dtx*labeltsep + dpx,
                yorigin + dr*dry*labelrsep - dty*labeltsep + dpy,
                label, ha=ha, va=va, rotation=labelrelangle*180/pi,
                backgroundcolor=backgroundcolor)
        else
            # Applying relative rotation of label
            text(xorigin + dr*drx*labelrsep - dtx*labeltsep + dpx,
                yorigin + dr*dry*labelrsep - dty*labeltsep + dpy,
                label, ha=ha, va=va, rotation=(absangle+labelrelangle)*180/pi,
                backgroundcolor=backgroundcolor)
        end
    end
end

doc"""
# Function call

```
phasorsine(mag = 1, phi = 0; add = false, figsize = (6.6,2.5),
    xlabel = L"$\omega t$\,($^\circ $)", ylabel = "", maglabel = "",
    phasorlabel = maglabel, labeltsep = 0.1, labelrsep = 0.5,
    labelrelrot = true, labelrelangle = 0,
    color = "black", linewidth = 1, linestyle = "-",
    colorDash="gray", left=0.20, right=0.80, bottom=0.20, top=0.80,
    showsine=true, showdashline=true)
```

# Description

This function draws a phasor with magnitude between 0 and 1 on the left subplot
of a figure and a sine diagram on the right subplot of the figure. Such graph
is used in electrical engineering to explain the relationship between phasors
and time domain wave forms.

# Variables

`mag` Magnitude of displayed phasor; shall be between 0 and 1;
default value = 1

`phi` Phase angle of the phasor; default value = 0

`add` When calling this function the first time, `add` shall be equal to
`false`, which is the default value. In this case a new figure with the
dimensions specified in `figsize` is created. In order to add a second phasor
and sine diagram to an existing figure, `add` has to be set `true`

`figsize` Size of the new figure, if `add` is equal to `false`; default value
= (6.6,2.5)

`xlabel` Label of x-axis of right subplot; default value ="ωt(°)" in LaTeX
notation

`ylabel` label of y-axis of right subplot; default value = "";  if more than one
phasors and sine diagram shall be drawn (`add = true`), this label is displayed
only once; therefore, one has to create the label of all phasors when function
`phasorsine` is called the first time for creating a figure

`maglabel` Label of positive and negative magnitude `mag` on the right subplot;
dafault value = "";

`phasorlabel` Label of phasor of left subplot; default value = `maglabel`

`labelrsep` Radial per unit location of label (in direction of the phasor):
`labelrsep = 0` represents the shaft of the phasor and `labelrsep = 1`
represents the arrow hear of the phasor; default value = 0.5, i.e., the radial
center of the phasor

`labeltsep` Tangential per unit location of label: `labeltsep = 0` means that
the label is plotted onto the phasor; `labeltsep = 0.1` plots the label on top
of the phasor applying a displacement of 10% with respect to `ref`; `labeltsep =
-0.2` Plots the label below the phasor applying a displacement of 20% with
respect to `ref`; default value = 0.1

`labelrelrot` Relative rotation of label; if `labelrelrot == false` (default value)
then the label is not rotated relative to the orientation of the phasor;
otherwise the label is rotated relative to the phasor by the angle
`labelrelangle`

`labelrelangle` Relative angle of label with respect to phasor
orientation; this angle is only applied, it `labelrelrot == true`; this angle the
indicates the relative orientation of the label with respect to the
orientation of the phasor; default value = 0

`color` Color of the phasor; i.e., shaft and arrow head color; default
value = "black"

`backgroundcolor` Background color of all labels; if labelrsep is equal to 0, the
background color "white" can be used; default value = "none"

`linewidth` Line width of the phasor; default value = 1

`linestyle` Line style of the phasor; default value = "-"

`colorDash` Color of the dashed circle (left subplot) and the horizontal dashed
lines between the left and right subplot; default value = colorBlack4

`left` Left side of the figure; default value = 0.2

`right` Right side of the figure; default value = 0.85

`bottom` Bottom side of the figure; default value = 0.2

`top` Top side of the figure; default value = 0.85

`showsine` If `true`, the sinewave is shown; default value = `true`

`showdashline` If `true`, the dashed lines are shown; default value = `true`

# Example

Copy and paste code:

```julia
using Unitful, Unitful.DefaultSymbols, PyPlot, EE
rc("text", usetex=true); rc("font", family="serif")
phasorsine(1, 45°, ylabel=L"$u,i$", maglabel=L"$\hat{U}$", labelrsep=0.3,
    color="gray", linestyle="--")
phasorsine(0.55, 0, add=true, maglabel=L"$\hat{I}$")
# save3fig("phasorsine",crop=true);
```
"""
function phasorsine(mag = 1,
    phi = 0;
    add = false,
    figsize = (6.6,2.5),
    xlabel = L"$\omega t$\,($^\circ $)",
    ylabel = "",
    maglabel = "",
    phasorlabel = maglabel,
    color = "black",
    backgroundcolor = "none",
    linewidth = 1,
    linestyle = "-",
    labeltsep = 0.1,
    labelrsep = 0.5,
    labelrelrot = true,
    labelrelangle = 0,
    colorDash="gray",
    left=0.20,
    right=0.80,
    bottom=0.20,
    top=0.80,
    showsine = true,
    showdashline = true)
    # https://matplotlib.org/tutorials/text/annotations.html#plotting-guide-annotation
    # https://matplotlib.org/users/annotations.html
    # https://stackoverflow.com/questions/17543359/drawing-lines-between-two-plots-in-matplotlib

    # Create figure
    if !add
        # Create new figure
        fig = figure(figsize=figsize)
        subplots_adjust(left=left, right=right, bottom=bottom, top=top)
    end
    # Create left subplot
    subplot(121)
    # Angle vector to draw circle
    psi = collect(0:pi/500:2*pi)
    # Coordinates of circle
    x = mag*cos.(psi)
    y = mag*sin.(psi)
    # Plot circle
    plot(x, y, color=colorDash, linewidth=1, linestyle=":",
        dash_capstyle="round")
    # Plot phasor
    phasor(pol(mag,phi), ref=1,
        label=phasorlabel, labelrsep=labelrsep, labeltsep=labeltsep,
        labelrelrot=labelrelrot, labelrelangle=labelrelangle,
        color=color, backgroundcolor=backgroundcolor,
        linestyle=linestyle, linewidth=linewidth)
    axis("square")
    ax1 = gca()
    if !add
        xlim(-1.1,1.1)
        ylim(-1.1,1.1)
        ax1[:spines]["left"][:set_visible](false)
        ax1[:spines]["right"][:set_visible](false)
        ax1[:spines]["bottom"][:set_visible](false)
        ax1[:spines]["top"][:set_visible](false)
        # Remove ticks
        xticks([])
        yticks([])
    end

    # Create right subplot
    subplot(122)
    # Plot sine if selected by showsine = true
    if showsine
        yphi = mag*sin.(psi+phi)
        plot(psi*180/pi, yphi,
            color=color, linewidth=linewidth, linestyle=linestyle)
    end
    ax2 = gca()
    # First phasor and sine wave diagram must be drawn with add = false
    if !add
        # Scale and tick x-axis
        xlim(0, 360)
        ylim(-1.1, 1.1)
        xticks(collect(90:90:360),
            backgroundcolor=backgroundcolor)
        if maglabel != ""
            yticks([-mag, 0, mag],[L"$-$"*maglabel, L"$0$", maglabel],
                backgroundcolor=backgroundcolor)
        else
            yticks([-mag, 0, mag],["","",""])
        end
        # Create arrows and labels of axes
        arrowaxes(xlabel=xlabel, ylabel=ylabel)
    else
        # If additional phasor and sine wave diagram are added, further
        # y-axis ticks have to beee added; for this purpose, the existing (old)
        # ticks are stored
        yticks_old = ax2[:get_yticks]()
        # Store existing (old) labels
        ytickslabel_old = ax2[:get_yticklabels]()
        # Extend old ticks and labels by addition ticks and labels
        if maglabel != ""
            yticks(cat(1, yticks_old, [-mag,mag]),
                cat(1, ytickslabel_old, [L"$-$"*maglabel,maglabel]),
                    backgroundcolor=backgroundcolor)
        end
    end

    # Plot dashed lines, if showdashline = true
    if showdashline
        # Dotted line from phasor arrow to begin of sine wave, split in two
        # parts, to avoid overlay effects if multiple dashed lines are drawn
        con = matplotlib[:patches][:ConnectionPatch](
            xyB=(360, mag*sin(phi)), xyA=(0, mag*sin(phi)),
            coordsA="data", coordsB="data",
            axesA=ax2, axesB=ax2, color=colorDash,
            linewidth=lineWidth4, linestyle=":", clip_on=false)
        ax2[:add_artist](con)
        con = matplotlib[:patches][:ConnectionPatch](
            xyA=(0, mag*sin(phi)), xyB=(mag*cos(phi), mag*sin(phi)),
            coordsA="data", coordsB="data",
            axesA=ax2, axesB=ax1, color=colorDash,
            linewidth=lineWidth4, linestyle=":", clip_on=false)
        ax2[:add_artist](con)
        # Dotted line of y-axis of right diagram to maximum of sine wave
        con = matplotlib[:patches][:ConnectionPatch](
            xyB=(mod(90-phi*180/pi,360), mag), xyA=(0, mag),
            coordsA="data", coordsB="data",
            axesA=ax2, axesB=ax2, color=colorDash,
            linewidth=lineWidth4, linestyle=":", clip_on=false)
        ax2[:add_artist](con)
        # Dotted line of y-axis of right diagram to minimum of sine wave
        con = matplotlib[:patches][:ConnectionPatch](
            xyB=(mod(270-phi*180/pi, 360),-mag), xyA=(0, -mag),
            coordsA="data", coordsB="data",
            axesA=ax2, axesB=ax2, color=colorDash,
            linewidth=lineWidth4, linestyle=":", clip_on=false)
        ax2[:add_artist](con)
    end
end

doc"""
# Function call

```
angulardimension(r = 1, phi1 = 0, phi2 = pi/2; origin = 0.0im,
    label= "", labelphisep = 0.5, labelrsep = 0.1,
    labelrelrot = false, labelrelangle = 0, ha = "center", va = "center",
    color="black", backgroundcolor="none",
    arrowstyle1 = ".", arrowstyle2 = "-|>", dot90 = false,
    linewidth = 0.6, linestyle = "-", width = 0.2,
    headlength = 5, headwidth = 2.5)
```

# Description

This function draws an arrowed arc, intended to label the angle between phasors.
The arc is drawn from angle `phi1` (begin) to `phi2` (end). The begin and end
arrow shapes can be set. The arc can be labeled and optionally a dot maker can
be used to indicate right angles (90°).

# Variables

`r` Radius if the arc with not unit; shall be between 0 and 1; default value = 1

`phi1` Phase angle of the begin of the arc; default value = 0

`phi2` Phase angle of the end of the arc; default value = pi/2

`origin` Complex quantity, indicating the origin of the arc with no unit;
default value = 0.0 + 0.0im

`label` Label of the angle; default value =""

`labelphisep` Angular separation of the label with respect to the arc; if
`labelphisep == 0`, the label is located at angle `phi1` and if `labelphisep ==
1`, the label is located at angle `phi2`; default value = 0.5, right in the
middle between `phi1` and `phi2`

labelrsep` Radial per unit location of label (in direction of the phasor):
`labelrsep = 0` locates the label right on the arc. A positive value locates the
label outside the arc, a negative value locates the label inside the arc;
default value = 0.1

`labelrelrot` Relative rotation of label; if `labelrelrot == false` (default
value) then the label is not rotated relative to the center of the arc;
otherwise the label is rotated relative to the  angle `labelrelangle`

`labelrelangle` Relative angle of label with respect to center of the arc; this
angle is only applied, it `labelrelrot == true`; this angle indicates the
relative orientation of the label with respect to the center of the arc;
default value = 0

`ha` Horizontal alignment of label; actually represents the radial alignment of
the label; default value = "center"

`va` Vertical alignment of label; actually represents the tangential alignment
of the label; default value = "center"

`color` Color of the arc; default value = "black"

`backgroundcolor` Background color of the label; if labelrsep is equal to 0, the
background color "white" can be used; default value = "none"

`arrowstyle1` Arrow style of the begin of the arc; default value = "."; valid
strings are:

- `.` dot marker
- `<|-` arrow

`arrowstyle2` Arrow style of the end of the arc; default value = "-|>"; valid
strings are:

- `.` dot marker
- `-|>` arrow

`headlength` Length of arrow head; default value = 5

`headwidth` Width of arrow head; default value = 2.5

# Example

Copy and paste code:

```julia
using Unitful, Unitful.DefaultSymbols, PyPlot, EE
figure(figsize=(3.3, 2.5))
rc("text", usetex=true); rc("font", family="serif")
V1 = 100V + j*0V # Voltage
Z1 = 30Ω + j*40Ω # Impedance
I1 = V1/Z1 # Current
Vr = real(Z1)*I1
Vx = V1 - Vr
refV = abs(V1); refI=abs(I1)*0.8
phasor(V1, label=L"$\underline{V}_1$", labeltsep=0.1, ref=refV,
    labelrelrot=true)
phasor(Vr, label=L"$\underline{V}_r$", labeltsep=-0.25, ref=refV,
    labelrelrot=true)
phasor(Vx, origin=Vr, label=L"$\underline{V}_x$", labeltsep=-0.2, ref=refV,
    labelrelrot=true)
phasor(I1, label=L"$\underline{I}_1$", labeltsep=-0.2, labelrsep=0.7, ref=refI,
    labelrelrot=true, linestyle="--", par=-0.05)
phi1=angle(I1)
phi2=angle(V1)
angulardimension(0.3,phi1,phi2,arrowstyle1=".",arrowstyle2="-|>",ha="left",
    label=L"$\varphi_1$", labelrsep=0.05)
axis("square"); xlim(-1,1); ylim(-1,1)
removeaxes(); # Remove axis
# save3fig("phasordiagram",crop=true);
```
"""
function angulardimension(r = 1,
    phi1 = 0,
    phi2 = pi/2;
    origin = 0.0im,
    label = "",
    labelphisep = 0.5,
    labelrsep = 0.1,
    labelrelrot = false,
    labelrelangle = 0,
    ha = "center",
    va = "center",
    color="black",
    backgroundcolor="none",
    arrowstyle1 = ".",
    arrowstyle2 = "-|>",
    dot90 = false,
    linewidth = 0.6,
    linestyle = "-",
    width = 0.2,
    headlength = 5,
    headwidth = 2.5)

    # Determine sign of the difference of angles in order to revert oriention
    # angle, if required
    sig = sign(phi2-phi1)
    # Number of segments based on every 2 degrees
    segs = round((phi2-phi1)*180/pi/    2)*sig
    # Create vector of angles to draw arc
    phi = collect(linspace(phi1,phi2,segs))
    # Arc coordinates
    x = upstrip(r)*cos.(phi) + real(upstrip(origin))
    y = upstrip(r)*sin.(phi) + imag(upstrip(origin))
    # Draw arc
    plot(x,y,color=color,linewidth=linewidth,linestyle=linestyle)

    # Draw arrows at begin and end of arc, depending on the specified arrow
    # styles

    # Begin of arc
    if arrowstyle1 == "<|-"
        # Arrow head
        annotate("", xy=(x[1], y[1]),
            xytext=(x[1]-sig*0.01*r*cos(phi1-pi/2*0.98),
                y[1]-sig*0.01*r*sin(phi1-pi/2*0.98)),
            xycoords="data",
            arrowprops=Dict("edgecolor"=>color, "facecolor"=>color,
                "width"=>width, "linestyle"=>"-",
                "headlength"=>headlength,
                "headwidth"=>headwidth),
            annotation_clip=false)
    elseif arrowstyle1 == "."
        # Dot marker
        plot(x[1],y[1],marker=".",color=color, clip_on=false)
    end

    # End of arc
    if arrowstyle2 == "-|>"
        # Arrow head
        annotate("", xy=(x[end], y[end]),
            xytext=(x[end]-sig*0.01*r*cos(phi2+pi/2*0.98),
                y[end]-sig*0.01*r*sin(phi2+pi/2*0.98)),
            xycoords="data",
            arrowprops=Dict("edgecolor"=>color, "facecolor"=>color,
                "width"=>width, "linestyle"=>"-",
                "headlength"=>headlength,
                "headwidth"=>headwidth),
            annotation_clip=false)
    elseif arrowstyle2 == "."
        # Marker dot
        plot(x[end],y[end],marker="." ,color=color, clip_on=false)
    end

    # Plot label
    # Angle in the middle of the arc
    phim = (phi1+phi2)/2.0
    # Angle difference
    dphi = phi2-phi1
    # Radial position of text
    rlabel = r + labelrsep
    # Angular position of text
    philabel = phi1 + dphi*labelphisep
    # Rectangular position of text
    if labelrelrot == false
        # Without relative rotation of label
        text(rlabel*cos(philabel) + real(origin),
            rlabel*sin(philabel) + imag(origin),
            label, ha=ha, va=va, rotation=labelrelangle*180/pi,
            backgroundcolor=backgroundcolor)
    else
        # Applying relative rotation of label
        text(rlabel*cos(philabel) + real(origin),
            rlabel*sin(philabel) + imag(origin),
            label, ha=ha, va=va, rotation=(phim+labelrelangle)*180/pi,
            backgroundcolor=backgroundcolor)
    end

    # Optionally create a dot in the center of the arc to indicate 90°
    if dot90
        plot(r/2*cos(phim) + real(origin),
            r/2*sin(phim) + imag(origin),
            marker=".", color=color, clip_on=false)
    end
end


doc"""
# Function call

```
phasordimension(c; origin = 0im, ref = 1;
    label = "", labeltsep = 0.1, labelrsep=0.5, labelrelrot=false,
    labelrelangle=0, ha = "center", va = "center",
    color="black", backgroundcolor = "none",
    arrowstyle1 = "<|-", arrowstyle2 = "-|>", linewidth=0.6, linestyle = "-",
    width=0.2, headlength=5, headwidth=2.5,
    par=0, paroverhang = 0.02, parcolor = "black",
    parlinewidth=0.6, parlinestyle = "-")

```

# Description

This function draws length dimension with label based on rectangular x- and
y-coordinates. The length dimension arrow can be shifted parallel to the
specified  coordinates by means the single parameter `par`. Additionally,
auxiliary lines  from the specified coordinates to the length dimension are
drawn.

# Variables

`c` Complex phasor to be dimensioned

`origin` Complex number representing the origin of the phasor dimension; this
variable needs to have the same unit as `c`

`ref` Reference length of scaling; this is required as in a phasor diagram
voltages and currents may be included; in order to account for the different
voltage and current scales, one (constant)  `ref` is used for voltage
phasors and another (constant) `ref` is used for current phasors; this
variable needs to have the same unit as `c`

`label` Label of the angle; default value =""

`labelphisep` Angular separation of the label with respect to the arc; if
`labelphisep == 0`, the label is located at angle `phi1` and if `labelphisep ==
1`, the label is located at angle `phi2`; default value = 0.5, right in the
middle between `phi1` and `phi2`

labelrsep` Radial per unit location of label (in direction of the phasor):
`labelrsep = 0` locates the label right on the arc. A positive value locates the
label outside the arc, a negative value locates the label inside the arc;
default value = 0.1

`labelrelrot` Relative rotation of label; if `labelrelrot == false` (default
value) then the label is not rotated relative to the center of the arc;
otherwise the label is rotated relative to the  angle `labelrelangle`

`labelrelangle` Relative angle of label with respect to center of the arc; this
angle is only applied, it `labelrelrot == true`; this angle indicates the
relative orientation of the label with respect to the center of the arc;
default value = 0

`ha` Horizontal alignment of label; actually represents the radial alignment of
the label; default value = "center"

`va` Vertical alignment of label; actually represents the tangential alignment
of the label; default value = "center"

`color` Color of the arc; default value = "black"

`backgroundcolor` Background color of the label; if labelrsep is equal to 0, the
background color "white" can be used; default value = "none"

`arrowstyle1` Arrow style of the begin of the arc; default value = "."; valid
strings are:

- `.` dot marker
- `<|-` arrow

`arrowstyle2` Arrow style of the end of the arc; default value = "-|>"; valid
strings are:

- `.` dot marker
- `-|>` arrow

`headlength` Length of arrow head; default value = 5

`headwidth` Width of arrow head; default value = 2.5

`par` In order to be able to draw the length dimension parallel to the specified
coordiantes `x1`, `y1`, `x2`, `y2`, `par` is used to specify the per unit
tangential shift (offset) of the length dimension; default value = 0 (no shift)

`paroverhang` The auxiliary lines, drawn in case of `par != 0`, show the absolute
overhang `paroverhang`; default value = 0.02

`parcolor` Color of the auxiliary lines; default value = "black"

`parlinewidth` Line width of the auxiliary line; default value = 0.6

`parlinestyle` Line style of the auxiliary line; default value = "-"

# Examples

Copy and paste the following code:

```julia
using Unitful, Unitful.DefaultSymbols, PyPlot, EE
figure(figsize=(3.3, 2.5))
rc("text", usetex=true); rc("font", family="serif")
Z1 = pol(1,30°)
phasor(Z1, label=L"$\underline{Z}$", labeltsep = 0.05, labelrelrot=true)
phasordimension(real(Z1), label=L"$R$", arrowstyle1="",
    linestyle="-", linewidth=1, headwidth=5, headlength=10,
    labeltsep=0, color="gray", backgroundcolor="white")
    phasordimension(j*imag(Z1), origin=real(Z1), label=L"j$\cdot X$",
    arrowstyle1="", linestyle="-", linewidth=1, headwidth=5, headlength=10,
    labeltsep=0, color="gray", backgroundcolor="white")
arrowaxes(xmin = real(Z1)+0.1, xlabel="Re", ylabel=L"j$\cdot$Im")
xlim([-0.5,1]);ylim([-0.5,1]); axis("square"); removeaxes();
# save3fig("phasordimension", crop=true)
```
"""
function phasordimension(c;
    origin = (0.0+0.0im).*c./ustrip(c),
    ref = abs(c./ustrip(c)),
    label = "",
    labeltsep = 0.1,
    labelrsep = 0.5,
    labelrelrot = false,
    labelrelangle = 0,
    ha = "center",
    va = "center",
    color="black",
    backgroundcolor = "none",
    arrowstyle1 = "<|-",
    arrowstyle2 = "-|>",
    linewidth = 0.6,
    linestyle = "-",
    width = 0.2,
    headlength = 5,
    headwidth = 2.5,
    par = 0,
    paroverhang = 0.02,
    parcolor = "black",
    parlinewidth = 0.6,
    parlinestyle = "-")

    lengthdimension(real(origin/ref), imag(origin/ref),
        real((c+origin)/ref), imag((c+origin)/ref),
        label=label, labeltsep = labeltsep, labelrsep=labelrsep,
        labelrelrot=labelrelrot, labelrelangle = labelrelangle, ha=ha, va=va,
        color=color, backgroundcolor = backgroundcolor,
        arrowstyle1=arrowstyle1, arrowstyle2=arrowstyle2,
        linewidth = linewidth, linestyle=linestyle, width=width,
        headlength=headlength, headwidth=headwidth,
        par=par, paroverhang=paroverhang, parcolor = parcolor,
        parlinewidth=parlinewidth, parlinestyle=parlinestyle)
end
