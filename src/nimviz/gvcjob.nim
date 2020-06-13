##  $Id$ $Revision$
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
##  Common header used by both clients and plugins

import gvcommon
import color, gvplugin_device
  
import geom

template ARRAY_SIZE*(A: untyped): untyped =
  (sizeof((A) div sizeof((A[0]))))

type
  pen_type* {.size: sizeof(cint).} = enum
    PEN_NONE, PEN_DASHED, PEN_DOTTED, PEN_SOLID
  fill_type* {.size: sizeof(cint).} = enum
    FILL_NONE, FILL_SOLID, FILL_LINEAR, FILL_RADIAL
  font_type* {.size: sizeof(cint).} = enum
    FONT_REGULAR, FONT_BOLD, FONT_ITALIC
  label_type* {.size: sizeof(cint).} = enum
    LABEL_PLAIN, LABEL_HTML





const
  PENWIDTH_NORMAL* = 1.0
  PENWIDTH_BOLD* = 2.0

type
  gvattr_t* {.size: sizeof(cint).} = enum
    GVATTR_STRING, GVATTR_BOOL, GVATTR_COLOR


##  The -T output formats listed below are examples only, they are not definitive or inclusive,
##  other outputs may use the flags now, or in the future
##
##                    Default emit order is breadth first graph walk order
##  EMIT_SORTED			emits nodes before edges		
##  EMIT_COLORS			emits colors before nodes or edge -Tfig
##  EMIT_CLUSTERS_LAST		emits cluster after nodes and edges 	
##  EMIT_PREORDER			emit in preorder traversal ???		
##  EMIT_EDGE_SORTED		emits edges before nodes		
##
##  GVDEVICE_DOES_PAGES		provides pagination support -Tps	
##  GVDEVICE_DOES_LAYERS		provides support for layers -Tps	
##  GVDEVICE_EVENTS		supports mouse events -Tgtk, -Txlib	
##  GVDEVICE_DOES_TRUECOLOR	supports alpha channel -Tpng, -Tgtk, -Txlib
##  GVDEVICE_BINARY_FORMAT		Suppresses \r\n substitution for linends
##  GVDEVICE_COMPRESSED_FORMAT	controls libz compression		
##  GVDEVICE_NO_WRITER		used when gvdevice is not used because device uses its own writer, -Tming, devil outputs   (FIXME seems to overlap OUTPUT_NOT_REQUIRED)
##
##  GVRENDER_Y_GOES_DOWN		device origin top left, y goes down, otherwise
##   				device origin lower left, y goes up	
##  GVRENDER_DOES_TRANSFORM	device uses scale, translate, rotate to do its own
##  				coordinate transformations, otherwise coordinates
##   				are pre-transformed			
##  GVRENDER_DOES_ARROWS		renderer has its own idea of arrow shapes (deprecated)
##  GVRENDER_DOES_LABELS		basically, maps don't need labels	
##  GVRENDER_DOES_MAPS		renderer encodes mapping information for mouse events -Tcmapx -Tsvg
##  GVRENDER_DOES_MAP_RECTANGLE	supports a 2 coord rectngle optimization
##  GVRENDER_DOES_MAP_CIRCLE	supports a 1 coord + radius circle optimization	
##  GVRENDER_DOES_MAP_POLYGON	supports polygons (basically, -Tsvg uses anchors, so doesn't need to support any map shapes)
##  GVRENDER_DOES_MAP_ELLIPSE	supports a 2 coord ellipse optimization	
##  GVRENDER_DOES_MAP_BSPLINE	supports mapping of splines		
##  GVRENDER_DOES_TOOLTIPS		can represent tooltip info -Tcmapx, -Tsvg		
##  GVRENDER_DOES_TARGETS		can represent target info (open link in a new tab or window)
##  GVRENDER_DOES_Z		render support 2.5D representation -Tvrml
##  GVRENDER_NO_WHITE_BG		don't paint white background, assumes white paper -Tps
##  LAYOUT_NOT_REQUIRED 		don't perform layout -Tcanon 		
##  OUTPUT_NOT_REQUIRED		don't use gvdevice for output (basically when agwrite() used instead) -Tcanon, -Txdot
##

