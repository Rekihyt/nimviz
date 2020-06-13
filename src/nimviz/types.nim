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

##  Define if you want CGRAPH

const
  WITH_CGRAPH* = 1

type
  boolean* = cuchar

when not defined(NOT):
  template NOT*(v: untyped): untyped =
    (not (v))

import
  geom, gvcext, pathgeom, textspan, cgraph

import
  usershape

type
  qsort_cmpf* = proc (a1: pointer; a2: pointer): cint
  bsearch_cmpf* = proc (a1: pointer; a2: pointer): cint
  graph_t* = Agraph_t
  node_t* = Agnode_t
  edge_t* = Agedge_t
  attrsym_t* = Agsym_t

const
  TAIL_ID* = "tailport"
  HEAD_ID* = "headport"

type
  htmlLabelT* = object
  INNER_C_STRUCT_types_58* {.importc: "no_name", header: "graphviz/types.h", bycopy.} = object
    p* {.importc: "p".}: ptr pointf
    r* {.importc: "r".}: ptr cdouble

  INNER_C_STRUCT_types_62* {.importc: "no_name", header: "graphviz/types.h", bycopy.} = object
    n* {.importc: "n".}: ptr node_t
    bp* {.importc: "bp".}: ptr boxf

  INNER_C_STRUCT_types_131* {.importc: "no_name", header: "graphviz/types.h", bycopy.} = object
    span* {.importc: "span".}: ptr textspan_t
    nspans* {.importc: "nspans".}: cshort

  INNER_C_UNION_types_130* {.importc: "no_name", header: "graphviz/types.h", bycopy, union.} = object
    txt* {.importc: "txt".}: INNER_C_STRUCT_types_131
    html* {.importc: "html".}: ptr htmllabel_t

  inside_t* {.importc: "inside_t", header: "graphviz/types.h", bycopy, union.} = object
    a* {.importc: "a".}: INNER_C_STRUCT_types_58
    s* {.importc: "s".}: INNER_C_STRUCT_types_62

  port* {.importc: "port", header: "graphviz/types.h", bycopy.} = object
    p* {.importc: "p".}: pointf  ##  internal edge endpoint specification
    ##  aiming point relative to node center
    theta* {.importc: "theta".}: cdouble ##  slope in radians
    bp* {.importc: "bp".}: ptr boxf ##  if not null, points to bbox of
                               ##  rectangular area that is port target
                               ##
    defined* {.importc: "defined".}: boolean ##  if true, edge has port info at this end
    constrained* {.importc: "constrained".}: boolean ##  if true, constraints such as theta are set
    clip* {.importc: "clip".}: boolean ##  if true, clip end to node/port shape
    dyna* {.importc: "dyna".}: boolean ##  if true, assign compass point dynamically
    order* {.importc: "order".}: cuchar ##  for mincross
    side* {.importc: "side".}: cuchar ##  if port is on perimeter of node, this
                                  ##  contains the bitwise OR of the sides (TOP,
                                  ##  BOTTOM, etc.) it is on.
                                  ##
    name* {.importc: "name".}: cstring ##  port name, if it was explicitly given, otherwise NULL

  splineInfo* {.importc: "splineInfo", header: "graphviz/types.h", bycopy.} = object
    swapEnds* {.importc: "swapEnds".}: proc (e: ptr edge_t): boolean ##  Should head and tail be swapped?
    splineMerge* {.importc: "splineMerge".}: proc (n: ptr node_t): boolean ##  Is n a node in the middle of an edge?
    ignoreSwap* {.importc: "ignoreSwap".}: boolean ##  Test for swapped edges if false
    isOrtho* {.importc: "isOrtho".}: boolean ##  Orthogonal routing used

  pathend_t* {.importc: "pathend_t", header: "graphviz/types.h", bycopy.} = object
    nb* {.importc: "nb".}: boxf  ##  the node box
    np* {.importc: "np".}: pointf ##  node port
    sidemask* {.importc: "sidemask".}: cint
    boxn* {.importc: "boxn".}: cint
    boxes* {.importc: "boxes".}: array[20, boxf]

  path* {.importc: "path", header: "graphviz/types.h", bycopy.} = object
    start* {.importc: "start".}: port ##  internal specification for an edge spline
    `end`* {.importc: "end".}: port
    nbox* {.importc: "nbox".}: cint ##  number of subdivisions
    boxes* {.importc: "boxes".}: ptr boxf ##  rectangular regions of subdivision
    data* {.importc: "data".}: pointer

  bezier* {.importc: "bezier", header: "graphviz/types.h", bycopy.} = object
    list* {.importc: "list".}: ptr pointf
    size* {.importc: "size".}: cint
    sflag* {.importc: "sflag".}: cint
    eflag* {.importc: "eflag".}: cint
    sp* {.importc: "sp".}: pointf
    ep* {.importc: "ep".}: pointf

  splines* {.importc: "splines", header: "graphviz/types.h", bycopy.} = object
    list* {.importc: "list".}: ptr bezier
    size* {.importc: "size".}: cint
    bb* {.importc: "bb".}: boxf

  textlabel_t* {.importc: "textlabel_t", header: "graphviz/types.h", bycopy.} = object
    text* {.importc: "text".}: cstring
    fontname* {.importc: "fontname".}: cstring
    fontcolor* {.importc: "fontcolor".}: cstring
    charset* {.importc: "charset".}: cint
    fontsize* {.importc: "fontsize".}: cdouble
    dimen* {.importc: "dimen".}: pointf ##  the diagonal size of the label (estimated by layout)
    space* {.importc: "space".}: pointf ##  the diagonal size of the space for the label
                                    ##    the rendered label is aligned in this box
                                    ##    space does not include pad or margin
    pos* {.importc: "pos".}: pointf ##  the center of the space for the label
    u* {.importc: "u".}: INNER_C_UNION_types_130
    valign* {.importc: "valign".}: char ##  't' 'c' 'b'
    set* {.importc: "set".}: boolean ##  true if position is set
    html* {.importc: "html".}: boolean ##  true if html label

  polygon_t* {.importc: "polygon_t", header: "graphviz/types.h", bycopy.} = object
    regular* {.importc: "regular".}: cint ##  mutable shape information for a node
    ##  true for symmetric shapes
    peripheries* {.importc: "peripheries".}: cint ##  number of periphery lines
    sides* {.importc: "sides".}: cint ##  number of sides
    orientation* {.importc: "orientation".}: cdouble ##  orientation of shape (+ve degrees)
    distortion* {.importc: "distortion".}: cdouble ##  distortion factor - as in trapezium
    skew* {.importc: "skew".}: cdouble ##  skew factor - as in parallelogram
    option* {.importc: "option".}: cint ##  ROUNDED, DIAGONAL corners, etc.
    vertices* {.importc: "vertices".}: ptr pointf ##  array of vertex points

  stroke_t* {.importc: "stroke_t", header: "graphviz/types.h", bycopy.} = object
    nvertices* {.importc: "nvertices".}: cint ##  information about a single stroke
                                          ##  we would have called it a path if that term wasn't already used
    ##  number of points in the stroke
    flags* {.importc: "flags".}: cint ##  stroke style flags
    vertices* {.importc: "vertices".}: ptr pointf ##  array of vertex points


