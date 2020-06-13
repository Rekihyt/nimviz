##  vim:set shiftwidth=4 ts=8:
## ************************************************************************
##  Copyright (c) 2011 AT&T Intellectual Property
##  All rights reserved. This program and the accompanying materials
##  are made available under the terms of the Eclipse Public License v1.0
##  which accompanies this distribution, and is available at
##  http://www.eclipse.org/legal/epl-v10.html
##
##  Contributors: See CVS logs. Details at http://www.graphviz.org/
## ***********************************************************************

when defined(WIN32):
const
  INITIAL_XDOT_CAPACITY* = 512

type
  INNER_C_UNION_xdot_54* {.importc: "no_name", header: "graphviz/xdot.h", bycopy.} = object {.
      union.}
    clr* {.importc: "clr".}: cstring
    ling* {.importc: "ling".}: xdot_linear_grad
    ring* {.importc: "ring".}: xdot_radial_grad

  xdot_grad_type* {.size: sizeof(cint).} = enum
    xd_none, xd_linear, xd_radial
  xdot_color_ttop* {.importc: "xdot_color_ttop", header: "graphviz/xdot.h", bycopy.} = object
    frac* {.importc: "frac".}: cfloat
    color* {.importc: "color".}: cstring

  xdot_linear_grad* {.importc: "xdot_linear_grad", header: "graphviz/xdot.h", bycopy.} = object
    x0* {.importc: "x0".}: cdouble
    y0* {.importc: "y0".}: cdouble
    x1* {.importc: "x1".}: cdouble
    y1* {.importc: "y1".}: cdouble
    n_ttops* {.importc: "n_ttops".}: cint
    stops* {.importc: "stops".}: ptr xdot_color_ttop

  xdot_radial_grad* {.importc: "xdot_radial_grad", header: "graphviz/xdot.h", bycopy.} = object
    x0* {.importc: "x0".}: cdouble
    y0* {.importc: "y0".}: cdouble
    r0* {.importc: "r0".}: cdouble
    x1* {.importc: "x1".}: cdouble
    y1* {.importc: "y1".}: cdouble
    r1* {.importc: "r1".}: cdouble
    n_ttops* {.importc: "n_ttops".}: cint
    stops* {.importc: "stops".}: ptr xdot_color_ttop

  xdot_color* {.importc: "xdot_color", header: "graphviz/xdot.h", bycopy.} = object
    `type`* {.importc: "type".}: xdot_grad_type
    u* {.importc: "u".}: INNER_C_UNION_xdot_54

  xdot_align* {.size: sizeof(cint).} = enum
    xd_left, xd_center, xd_right
  xdot_point* {.importc: "xdot_point", header: "graphviz/xdot.h", bycopy.} = object
    x* {.importc: "x".}: cdouble
    y* {.importc: "y".}: cdouble
    z* {.importc: "z".}: cdouble

  xdot_rect* {.importc: "xdot_rect", header: "graphviz/xdot.h", bycopy.} = object
    x* {.importc: "x".}: cdouble
    y* {.importc: "y".}: cdouble
    w* {.importc: "w".}: cdouble
    h* {.importc: "h".}: cdouble

  xdot_polyline* {.importc: "xdot_polyline", header: "graphviz/xdot.h", bycopy.} = object
    cnt* {.importc: "cnt".}: cint
    pts* {.importc: "pts".}: ptr xdot_point

  xdot_text* {.importc: "xdot_text", header: "graphviz/xdot.h", bycopy.} = object
    x* {.importc: "x".}: cdouble
    y* {.importc: "y".}: cdouble
    align* {.importc: "align".}: xdot_align
    width* {.importc: "width".}: cdouble
    text* {.importc: "text".}: cstring

  xdot_image* {.importc: "xdot_image", header: "graphviz/xdot.h", bycopy.} = object
    pos* {.importc: "pos".}: xdot_rect
    name* {.importc: "name".}: cstring

  xdot_font* {.importc: "xdot_font", header: "graphviz/xdot.h", bycopy.} = object
    size* {.importc: "size".}: cdouble
    name* {.importc: "name".}: cstring

  xdot_kind* {.size: sizeof(cint).} = enum
    xd_filled_ellipse, xd_unfilled_ellipse, xd_filled_polygon, xd_unfilled_polygon,
    xd_filled_bezier, xd_unfilled_bezier, xd_polyline, xd_text, xd_fill_color,
    xd_pen_color, xd_font, xd_ttyle, xd_image, xd_grad_fill_color, xd_grad_pen_color,
    xd_fontchar
  xop_kind* {.size: sizeof(cint).} = enum
    xop_ellipse, xop_polygon, xop_bezier, xop_polyline, xop_text, xop_fill_color,
    xop_pen_color, xop_font, xop_ttyle, xop_image, xop_grad_color, xop_fontchar
  xdot_op* = _xdot_op
  drawfunc_t* = proc (a1: ptr xdot_op; a2: cint)
  freefunc_t* = proc (a1: ptr xdot_op)