const
  EMIT_SORTED* = (1 shl 0)
  EMIT_COLORS* = (1 shl 1)
  EMIT_CLUSTERS_LAST* = (1 shl 2)
  EMIT_PREORDER* = (1 shl 3)
  EMIT_EDGE_SORTED* = (1 shl 4)
  GVDEVICE_DOES_PAGES* = (1 shl 5)
  GVDEVICE_DOES_LAYERS* = (1 shl 6)
  GVDEVICE_EVENTS* = (1 shl 7)
  GVDEVICE_DOES_TRUECOLOR* = (1 shl 8)
  GVDEVICE_BINARY_FORMAT* = (1 shl 9)
  GVDEVICE_COMPRESSED_FORMAT* = (1 shl 10)
  GVDEVICE_NO_WRITER* = (1 shl 11)
  GVRENDER_Y_GOES_DOWN* = (1 shl 12)
  GVRENDER_DOES_TRANSFORM* = (1 shl 13)
  GVRENDER_DOES_ARROWS* = (1 shl 14)
  GVRENDER_DOES_LABELS* = (1 shl 15)
  GVRENDER_DOES_MAPS* = (1 shl 16)
  GVRENDER_DOES_MAP_RECTANGLE* = (1 shl 17)
  GVRENDER_DOES_MAP_CIRCLE* = (1 shl 18)
  GVRENDER_DOES_MAP_POLYGON* = (1 shl 19)
  GVRENDER_DOES_MAP_ELLIPSE* = (1 shl 20)
  GVRENDER_DOES_MAP_BSPLINE* = (1 shl 21)
  GVRENDER_DOES_TOOLTIPS* = (1 shl 22)
  GVRENDER_DOES_TARGETS* = (1 shl 23)
  GVRENDER_DOES_Z* = (1 shl 24)
  GVRENDER_NO_WHITE_BG* = (1 shl 25)
  LAYOUT_NOT_REQUIRED* = (1 shl 26)
  OUTPUT_NOT_REQUIRED* = (1 shl 27)

type
  gvrender_features_t* {.importc: "gvrender_features_t", header: "graphviz/gvcjob.h", bycopy.} = object
    flags* {.importc: "flags".}: cint
    default_pad* {.importc: "default_pad".}: cdouble ##  graph units
    knowncolors* {.importc: "knowncolors".}: cstringArray
    sz_knowncolors* {.importc: "sz_knowncolors".}: cint
    color_type* {.importc: "color_type".}: color_type_t

  gvdevice_features_t* {.importc: "gvdevice_features_t", header: "graphviz/gvcjob.h", bycopy.} = object
    flags* {.importc: "flags".}: cint
    default_margin* {.importc: "default_margin".}: pointf ##  left/right, top/bottom - points
    default_pagesize* {.importc: "default_pagesize".}: pointf ##  default page width, height - points
    default_dpi* {.importc: "default_dpi".}: pointf


const
  LAYOUT_USES_RANKDIR* = (1 shl 0)

type
  gvplugin_active_device_t* {.importc: "gvplugin_active_device_t",
                             header: "graphviz/gvcjob.h", bycopy.} = object
    engine* {.importc: "engine".}: ptr gvdevice_engine_t
    id* {.importc: "id".}: cint
    features* {.importc: "features".}: ptr gvdevice_features_t
    `type`* {.importc: "type".}: cstring

  gvplugin_active_render_t* {.importc: "gvplugin_active_render_t",
                             header: "graphviz/gvcjob.h", bycopy.} = object
    engine* {.importc: "engine".}: ptr gvrender_engine_t
    id* {.importc: "id".}: cint
    features* {.importc: "features".}: ptr gvrender_features_t
    `type`* {.importc: "type".}: cstring

  gvplugin_active_loadimage_t* {.importc: "gvplugin_active_loadimage_t",
                                header: "graphviz/gvcjob.h", bycopy.} = object
    engine* {.importc: "engine".}: ptr gvloadimage_engine_t
    id* {.importc: "id".}: cint
    `type`* {.importc: "type".}: cstring

  gv_argvlist_t* {.importc: "gv_argvlist_t", header: "graphviz/gvcjob.h", bycopy.} = object
    argv* {.importc: "argv".}: cstringArray
    argc* {.importc: "argc".}: cint
    alloc* {.importc: "alloc".}: cint

  gvdevice_callbacks_t* {.importc: "gvdevice_callbacks_t", header: "graphviz/gvcjob.h", bycopy.} = object
    refresh* {.importc: "refresh".}: proc (job: ptr GVJ_t)
    button_press* {.importc: "button_press".}: proc (job: ptr GVJ_t; button: cint;
        pointer: pointf)
    button_release* {.importc: "button_release".}: proc (job: ptr GVJ_t; button: cint;
        pointer: pointf)
    motion* {.importc: "motion".}: proc (job: ptr GVJ_t; pointer: pointf)
    modify* {.importc: "modify".}: proc (job: ptr GVJ_t; name: cstring; value: cstring)
    del* {.importc: "del".}: proc (job: ptr GVJ_t) ##  can't use "delete" 'cos C++ stole it
    read* {.importc: "read".}: proc (job: ptr GVJ_t; filename: cstring; layout: cstring)
    layout* {.importc: "layout".}: proc (job: ptr GVJ_t; layout: cstring)
    render* {.importc: "render".}: proc (job: ptr GVJ_t; format: cstring;
                                     filename: cstring)

  gvevent_key_callback_t* = proc (job: ptr GVJ_t): cint
  gvevent_key_binding_t* {.importc: "gvevent_key_binding_t", header: "graphviz/gvcjob.h",
                          bycopy.} = object
    keystring* {.importc: "keystring".}: cstring
    callback* {.importc: "callback".}: gvevent_key_callback_t

  map_thape_t* {.size: sizeof(cint).} = enum
    MAP_RECTANGLE, MAP_CIRCLE, MAP_POLYGON
  obj_type* {.size: sizeof(cint).} = enum
    ROOTGRAPH_OBJTYPE, CLUSTER_OBJTYPE, NODE_OBJTYPE, EDGE_OBJTYPE