##  flag definitions for stroke_t

const
  STROKE_CLOSED* = (1 shl 0)
  STROKE_FILLED* = (1 shl 1)
  STROKE_PENDOWN* = (1 shl 2)
  STROKE_VERTICES_ALLOCATED* = (1 shl 3)

type
  shape_t* {.importc: "shape_t", header: "graphviz/types.h", bycopy.} = object
    nstrokes* {.importc: "nstrokes".}: cint ##  mutable shape information for a node
    ##  number of strokes in array
    strokes* {.importc: "strokes".}: ptr stroke_t ##  array of strokes
                                             ##  The last stroke must always be closed, but can be pen_up.
                                             ##  It is used as the clipping path

  shape_functions* {.importc: "shape_functions", header: "graphviz/types.h", bycopy.} = object
    initfn* {.importc: "initfn".}: proc (a1: ptr node_t) ##  read-only shape functions
    ##  initializes shape from node u.shape_info structure
    freefn* {.importc: "freefn".}: proc (a1: ptr node_t) ##  frees  shape from node u.shape_info structure
    portfn* {.importc: "portfn".}: proc (a1: ptr node_t; a2: cstring; a3: cstring): port ##  finds aiming point and slope of port
    insidefn* {.importc: "insidefn".}: proc (inside_context: ptr inside_t; a2: pointf): boolean ##  clips incident gvc->e spline on shape of gvc->n
    pboxfn* {.importc: "pboxfn".}: proc (n: ptr node_t; p: ptr port; side: cint;
                                     rv: ptr boxf; kptr: ptr cint): cint ##  finds box path to reach port
    codefn* {.importc: "codefn".}: proc (job: ptr GVJ_t; n: ptr node_t) ##  emits graphics code for node

  shape_kind* {.size: sizeof(cint).} = enum
    SH_UNSET, SH_POLY, SH_RECORD, SH_POINT, SH_EPSF
  shape_desc* {.importc: "shape_desc", header: "graphviz/types.h", bycopy.} = object
    name* {.importc: "name".}: cstring ##  read-only shape descriptor
    ##  as read from graph file
    fns* {.importc: "fns".}: ptr shape_functions
    polygon* {.importc: "polygon".}: ptr polygon_t ##  base polygon info
    usershape* {.importc: "usershape".}: boolean