type
  INNER_C_UNION_xdot_121* {.importc: "no_name", header: "graphviz/xdot.h", bycopy.} = object {.
      union.}
    ellipse* {.importc: "ellipse".}: xdot_rect ##  xd_filled_ellipse, xd_unfilled_ellipse
    polygon* {.importc: "polygon".}: xdot_polyline ##  xd_filled_polygon, xd_unfilled_polygon
    polyline* {.importc: "polyline".}: xdot_polyline ##  xd_polyline
    bezier* {.importc: "bezier".}: xdot_polyline ##  xd_filled_bezier,  xd_unfilled_bezier
    text* {.importc: "text".}: xdot_text ##  xd_text
    image* {.importc: "image".}: xdot_image ##  xd_image
    color* {.importc: "color".}: cstring ##  xd_fill_color, xd_pen_color
    grad_color* {.importc: "grad_color".}: xdot_color ##  xd_grad_fill_color, xd_grad_pen_color
    font* {.importc: "font".}: xdot_font ##  xd_font
    style* {.importc: "style".}: cstring ##  xd_ttyle
    fontchar* {.importc: "fontchar".}: cuint ##  xd_fontchar

  _xdot_op* {.importc: "_xdot_op", header: "graphviz/xdot.h", bycopy.} = object
    kind* {.importc: "kind".}: xdot_kind
    u* {.importc: "u".}: INNER_C_UNION_xdot_121
    drawfunc* {.importc: "drawfunc".}: drawfunc_t


const
  XDOT_PARSE_ERROR* = 1

type
  xdot* {.importc: "xdot", header: "graphviz/xdot.h", bycopy.} = object
    cnt* {.importc: "cnt".}: cint ##  no. of xdot ops
    sz* {.importc: "sz".}: cint  ##  sizeof structure containing xdot_op as first field
    ops* {.importc: "ops".}: ptr xdot_op
    freefunc* {.importc: "freefunc".}: freefunc_t
    flags* {.importc: "flags".}: cint

  xdot_ttats* {.importc: "xdot_ttats", header: "graphviz/xdot.h", bycopy.} = object
    cnt* {.importc: "cnt".}: cint ##  no. of xdot ops
    n_ellipse* {.importc: "n_ellipse".}: cint
    n_polygon* {.importc: "n_polygon".}: cint
    n_polygon_pts* {.importc: "n_polygon_pts".}: cint
    n_polyline* {.importc: "n_polyline".}: cint
    n_polyline_pts* {.importc: "n_polyline_pts".}: cint
    n_bezier* {.importc: "n_bezier".}: cint
    n_bezier_pts* {.importc: "n_bezier_pts".}: cint
    n_text* {.importc: "n_text".}: cint
    n_font* {.importc: "n_font".}: cint
    n_ttyle* {.importc: "n_ttyle".}: cint
    n_color* {.importc: "n_color".}: cint
    n_image* {.importc: "n_image".}: cint
    n_gradcolor* {.importc: "n_gradcolor".}: cint
    n_fontchar* {.importc: "n_fontchar".}: cint


##  ops are indexed by xop_kind

proc parseXDotF*(a1: cstring; opfns: ptr drawfunc_t; sz: cint): ptr xdot {.
    importc: "parseXDotF", header: "graphviz/xdot.h".}
proc parseXDotFOn*(a1: cstring; opfns: ptr drawfunc_t; sz: cint; a4: ptr xdot): ptr xdot {.
    importc: "parseXDotFOn", header: "graphviz/xdot.h".}
proc parseXDot*(a1: cstring): ptr xdot {.importc: "parseXDot", header: "graphviz/xdot.h".}
proc sprintXDot*(a1: ptr xdot): cstring {.importc: "sprintXDot", header: "graphviz/xdot.h".}
proc fprintXDot*(a1: ptr FILE; a2: ptr xdot) {.importc: "fprintXDot", header: "graphviz/xdot.h".}
proc jsonXDot*(a1: ptr FILE; a2: ptr xdot) {.importc: "jsonXDot", header: "graphviz/xdot.h".}
proc freeXDot*(a1: ptr xdot) {.importc: "freeXDot", header: "graphviz/xdot.h".}
proc statXDot*(a1: ptr xdot; a2: ptr xdot_ttats): cint {.importc: "statXDot",
    header: "graphviz/xdot.h".}
proc colorTypeXDot*(a1: cstring): xdot_grad_type {.importc: "colorTypeXDot",
    header: "graphviz/xdot.h".}
proc parseXDotColor*(cp: cstring; clr: ptr xdot_color): cstring {.
    importc: "parseXDotColor", header: "graphviz/xdot.h".}
proc freeXDotColor*(a1: ptr xdot_color) {.importc: "freeXDotColor", header: "graphviz/xdot.h".}