##  If this enum is changed, the implementation of xbuf and xbufs in
##  gvrender_core_dot.c will probably need to be changed.
##

type
  emit_ttate_t* {.size: sizeof(cint).} = enum
    EMIT_GDRAW, EMIT_CDRAW, EMIT_TDRAW, EMIT_HDRAW, EMIT_GLABEL, EMIT_CLABEL,
    EMIT_TLABEL, EMIT_HLABEL, EMIT_NDRAW, EMIT_EDRAW, EMIT_NLABEL, EMIT_ELABEL
  # obj_ttate_t* = obj_ttate_t


type
  INNER_C_UNION_gvcjob_195* {.importc: "no_name", header: "graphviz/gvcjob.h", bycopy.} = object {.
      union.}
    g* {.importc: "g".}: ptr graph_t
    sg* {.importc: "sg".}: ptr graph_t
    n* {.importc: "n".}: ptr node_t
    e* {.importc: "e".}: ptr edge_t

  obj_ttate_t* {.importc: "obj_ttate_t", header: "graphviz/gvcjob.h", bycopy.} = object
    parent* {.importc: "parent".}: ptr obj_ttate_t
    `type`* {.importc: "type".}: obj_type
    u* {.importc: "u".}: INNER_C_UNION_gvcjob_195
    emit_ttate* {.importc: "emit_ttate".}: emit_ttate_t
    pencolor* {.importc: "pencolor".}: gvcolor_t
    fillcolor* {.importc: "fillcolor".}: gvcolor_t
    stopcolor* {.importc: "stopcolor".}: gvcolor_t
    gradient_angle* {.importc: "gradient_angle".}: cint
    gradient_frac* {.importc: "gradient_frac".}: cfloat
    pen* {.importc: "pen".}: pen_type
    fill* {.importc: "fill".}: fill_type
    penwidth* {.importc: "penwidth".}: cdouble
    rawstyle* {.importc: "rawstyle".}: cstringArray
    z* {.importc: "z".}: cdouble
    tail_z* {.importc: "tail_z".}: cdouble
    head_z* {.importc: "head_z".}: cdouble ##  z depths for 2.5D renderers such as vrml
                                       ##  fully substituted text strings
    label* {.importc: "label".}: cstring
    xlabel* {.importc: "xlabel".}: cstring
    taillabel* {.importc: "taillabel".}: cstring
    headlabel* {.importc: "headlabel".}: cstring
    url* {.importc: "url".}: cstring ##  if GVRENDER_DOES_MAPS
    id* {.importc: "id".}: cstring
    labelurl* {.importc: "labelurl".}: cstring
    tailurl* {.importc: "tailurl".}: cstring
    headurl* {.importc: "headurl".}: cstring
    tooltip* {.importc: "tooltip".}: cstring ##  if GVRENDER_DOES_TOOLTIPS
    labeltooltip* {.importc: "labeltooltip".}: cstring
    tailtooltip* {.importc: "tailtooltip".}: cstring
    headtooltip* {.importc: "headtooltip".}: cstring
    target* {.importc: "target".}: cstring ##  if GVRENDER_DOES_TARGETS
    labeltarget* {.importc: "labeltarget".}: cstring
    tailtarget* {.importc: "tailtarget".}: cstring
    headtarget* {.importc: "headtarget".}: cstring
    explicit_tooltip* {.importc: "explicit_tooltip".} {.bitsize: 1.}: cint
    explicit_tailtooltip* {.importc: "explicit_tailtooltip".} {.bitsize: 1.}: cint
    explicit_headtooltip* {.importc: "explicit_headtooltip".} {.bitsize: 1.}: cint
    explicit_labeltooltip* {.importc: "explicit_labeltooltip".} {.bitsize: 1.}: cint
    explicit_tailtarget* {.importc: "explicit_tailtarget".} {.bitsize: 1.}: cint
    explicit_headtarget* {.importc: "explicit_headtarget".} {.bitsize: 1.}: cint
    explicit_edgetarget* {.importc: "explicit_edgetarget".} {.bitsize: 1.}: cint
    explicit_tailurl* {.importc: "explicit_tailurl".} {.bitsize: 1.}: cint
    explicit_headurl* {.importc: "explicit_headurl".} {.bitsize: 1.}: cint
    labeledgealigned* {.importc: "labeledgealigned".} {.bitsize: 1.}: cint ##  primary mapped region - node shape, edge labels
    url_map_thape* {.importc: "url_map_thape".}: map_thape_t
    url_map_n* {.importc: "url_map_n".}: cint ##  number of points for url map if GVRENDER_DOES_MAPS
    url_map_p* {.importc: "url_map_p".}: ptr pointf ##  additonal mapped regions for edges
    url_bsplinemap_poly_n* {.importc: "url_bsplinemap_poly_n".}: cint ##  number of polygons in url bspline map
                                                                  ## 					 if GVRENDER_DOES_MAPS && GVRENDER_DOES_MAP_BSPLINES
    url_bsplinemap_n* {.importc: "url_bsplinemap_n".}: ptr cint ##  array of url_bsplinemap_poly_n ints
                                                           ## 					 of number of points in each polygon
    url_bsplinemap_p* {.importc: "url_bsplinemap_p".}: ptr pointf ##  all the polygon points
    tailendurl_map_n* {.importc: "tailendurl_map_n".}: cint ##  tail end intersection with node
    tailendurl_map_p* {.importc: "tailendurl_map_p".}: ptr pointf
    headendurl_map_n* {.importc: "headendurl_map_n".}: cint ##  head end intersection with node
    headendurl_map_p* {.importc: "headendurl_map_p".}: ptr pointf