type                          ##  usershapes needed by gvc
  nodequeue* {.importc: "nodequeue", header: "graphviz/types.h", bycopy.} = object
    store* {.importc: "store".}: ptr ptr node_t
    limit* {.importc: "limit".}: ptr ptr node_t
    head* {.importc: "head".}: ptr ptr node_t
    tail* {.importc: "tail".}: ptr ptr node_t

  adjmatrix_t* {.importc: "adjmatrix_t", header: "graphviz/types.h", bycopy.} = object
    nrows* {.importc: "nrows".}: cint
    ncols* {.importc: "ncols".}: cint
    data* {.importc: "data".}: cstring

  rank_t* {.importc: "rank_t", header: "graphviz/types.h", bycopy.} = object
    n* {.importc: "n".}: cint    ##  number of nodes in this rank
    v* {.importc: "v".}: ptr ptr node_t ##  ordered list of nodes in rank
    an* {.importc: "an".}: cint  ##  globally allocated number of nodes
    av* {.importc: "av".}: ptr ptr node_t ##  allocated list of nodes in rank
    ht1* {.importc: "ht1".}: cdouble
    ht2* {.importc: "ht2".}: cdouble ##  height below/above centerline
    pht1* {.importc: "pht1".}: cdouble
    pht2* {.importc: "pht2".}: cdouble ##  as above, but only primitive nodes
    candidate* {.importc: "candidate".}: boolean ##  for transpose ()
    valid* {.importc: "valid".}: boolean
    cache_nc* {.importc: "cache_nc".}: cint ##  caches number of crossings
    flat* {.importc: "flat".}: ptr adjmatrix_t

  ratio_t* {.size: sizeof(cint).} = enum
    R_NONE = 0, R_VALUE, R_FILL, R_COMPRESS, R_AUTO, R_EXPAND
  layout_t* {.importc: "layout_t", header: "graphviz/types.h", bycopy.} = object
    quantum* {.importc: "quantum".}: cdouble
    scale* {.importc: "scale".}: cdouble
    ratio* {.importc: "ratio".}: cdouble ##  set only if ratio_kind == R_VALUE
    dpi* {.importc: "dpi".}: cdouble
    margin* {.importc: "margin".}: pointf
    page* {.importc: "page".}: pointf
    size* {.importc: "size".}: pointf
    filled* {.importc: "filled".}: boolean
    landscape* {.importc: "landscape".}: boolean
    centered* {.importc: "centered".}: boolean
    ratio_kind* {.importc: "ratio_kind".}: ratio_t
    xdots* {.importc: "xdots".}: pointer
    id* {.importc: "id".}: cstring



##  for "record" shapes

type
  field_t* {.importc: "field_t", header: "graphviz/types.h", bycopy.} = object
    size* {.importc: "size".}: pointf ##  its dimension
    b* {.importc: "b".}: boxf    ##  its placement in node's coordinates
    n_flds* {.importc: "n_flds".}: cint
    lp* {.importc: "lp".}: ptr textlabel_t ##  n_flds == 0
    fld* {.importc: "fld".}: ptr ptr field_t ##  n_flds > 0
    id* {.importc: "id".}: cstring ##  user's identifier
    LR* {.importc: "LR".}: cuchar ##  if box list is horizontal (left to right)
    sides* {.importc: "sides".}: cuchar ##  sides of node exposed to field

  nlist_t* {.importc: "nlist_t", header: "graphviz/types.h", bycopy.} = object
    list* {.importc: "list".}: ptr ptr node_t
    size* {.importc: "size".}: cint

  elist* {.importc: "elist", header: "graphviz/types.h", bycopy.} = object
    list* {.importc: "list".}: ptr ptr edge_t
    size* {.importc: "size".}: cint


const
  GUI_STATE_ACTIVE* = (1 shl 0)
  GUI_STATE_SELECTED* = (1 shl 1)
  GUI_STATE_VISITED* = (1 shl 2)
  GUI_STATE_DELETED* = (1 shl 3)

template elist_fastapp*(item, L: untyped): void =
  while true:
    L.list[inc(L.size)] = item
    L.list[L.size] = nil
    if not 0:
      break

##  #define elist_append(item,L)  do {L.list = ALLOC( L.size + 2, L.list, edge_t* ); L.list[L.size++] = item; L.list[L.size] = NULL;} while(0)
##  #define alloc_elist(n,L)      do {L.size = 0; L.list = N_NEW(n + 1,edge_t*); } while (0)

template free_list*(L: untyped): void =
  while true:
    if L.list:
      free(L.list)
    if not 0:
      break

type
  fontname_kind* {.size: sizeof(cint).} = enum
    NATIVEFONTS, PSFONTS, SVGFONTS
  Agraphinfo_t* {.importc: "Agraphinfo_t", header: "graphviz/types.h", bycopy.} = object
    hdr* {.importc: "hdr".}: Agrec_t ##  to generate code
    drawing* {.importc: "drawing".}: ptr layout_t
    label* {.importc: "label".}: ptr textlabel_t ##  if the cluster has a title
    bb* {.importc: "bb".}: boxf  ##  bounding box
    border* {.importc: "border".}: array[4, pointf] ##  sizes of margins for graph labels
    gui_ttate* {.importc: "gui_ttate".}: cuchar ##  Graph state for GUI ops
    has_labels* {.importc: "has_labels".}: cuchar
    has_images* {.importc: "has_images".}: boolean
    charset* {.importc: "charset".}: cuchar ##  input character set
    rankdir* {.importc: "rankdir".}: cint
    ht1* {.importc: "ht1".}: cdouble
    ht2* {.importc: "ht2".}: cdouble ##  below and above extremal ranks
    flags* {.importc: "flags".}: cushort
    alg* {.importc: "alg".}: pointer
    gvc* {.importc: "gvc".}: ptr GVC_t ##  context for "globals" over multiple graphs
    cleanup* {.importc: "cleanup".}: proc (g: ptr graph_t) ##  function to deallocate layout-specific data

when not defined(DOT_ONLY):
  ##  to place nodes
  var neato_nlist* {.importc: "neato_nlist", header: "graphviz/types.h".}: ptr ptr node_t
  var move* {.importc: "move", header: "graphviz/types.h".}: cint
  var
    dist* {.importc: "dist", header: "graphviz/types.h".}: ptr ptr cdouble
    spring* {.importc: "spring", header: "graphviz/types.h".}: ptr ptr cdouble
    sum_t* {.importc: "sum_t", header: "graphviz/types.h".}: ptr ptr cdouble
    t* {.importc: "t", header: "graphviz/types.h".}: ptr ptr ptr cdouble
  var ndim* {.importc: "ndim", header: "graphviz/types.h".}: cushort
  var odim* {.importc: "odim", header: "graphviz/types.h".}: cushort
  var pinned* {.importc: "pinned", header: "graphviz/types.h".}: cuchar
  var
    id* {.importc: "id", header: "graphviz/types.h".}: cint
    heapindex* {.importc: "heapindex", header: "graphviz/types.h".}: cint
    hops* {.importc: "hops", header: "graphviz/types.h".}: cint
  var
    pos* {.importc: "pos", header: "graphviz/types.h".}: ptr cdouble
    # DUPLICATE
    # dist* {.importc: "dist", header: "graphviz/types.h".}: cdouble
  var factor* {.importc: "factor", header: "graphviz/types.h".}: cdouble
  # DUPLICATE
  # var path* {.importc: "path", header: "graphviz/types.h".}: Ppolyline_t