##  Note on units:
##      points  - a physical distance (1/72 inch) unaffected by zoom or dpi.
##      graph units - related to physical distance by zoom.  Equals points at zoom=1
##      device units - related to physical distance in points by dpi/72
##

type
  GVJ_t* {.importc: "GVJ_t", header: "graphviz/gvcjob.h", bycopy.} = object
    gvc* {.importc: "gvc".}: ptr GVC_t ##  parent gvc
    next* {.importc: "next".}: ptr GVJ_t ##  linked list of jobs
    next_active* {.importc: "next_active".}: ptr GVJ_t ##  linked list of active jobs (e.g. multiple windows)
    common* {.importc: "common".}: ptr GVCOMMON_t
    obj* {.importc: "obj".}: ptr obj_ttate_t ##  objects can be nested (at least clusters can)
                                        ## 					so keep object state on a stack
    input_filename* {.importc: "input_filename".}: cstring
    graph_index* {.importc: "graph_index".}: cint
    layout_type* {.importc: "layout_type".}: cstring
    output_filename* {.importc: "output_filename".}: cstring
    output_file* {.importc: "output_file".}: ptr FILE
    output_data* {.importc: "output_data".}: cstring
    output_data_allocated* {.importc: "output_data_allocated".}: cuint
    output_data_position* {.importc: "output_data_position".}: cuint
    output_langname* {.importc: "output_langname".}: cstring
    output_lang* {.importc: "output_lang".}: cint
    render* {.importc: "render".}: gvplugin_active_render_t
    device* {.importc: "device".}: gvplugin_active_device_t
    loadimage* {.importc: "loadimage".}: gvplugin_active_loadimage_t
    callbacks* {.importc: "callbacks".}: ptr gvdevice_callbacks_t
    device_dpi* {.importc: "device_dpi".}: pointf
    device_tets_dpi* {.importc: "device_tets_dpi".}: boolean
    display* {.importc: "display".}: pointer
    screen* {.importc: "screen".}: cint
    context* {.importc: "context".}: pointer ##  gd or cairo surface
    external_context* {.importc: "external_context".}: boolean ##  context belongs to caller
    imagedata* {.importc: "imagedata".}: cstring ##  location of imagedata
    flags* {.importc: "flags".}: cint ##  emit_graph flags
    numLayers* {.importc: "numLayers".}: cint ##  number of layers
    layerNum* {.importc: "layerNum".}: cint ##  current layer - 1 based
    pagesArraySize* {.importc: "pagesArraySize".}: point ##  2D size of page array
    pagesArrayFirst* {.importc: "pagesArrayFirst".}: point ##  2D starting corner in
    pagesArrayMajor* {.importc: "pagesArrayMajor".}: point ##  2D major increment
    pagesArrayMinor* {.importc: "pagesArrayMinor".}: point ##  2D minor increment
    pagesArrayElem* {.importc: "pagesArrayElem".}: point ##  2D coord of current page - 0,0 based
    numPages* {.importc: "numPages".}: cint ##  number of pages
    bb* {.importc: "bb".}: boxf  ##  graph bb with padding - graph units
    pad* {.importc: "pad".}: pointf ##  padding around bb - graph units
    clip* {.importc: "clip".}: boxf ##  clip region in graph units
    pageBox* {.importc: "pageBox".}: boxf ##  current page in graph units
    pageSize* {.importc: "pageSize".}: pointf ##  page size in graph units
    focus* {.importc: "focus".}: pointf ##  viewport focus - graph units
    zoom* {.importc: "zoom".}: cdouble ##  viewport zoom factor (points per graph unit)
    rotation* {.importc: "rotation".}: cint ##  viewport rotation (degrees)  0=portrait, 90=landscape
    view* {.importc: "view".}: pointf ##  viewport size - points
    canvasBox* {.importc: "canvasBox".}: boxf ##  viewport area - points
    margin* {.importc: "margin".}: pointf ##  job-specific margin - points
    dpi* {.importc: "dpi".}: pointf ##  device resolution device-units-per-inch
    width* {.importc: "width".}: cuint ##  device width - device units
    height* {.importc: "height".}: cuint ##  device height - device units
    pageBoundingBox* {.importc: "pageBoundingBox".}: box ##  rotated boundingBox - device units
    boundingBox* {.importc: "boundingBox".}: box ##  cumulative boundingBox over all pages - device units
    scale* {.importc: "scale".}: pointf ##  composite device to graph units (zoom and dpi)
    translation* {.importc: "translation".}: pointf ##  composite translation
    devscale* {.importc: "devscale".}: pointf ##  composite device to points: dpi, y_goes_down
    fit_mode* {.importc: "fit_mode".}: boolean
    needs_refresh* {.importc: "needs_refresh".}: boolean
    click* {.importc: "click".}: boolean
    has_grown* {.importc: "has_grown".}: boolean
    has_been_rendered* {.importc: "has_been_rendered".}: boolean
    button* {.importc: "button".}: cuchar ##  active button
    pointer* {.importc: "pointer".}: pointf ##  pointer position in device units
    oldpointer* {.importc: "oldpointer".}: pointf ##  old pointer position in device units
    current_obj* {.importc: "current_obj".}: pointer ##  graph object that pointer is in currently
    selected_obj* {.importc: "selected_obj".}: pointer ##  graph object that has been selected
                                                   ##  (e.g. button 1 clicked on current obj)
    active_tooltip* {.importc: "active_tooltip".}: cstring ##  tooltip of active object - or NULL
    selected_href* {.importc: "selected_href".}: cstring ##  href of selected object - or NULL
    selected_obj_type_name* {.importc: "selected_obj_type_name".}: gv_argvlist_t ##  (e.g. "edge" "node3" "e" "->" "node5" "")
    selected_obj_attributes* {.importc: "selected_obj_attributes".}: gv_argvlist_t ##  attribute triplets: name, value, type
                                                                               ##  e.g. "color", "red", GVATTR_COLOR,
                                                                               ## 					"style", "filled", GVATTR_BOOL,
    window* {.importc: "window".}: pointer ##  display-specific data for gvrender plugin
                                       ##  keybindings for keyboard events
    keybindings* {.importc: "keybindings".}: ptr gvevent_key_binding_t
    numkeys* {.importc: "numkeys".}: cint
    keycodes* {.importc: "keycodes".}: pointer