elif not defined(NEATO_ONLY):
  ##  to have subgraphs
  var n_cluster* {.importc: "n_cluster", header: "graphviz/types.h".}: cint
  var clust* {.importc: "clust", header: "graphviz/types.h".}: ptr ptr graph_t
  ##  clusters are in clust[1..n_cluster] !!!
  var dotroot* {.importc: "dotroot", header: "graphviz/types.h".}: ptr graph_t
  var nlist* {.importc: "nlist", header: "graphviz/types.h".}: ptr node_t
  var rank* {.importc: "rank", header: "graphviz/types.h".}: ptr rank_t
  var parent* {.importc: "parent", header: "graphviz/types.h".}: ptr graph_t
  ##  containing cluster (not parent subgraph)
  var level* {.importc: "level", header: "graphviz/types.h".}: cint
  ##  cluster nesting level (not node level!)
  var
    minrep* {.importc: "minrep", header: "graphviz/types.h".}: ptr node_t
    maxrep* {.importc: "maxrep", header: "graphviz/types.h".}: ptr node_t
  ##  set leaders for min and max rank
  ##  fast graph node list
  var comp* {.importc: "comp", header: "graphviz/types.h".}: nlist_t
  ##  connected components
  var
    minset* {.importc: "minset", header: "graphviz/types.h".}: ptr node_t
    maxset* {.importc: "maxset", header: "graphviz/types.h".}: ptr node_t
  ##  set leaders
  var n_nodes* {.importc: "n_nodes", header: "graphviz/types.h".}: clong
  ##  includes virtual
  var
    minrank* {.importc: "minrank", header: "graphviz/types.h".}: cshort
    maxrank* {.importc: "maxrank", header: "graphviz/types.h".}: cshort
  ##  various flags
  var has_flat_edges* {.importc: "has_flat_edges", header: "graphviz/types.h".}: boolean
  var has_tourcerank* {.importc: "has_tourcerank", header: "graphviz/types.h".}: boolean
  var has_tinkrank* {.importc: "has_tinkrank", header: "graphviz/types.h".}: boolean
  var showboxes* {.importc: "showboxes", header: "graphviz/types.h".}: cuchar
  var fontnames* {.importc: "fontnames", header: "graphviz/types.h".}: fontname_kind
  ##  to override mangling in SVG
  var
    nodesep* {.importc: "nodesep", header: "graphviz/types.h".}: cint
    ranksep* {.importc: "ranksep", header: "graphviz/types.h".}: cint
  var
    ln* {.importc: "ln", header: "graphviz/types.h".}: ptr node_t
    rn* {.importc: "rn", header: "graphviz/types.h".}: ptr node_t
  ##  left, right nodes of bounding box
  ##  for clusters
  var
    leader* {.importc: "leader", header: "graphviz/types.h".}: ptr node_t
    rankleader* {.importc: "rankleader", header: "graphviz/types.h".}: ptr ptr node_t
  var expanded* {.importc: "expanded", header: "graphviz/types.h".}: boolean
  var installed* {.importc: "installed", header: "graphviz/types.h".}: char
  var set_type* {.importc: "set_type", header: "graphviz/types.h".}: char
  var label_pos* {.importc: "label_pos", header: "graphviz/types.h".}: char
  var exact_ranksep* {.importc: "exact_ranksep", header: "graphviz/types.h".}: boolean

  var showboxes* {.importc: "showboxes", header: "graphviz/types.h".}: cuchar
  var has_port* {.importc: "has_port", header: "graphviz/types.h".}: boolean
  var rep* {.importc: "rep", header: "graphviz/types.h".}: ptr node_t
  var `set`* {.importc: "set", header: "graphviz/types.h".}: ptr node_t
  ##  fast graph
  var
    node_type* {.importc: "node_type", header: "graphviz/types.h".}: char
    mark* {.importc: "mark", header: "graphviz/types.h".}: char
    onstack* {.importc: "onstack", header: "graphviz/types.h".}: char
  var
    ranktype* {.importc: "ranktype", header: "graphviz/types.h".}: char
    weight_class* {.importc: "weight_class", header: "graphviz/types.h".}: char
  var
    next* {.importc: "next", header: "graphviz/types.h".}: ptr node_t
    prev* {.importc: "prev", header: "graphviz/types.h".}: ptr node_t
  var
    `in`* {.importc: "in", header: "graphviz/types.h".}: elist
    `out`* {.importc: "out", header: "graphviz/types.h".}: elist
    flat_out* {.importc: "flat_out", header: "graphviz/types.h".}: elist
    flat_in* {.importc: "flat_in", header: "graphviz/types.h".}: elist
    other* {.importc: "other", header: "graphviz/types.h".}: elist
  var clust* {.importc: "clust", header: "graphviz/types.h".}: ptr graph_t
  ##  for union-find and collapsing nodes
  var UF_tize* {.importc: "UF_tize", header: "graphviz/types.h".}: cint
  var UF_parent* {.importc: "UF_parent", header: "graphviz/types.h".}: ptr node_t
  var
    inleaf* {.importc: "inleaf", header: "graphviz/types.h".}: ptr node_t
    outleaf* {.importc: "outleaf", header: "graphviz/types.h".}: ptr node_t
  ##  for placing nodes
  var
    rank* {.importc: "rank", header: "graphviz/types.h".}: cint
    order* {.importc: "order", header: "graphviz/types.h".}: cint
  ##  initially, order = 1 for ordered edges
  var mval* {.importc: "mval", header: "graphviz/types.h".}: cdouble
  var
    save_in* {.importc: "save_in", header: "graphviz/types.h".}: elist
    save_out* {.importc: "save_out", header: "graphviz/types.h".}: elist
  ##  for network-simplex
  var
    tree_in* {.importc: "tree_in", header: "graphviz/types.h".}: elist
    tree_out* {.importc: "tree_out", header: "graphviz/types.h".}: elist
  var par* {.importc: "par", header: "graphviz/types.h".}: ptr edge_t
  var
    low* {.importc: "low", header: "graphviz/types.h".}: cint
    lim* {.importc: "lim", header: "graphviz/types.h".}: cint
  var priority* {.importc: "priority", header: "graphviz/types.h".}: cint
  var pad* {.importc: "pad", header: "graphviz/types.h".}: array[1, cdouble]

  var showboxes* {.importc: "showboxes", header: "graphviz/types.h".}: cuchar
  var conc_opp_flag* {.importc: "conc_opp_flag", header: "graphviz/types.h".}: boolean
  var xpenalty* {.importc: "xpenalty", header: "graphviz/types.h".}: cshort
  var weight* {.importc: "weight", header: "graphviz/types.h".}: cint
  var
    cutvalue* {.importc: "cutvalue", header: "graphviz/types.h".}: cint
    tree_index* {.importc: "tree_index", header: "graphviz/types.h".}: cint
  var count* {.importc: "count", header: "graphviz/types.h".}: cshort
  var minlen* {.importc: "minlen", header: "graphviz/types.h".}: cushort
  var to_virt* {.importc: "to_virt", header: "graphviz/types.h".}: ptr edge_t



template GD_parent*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).parent)

template GD_level*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).level)

template GD_drawing*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).drawing)

template GD_bb*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).bb)

template GD_gvc*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).gvc)

template GD_cleanup*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).cleanup)

template GD_dist*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).dist)

template GD_alg*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).alg)

template GD_border*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).border)

template GD_cl_cnt*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).cl_nt)

template GD_clust*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).clust)

template GD_dotroot*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).dotroot)

template GD_comp*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).comp)

template GD_exact_ranksep*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).exact_ranksep)

template GD_expanded*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).expanded)

template GD_flags*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).flags)

template GD_gui_ttate*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).gui_ttate)

template GD_charset*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).charset)

template GD_has_labels*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).has_labels)

template GD_has_images*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).has_images)

template GD_has_flat_edges*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).has_flat_edges)

template GD_has_tourcerank*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).has_tourcerank)

template GD_has_tinkrank*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).has_tinkrank)

template GD_ht1*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).ht1)

template GD_ht2*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).ht2)

template GD_inleaf*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).inleaf)

template GD_installed*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).installed)

template GD_label*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).label)

template GD_leader*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).leader)

template GD_rankdir2*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).rankdir)

template GD_rankdir*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).rankdir and 0x00000003)

template GD_flip*(g: untyped): untyped =
  (GD_rankdir(g) and 1)

template GD_realrankdir*(g: untyped): untyped =
  (((cast[ptr Agraphinfo_t](AGDATA(g))).rankdir) shr 2)

template GD_realflip*(g: untyped): untyped =
  (GD_realrankdir(g) and 1)

template GD_ln*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).ln)

template GD_maxrank*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).maxrank)

template GD_maxset*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).maxset)

template GD_minrank*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).minrank)

template GD_minset*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).minset)

template GD_minrep*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).minrep)

template GD_maxrep*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).maxrep)

template GD_move*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).move)

template GD_n_cluster*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).n_cluster)

template GD_n_nodes*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).n_nodes)

template GD_ndim*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).ndim)

template GD_odim*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).odim)

template GD_neato_nlist*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).neato_nlist)

template GD_nlist*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).nlist)

template GD_nodesep*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).nodesep)

template GD_outleaf*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).outleaf)

template GD_rank*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).rank)

template GD_rankleader*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).rankleader)

template GD_ranksep*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).ranksep)

template GD_rn*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).rn)

template GD_tet_type*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).set_type)

template GD_label_pos*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).label_pos)

template GD_thowboxes*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).showboxes)

template GD_fontnames*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).fontnames)

template GD_tpring*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).spring)

template GD_tum_t*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).sum_t)

template GD_t*(g: untyped): untyped =
  ((cast[ptr Agraphinfo_t](AGDATA(g))).t)

type
  Agnodeinfo_t* {.importc: "Agnodeinfo_t", header: "graphviz/types.h", bycopy.} = object
    hdr* {.importc: "hdr".}: Agrec_t
    shape* {.importc: "shape".}: ptr shape_desc
    shape_info* {.importc: "shape_info".}: pointer
    coord* {.importc: "coord".}: pointf
    width* {.importc: "width".}: cdouble
    height* {.importc: "height".}: cdouble ##  inches
    bb* {.importc: "bb".}: boxf
    ht* {.importc: "ht".}: cdouble
    lw* {.importc: "lw".}: cdouble
    rw* {.importc: "rw".}: cdouble
    label* {.importc: "label".}: ptr textlabel_t
    xlabel* {.importc: "xlabel".}: ptr textlabel_t
    alg* {.importc: "alg".}: pointer
    state* {.importc: "state".}: char
    gui_ttate* {.importc: "gui_ttate".}: cuchar ##  Node state for GUI ops
    clustnode* {.importc: "clustnode".}: boolean

template ND_id*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).id)

template ND_alg*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).alg)

template ND_UF_parent*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).UF_parent)

template ND_tet*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).set)

template ND_UF_tize*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).UF_tize)

template ND_bb*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).bb)

template ND_clust*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).clust)

template ND_coord*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).coord)

template ND_dist*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).dist)

template ND_flat_in*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).flat_in)

template ND_flat_out*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).flat_out)

template ND_gui_ttate*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).gui_ttate)

template ND_has_port*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).has_port)

template ND_rep*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).rep)

template ND_heapindex*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).heapindex)

template ND_height*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).height)

template ND_hops*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).hops)

template ND_ht*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).ht)

template ND_in*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).`in`)

template ND_inleaf*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).inleaf)

template ND_label*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).label)

template ND_xlabel*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).xlabel)

template ND_lim*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).lim)

template ND_low*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).low)

template ND_lw*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).lw)

template ND_mark*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).mark)

template ND_mval*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).mval)

template ND_n_cluster*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).n_cluster)

template ND_next*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).next)

template ND_node_type*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).node_type)

template ND_onstack*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).onstack)

template ND_order*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).order)

template ND_other*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).other)

template ND_out*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).`out`)

template ND_outleaf*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).outleaf)

template ND_par*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).par)

template ND_pinned*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).pinned)

template ND_pos*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).pos)

template ND_prev*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).prev)

template ND_priority*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).priority)

template ND_rank*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).rank)

template ND_ranktype*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).ranktype)

template ND_rw*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).rw)

template ND_tave_in*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).save_in)

template ND_tave_out*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).save_out)

template ND_thape*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).shape)

template ND_thape_info*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).shape_info)

template ND_thowboxes*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).showboxes)

template ND_ttate*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).state)

template ND_clustnode*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).clustnode)

template ND_tree_in*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).tree_in)

template ND_tree_out*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).tree_out)

template ND_weight_class*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).weight_class)

template ND_width*(n: untyped): untyped =
  ((cast[ptr Agnodeinfo_t](AGDATA(n))).width)

template ND_xsize*(n: untyped): untyped =
  (ND_lw(n) + ND_rw(n))

template ND_ysize*(n: untyped): untyped =
  (ND_ht(n))

type
  Agedgeinfo_t* {.importc: "Agedgeinfo_t", header: "graphviz/types.h", bycopy.} = object
    hdr* {.importc: "hdr".}: Agrec_t
    spl* {.importc: "spl".}: ptr splines
    tail_port* {.importc: "tail_port".}: port
    head_port* {.importc: "head_port".}: port
    label* {.importc: "label".}: ptr textlabel_t
    head_label* {.importc: "head_label".}: ptr textlabel_t
    tail_label* {.importc: "tail_label".}: ptr textlabel_t
    xlabel* {.importc: "xlabel".}: ptr textlabel_t
    edge_type* {.importc: "edge_type".}: char
    adjacent* {.importc: "adjacent".}: char ##  true for flat edge with adjacent nodes
    label_ontop* {.importc: "label_ontop".}: char
    gui_ttate* {.importc: "gui_ttate".}: cuchar ##  Edge state for GUI ops
    to_orig* {.importc: "to_orig".}: ptr edge_t ##  for dot's shapes.c
    alg* {.importc: "alg".}: pointer



template ED_alg*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).alg)

template ED_conc_opp_flag*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).conc_opp_flag)

template ED_count*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).count)

template ED_cutvalue*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).cutvalue)

template ED_edge_type*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).edge_type)

template ED_adjacent*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).adjacent)

template ED_factor*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).factor)

template ED_gui_ttate*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).gui_ttate)

template ED_head_label*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).head_label)

template ED_head_port*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).head_port)

template ED_label*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).label)

template ED_xlabel*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).xlabel)

template ED_label_ontop*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).label_ontop)

template ED_minlen*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).minlen)

template ED_path*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).path)

template ED_thowboxes*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).showboxes)

template ED_tpl*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).spl)

template ED_tail_label*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).tail_label)

template ED_tail_port*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).tail_port)

template ED_to_orig*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).to_orig)

template ED_to_virt*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).to_virt)

template ED_tree_index*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).tree_index)

template ED_xpenalty*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).xpenalty)

template ED_dist*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).dist)

template ED_weight*(e: untyped): untyped =
  ((cast[ptr Agedgeinfo_t](AGDATA(e))).weight)

template ag_xget*(x, a: untyped): untyped =
  agxget(x, a)

template SET_RANKDIR*(g, rd: untyped): untyped =
  (GD_rankdir2(g) = rd)

template agfindedge*(g, t, h: untyped): untyped =
  (agedge(g, t, h, nil, 0))

template agfindnode*(g, n: untyped): untyped =
  (agnode(g, n, 0))

template agfindgraphattr*(g, a: untyped): untyped =
  (agattr(g, AGRAPH, a, nil))

template agfindnodeattr*(g, a: untyped): untyped =
  (agattr(g, AGNODE, a, nil))

template agfindedgeattr*(g, a: untyped): untyped =
  (agattr(g, AGEDGE, a, nil))

type
  gvlayout_features_t* {.importc: "gvlayout_features_t", header: "graphviz/types.h", bycopy.} = object
    flags* {.importc: "flags".}: cint

