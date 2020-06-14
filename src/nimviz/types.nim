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
  QSortCmpF* = proc (a1: pointer; a2: pointer): cint
  BSearchCmpF* = proc (a1: pointer; a2: pointer): cint
  GraphT* = AGraphT
  NodeT* = AgNodeT
  EdgeT* = AgEdgeT
  AttrSymT* = AgSymT

const
  TAIL_ID* = "tailport"
  HEAD_ID* = "headport"

type
  HtmlLabelT* = object
  INNER_C_STRUCT_Types_58* {.importc: "no_name", header: "graphviz/types.h", bycopy.} = object
    p* {.importc: "p".}: ptr pointf
    r* {.importc: "r".}: ptr cdouble

  INNER_C_STRUCT_Types_62* {.importc: "no_name", header: "graphviz/types.h", bycopy.} = object
    n* {.importc: "n".}: ptr NodeT
    bp* {.importc: "bp".}: ptr boxf

  INNER_C_STRUCT_Types_131* {.importc: "no_name", header: "graphviz/types.h", bycopy.} = object
    span* {.importc: "span".}: ptr TextSpanT
    nspans* {.importc: "nspans".}: cshort

  INNER_C_UNION_Types_130* {.importc: "no_name", header: "graphviz/types.h", bycopy, union.} = object
    txt* {.importc: "txt".}: INNER_C_STRUCT_Types_131
    html* {.importc: "html".}: ptr HtmlLabelT

  insideT* {.importc: "inside_t", header: "graphviz/types.h", bycopy, union.} = object
    a* {.importc: "a".}: INNER_C_STRUCT_Types_58
    s* {.importc: "s".}: INNER_C_STRUCT_Types_62

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
    swapEnds* {.importc: "swapEnds".}: proc (e: ptr EdgeT): boolean ##  Should head and tail be swapped?
    splineMerge* {.importc: "splineMerge".}: proc (n: ptr NodeT): boolean ##  Is n a node in the middle of an edge?
    ignoreSwap* {.importc: "ignoreSwap".}: boolean ##  Test for swapped edges if false
    isOrtho* {.importc: "isOrtho".}: boolean ##  Orthogonal routing used

  pathendT* {.importc: "pathend_t", header: "graphviz/types.h", bycopy.} = object
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

  textlabelT* {.importc: "textlabel_t", header: "graphviz/types.h", bycopy.} = object
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
    u* {.importc: "u".}: INNER_C_UNION_Types_130
    valign* {.importc: "valign".}: char ##  't' 'c' 'b'
    set* {.importc: "set".}: boolean ##  true if position is set
    html* {.importc: "html".}: boolean ##  true if html label

  polygonT* {.importc: "polygon_t", header: "graphviz/types.h", bycopy.} = object
    regular* {.importc: "regular".}: cint ##  mutable shape information for a node
    ##  true for symmetric shapes
    peripheries* {.importc: "peripheries".}: cint ##  number of periphery lines
    sides* {.importc: "sides".}: cint ##  number of sides
    orientation* {.importc: "orientation".}: cdouble ##  orientation of shape (+ve degrees)
    distortion* {.importc: "distortion".}: cdouble ##  distortion factor - as in trapezium
    skew* {.importc: "skew".}: cdouble ##  skew factor - as in parallelogram
    option* {.importc: "option".}: cint ##  ROUNDED, DIAGONAL corners, etc.
    vertices* {.importc: "vertices".}: ptr pointf ##  array of vertex points

  strokeT* {.importc: "stroke_t", header: "graphviz/types.h", bycopy.} = object
    nvertices* {.importc: "nvertices".}: cint ##  information about a single stroke
                                          ##  we would have called it a path if that term wasn't already used
    ##  number of points in the stroke
    flags* {.importc: "flags".}: cint ##  stroke style flags
    vertices* {.importc: "vertices".}: ptr pointf ##  array of vertex points


##  flag definitions for strokeT

const
  STROKE_CLOSED* = (1 shl 0)
  STROKE_FILLED* = (1 shl 1)
  STROKE_PENDOWN* = (1 shl 2)
  STROKE_VERTICES_ALLOCATED* = (1 shl 3)

type
  ShapeT* {.importc: "shape_t", header: "graphviz/types.h", bycopy.} = object
    nstrokes* {.importc: "nstrokes".}: cint ##  mutable shape information for a node
    ##  number of strokes in array
    strokes* {.importc: "strokes".}: ptr strokeT ##  array of strokes
                                             ##  The last stroke must always be closed, but can be pen_up.
                                             ##  It is used as the clipping path

  ShapeFunctions* {.importc: "shape_functions", header: "graphviz/types.h", bycopy.} = object
    initfn* {.importc: "initfn".}: proc (a1: ptr NodeT) ##  read-only shape functions
    ##  initializes shape from node u.shape_info structure
    freefn* {.importc: "freefn".}: proc (a1: ptr NodeT) ##  frees  shape from node u.shape_info structure
    portfn* {.importc: "portfn".}: proc (a1: ptr NodeT; a2: cstring; a3: cstring): port ##  finds aiming point and slope of port
    insidefn* {.importc: "insidefn".}: proc (inside_context: ptr insideT; a2: pointf): boolean ##  clips incident gvc->e spline on shape of gvc->n
    pboxfn* {.importc: "pboxfn".}: proc (n: ptr NodeT; p: ptr port; side: cint;
                                     rv: ptr boxf; kptr: ptr cint): cint ##  finds box path to reach port
    codefn* {.importc: "codefn".}: proc (job: ptr GVJT; n: ptr NodeT) ##  emits graphics code for node

  ShapeKind* {.size: sizeof(cint).} = enum
    SH_UNSET, SH_POLY, SH_RECORD, SH_POINT, SH_EPSF
  ShapeDesc* {.importc: "shape_desc", header: "graphviz/types.h", bycopy.} = object
    name* {.importc: "name".}: cstring ##  read-only shape descriptor
    ##  as read from graph file
    fns* {.importc: "fns".}: ptr ShapeFunctions
    polygon* {.importc: "polygon".}: ptr polygonT ##  base polygon info
    usershape* {.importc: "usershape".}: boolean



type                          ##  usershapes needed by gvc
  Nodequeue* {.importc: "nodequeue", header: "graphviz/types.h", bycopy.} = object
    store* {.importc: "store".}: ptr ptr NodeT
    limit* {.importc: "limit".}: ptr ptr NodeT
    head* {.importc: "head".}: ptr ptr NodeT
    tail* {.importc: "tail".}: ptr ptr NodeT

  AdjmatrixT* {.importc: "adjmatrix_t", header: "graphviz/types.h", bycopy.} = object
    nrows* {.importc: "nrows".}: cint
    ncols* {.importc: "ncols".}: cint
    data* {.importc: "data".}: cstring

  RankT* {.importc: "rank_t", header: "graphviz/types.h", bycopy.} = object
    n* {.importc: "n".}: cint    ##  number of nodes in this rank
    v* {.importc: "v".}: ptr ptr NodeT ##  ordered list of nodes in rank
    an* {.importc: "an".}: cint  ##  globally allocated number of nodes
    av* {.importc: "av".}: ptr ptr NodeT ##  allocated list of nodes in rank
    ht1* {.importc: "ht1".}: cdouble
    ht2* {.importc: "ht2".}: cdouble ##  height below/above centerline
    pht1* {.importc: "pht1".}: cdouble
    pht2* {.importc: "pht2".}: cdouble ##  as above, but only primitive nodes
    candidate* {.importc: "candidate".}: boolean ##  for transpose ()
    valid* {.importc: "valid".}: boolean
    cache_nc* {.importc: "cache_nc".}: cint ##  caches number of crossings
    flat* {.importc: "flat".}: ptr AdjmatrixT

  RatioT* {.size: sizeof(cint).} = enum
    R_NONE = 0, R_VALUE, R_FILL, R_COMPRESS, R_AUTO, R_EXPAND
  LayoutT* {.importc: "layout_t", header: "graphviz/types.h", bycopy.} = object
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
    ratio_kind* {.importc: "ratio_kind".}: RatioT
    xdots* {.importc: "xdots".}: pointer
    id* {.importc: "id".}: cstring



##  for "record" shapes

type
  FieldT* {.importc: "field_t", header: "graphviz/types.h", bycopy.} = object
    size* {.importc: "size".}: pointf ##  its dimension
    b* {.importc: "b".}: boxf    ##  its placement in node's coordinates
    n_flds* {.importc: "n_flds".}: cint
    lp* {.importc: "lp".}: ptr textlabelT ##  n_flds == 0
    fld* {.importc: "fld".}: ptr ptr FieldT ##  n_flds > 0
    id* {.importc: "id".}: cstring ##  user's identifier
    LR* {.importc: "LR".}: cuchar ##  if box list is horizontal (left to right)
    sides* {.importc: "sides".}: cuchar ##  sides of node exposed to field

  NListT* {.importc: "nlist_t", header: "graphviz/types.h", bycopy.} = object
    list* {.importc: "list".}: ptr ptr NodeT
    size* {.importc: "size".}: cint

  EList* {.importc: "elist", header: "graphviz/types.h", bycopy.} = object
    list* {.importc: "list".}: ptr ptr EdgeT
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

##  #define elist_append(item,L)  do {L.list = ALLOC( L.size + 2, L.list, EdgeT* ); L.list[L.size++] = item; L.list[L.size] = NULL;} while(0)
##  #define alloc_elist(n,L)      do {L.size = 0; L.list = N_NEW(n + 1,EdgeT*); } while (0)

template free_list*(L: untyped): void =
  while true:
    if L.list:
      free(L.list)
    if not 0:
      break

type
  FontnameKind* {.size: sizeof(cint).} = enum
    NATIVEFONTS, PSFONTS, SVGFONTS
  AgraphinfoT* {.importc: "Agraphinfo_t", header: "graphviz/types.h", bycopy.} = object
    hdr* {.importc: "hdr".}: AgrecT ##  to generate code
    drawing* {.importc: "drawing".}: ptr LayoutT
    label* {.importc: "label".}: ptr textlabelT ##  if the cluster has a title
    bb* {.importc: "bb".}: boxf  ##  bounding box
    border* {.importc: "border".}: array[4, pointf] ##  sizes of margins for graph labels
    guiTtate* {.importc: "guiTtate".}: cuchar ##  Graph state for GUI ops
    has_labels* {.importc: "has_labels".}: cuchar
    has_images* {.importc: "has_images".}: boolean
    charset* {.importc: "charset".}: cuchar ##  input character set
    rankdir* {.importc: "rankdir".}: cint
    ht1* {.importc: "ht1".}: cdouble
    ht2* {.importc: "ht2".}: cdouble ##  below and above extremal ranks
    flags* {.importc: "flags".}: cushort
    alg* {.importc: "alg".}: pointer
    gvc* {.importc: "gvc".}: ptr GVCT ##  context for "globals" over multiple graphs
    cleanup* {.importc: "cleanup".}: proc (g: ptr GraphT) ##  function to deallocate layout-specific data

when not defined(DOT_ONLY):
  ##  to place nodes
  var neato_nlist* {.importc: "neato_nlist", header: "graphviz/types.h".}: ptr ptr NodeT
  var move* {.importc: "move", header: "graphviz/types.h".}: cint
  var
    dist* {.importc: "dist", header: "graphviz/types.h".}: ptr ptr cdouble
    spring* {.importc: "spring", header: "graphviz/types.h".}: ptr ptr cdouble
    sumT* {.importc: "sum_t", header: "graphviz/types.h".}: ptr ptr cdouble
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
  # var path* {.importc: "path", header: "graphviz/types.h".}: PpolylineT

elif not defined(NEATO_ONLY):
  ##  to have subgraphs
  var n_cluster* {.importc: "n_cluster", header: "graphviz/types.h".}: cint
  var clust* {.importc: "clust", header: "graphviz/types.h".}: ptr ptr GraphT
  ##  clusters are in clust[1..n_cluster] !!!
  var dotroot* {.importc: "dotroot", header: "graphviz/types.h".}: ptr GraphT
  var nlist* {.importc: "nlist", header: "graphviz/types.h".}: ptr NodeT
  var rank* {.importc: "rank", header: "graphviz/types.h".}: ptr rankT
  var parent* {.importc: "parent", header: "graphviz/types.h".}: ptr GraphT
  ##  containing cluster (not parent subgraph)
  var level* {.importc: "level", header: "graphviz/types.h".}: cint
  ##  cluster nesting level (not node level!)
  var
    minrep* {.importc: "minrep", header: "graphviz/types.h".}: ptr NodeT
    maxrep* {.importc: "maxrep", header: "graphviz/types.h".}: ptr NodeT
  ##  set leaders for min and max rank
  ##  fast graph node list
  var comp* {.importc: "comp", header: "graphviz/types.h".}: nlistT
  ##  connected components
  var
    minset* {.importc: "minset", header: "graphviz/types.h".}: ptr NodeT
    maxset* {.importc: "maxset", header: "graphviz/types.h".}: ptr NodeT
  ##  set leaders
  var n_nodes* {.importc: "n_nodes", header: "graphviz/types.h".}: clong
  ##  includes virtual
  var
    minrank* {.importc: "minrank", header: "graphviz/types.h".}: cshort
    maxrank* {.importc: "maxrank", header: "graphviz/types.h".}: cshort
  ##  various flags
  var has_flat_edges* {.importc: "has_flat_edges", header: "graphviz/types.h".}: boolean
  var hasTourcerank* {.importc: "hasTourcerank", header: "graphviz/types.h".}: boolean
  var hasTinkrank* {.importc: "hasTinkrank", header: "graphviz/types.h".}: boolean
  var showboxes* {.importc: "showboxes", header: "graphviz/types.h".}: cuchar
  var fontnames* {.importc: "fontnames", header: "graphviz/types.h".}: fontname_kind
  ##  to override mangling in SVG
  var
    nodesep* {.importc: "nodesep", header: "graphviz/types.h".}: cint
    ranksep* {.importc: "ranksep", header: "graphviz/types.h".}: cint
  var
    ln* {.importc: "ln", header: "graphviz/types.h".}: ptr NodeT
    rn* {.importc: "rn", header: "graphviz/types.h".}: ptr NodeT
  ##  left, right nodes of bounding box
  ##  for clusters
  var
    leader* {.importc: "leader", header: "graphviz/types.h".}: ptr NodeT
    rankleader* {.importc: "rankleader", header: "graphviz/types.h".}: ptr ptr NodeT
  var expanded* {.importc: "expanded", header: "graphviz/types.h".}: boolean
  var installed* {.importc: "installed", header: "graphviz/types.h".}: char
  var setType* {.importc: "setType", header: "graphviz/types.h".}: char
  var label_pos* {.importc: "label_pos", header: "graphviz/types.h".}: char
  var exact_ranksep* {.importc: "exact_ranksep", header: "graphviz/types.h".}: boolean

  var showboxes* {.importc: "showboxes", header: "graphviz/types.h".}: cuchar
  var has_port* {.importc: "has_port", header: "graphviz/types.h".}: boolean
  var rep* {.importc: "rep", header: "graphviz/types.h".}: ptr NodeT
  var `set`* {.importc: "set", header: "graphviz/types.h".}: ptr NodeT
  ##  fast graph
  var
    NodeType* {.importc: "nodeType", header: "graphviz/types.h".}: char
    mark* {.importc: "mark", header: "graphviz/types.h".}: char
    onstack* {.importc: "onstack", header: "graphviz/types.h".}: char
  var
    ranktype* {.importc: "ranktype", header: "graphviz/types.h".}: char
    weight_class* {.importc: "weight_class", header: "graphviz/types.h".}: char
  var
    next* {.importc: "next", header: "graphviz/types.h".}: ptr NodeT
    prev* {.importc: "prev", header: "graphviz/types.h".}: ptr NodeT
  var
    `in`* {.importc: "in", header: "graphviz/types.h".}: elist
    `out`* {.importc: "out", header: "graphviz/types.h".}: elist
    flat_out* {.importc: "flat_out", header: "graphviz/types.h".}: elist
    flat_in* {.importc: "flat_in", header: "graphviz/types.h".}: elist
    other* {.importc: "other", header: "graphviz/types.h".}: elist
  var clust* {.importc: "clust", header: "graphviz/types.h".}: ptr GraphT
  ##  for union-find and collapsing nodes
  var UFTize* {.importc: "UFTize", header: "graphviz/types.h".}: cint
  var UF_parent* {.importc: "UF_parent", header: "graphviz/types.h".}: ptr NodeT
  var
    inleaf* {.importc: "inleaf", header: "graphviz/types.h".}: ptr NodeT
    outleaf* {.importc: "outleaf", header: "graphviz/types.h".}: ptr NodeT
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
  var par* {.importc: "par", header: "graphviz/types.h".}: ptr EdgeT
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
  var to_virt* {.importc: "to_virt", header: "graphviz/types.h".}: ptr EdgeT



template GD_parent*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).parent)

template GD_level*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).level)

template GD_drawing*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).drawing)

template GD_bb*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).bb)

template GD_gvc*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).gvc)

template GD_cleanup*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).cleanup)

template GD_dist*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).dist)

template GD_alg*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).alg)

template GD_border*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).border)

template GD_cl_cnt*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).cl_nt)

template GD_clust*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).clust)

template GD_dotroot*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).dotroot)

template GD_comp*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).comp)

template GD_exact_ranksep*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).exact_ranksep)

template GD_expanded*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).expanded)

template GD_flags*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).flags)

template GD_guiTtate*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).guiTtate)

template GD_charset*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).charset)

template GD_has_labels*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).has_labels)

template GD_has_images*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).has_images)

template GD_has_flat_edges*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).has_flat_edges)

template GD_hasTourcerank*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).hasTourcerank)

template GD_hasTinkrank*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).hasTinkrank)

template GD_ht1*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).ht1)

template GD_ht2*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).ht2)

template GD_inleaf*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).inleaf)

template GD_installed*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).installed)

template GD_label*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).label)

template GD_leader*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).leader)

template GD_rankdir2*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).rankdir)

template GD_rankdir*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).rankdir and 0x00000003)

template GD_flip*(g: untyped): untyped =
  (GD_rankdir(g) and 1)

template GD_realrankdir*(g: untyped): untyped =
  (((cast[ptr AgraphinfoT](AGDATA(g))).rankdir) shr 2)

template GD_realflip*(g: untyped): untyped =
  (GD_realrankdir(g) and 1)

template GD_ln*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).ln)

template GD_maxrank*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).maxrank)

template GD_maxset*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).maxset)

template GD_minrank*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).minrank)

template GD_minset*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).minset)

template GD_minrep*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).minrep)

template GD_maxrep*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).maxrep)

template GD_move*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).move)

template GD_n_cluster*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).n_cluster)

template GD_n_nodes*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).n_nodes)

template GD_ndim*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).ndim)

template GD_odim*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).odim)

template GD_neato_nlist*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).neato_nlist)

template GD_nlist*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).nlist)

template GD_nodesep*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).nodesep)

template GD_outleaf*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).outleaf)

template GD_rank*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).rank)

template GD_rankleader*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).rankleader)

template GD_ranksep*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).ranksep)

template GD_rn*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).rn)

template GDTetType*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).setType)

template GD_label_pos*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).label_pos)

template GDThowboxes*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).showboxes)

template GD_fontnames*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).fontnames)

template GDTpring*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).spring)

template GDTumT*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).sumT)

template GDT*(g: untyped): untyped =
  ((cast[ptr AgraphinfoT](AGDATA(g))).t)

type
  AgnodeinfoT* {.importc: "Agnodeinfo_t", header: "graphviz/types.h", bycopy.} = object
    hdr* {.importc: "hdr".}: AgrecT
    shape* {.importc: "shape".}: ptr ShapeDesc
    shape_info* {.importc: "shape_info".}: pointer
    coord* {.importc: "coord".}: pointf
    width* {.importc: "width".}: cdouble
    height* {.importc: "height".}: cdouble ##  inches
    bb* {.importc: "bb".}: boxf
    ht* {.importc: "ht".}: cdouble
    lw* {.importc: "lw".}: cdouble
    rw* {.importc: "rw".}: cdouble
    label* {.importc: "label".}: ptr textlabelT
    xlabel* {.importc: "xlabel".}: ptr textlabelT
    alg* {.importc: "alg".}: pointer
    state* {.importc: "state".}: char
    guiTtate* {.importc: "guiTtate".}: cuchar ##  Node state for GUI ops
    clustnode* {.importc: "clustnode".}: boolean

template ND_id*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).id)

template ND_alg*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).alg)

template ND_UF_parent*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).UF_parent)

template NDTet*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).set)

template ND_UFTize*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).UFTize)

template ND_bb*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).bb)

template ND_clust*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).clust)

template ND_coord*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).coord)

template ND_dist*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).dist)

template ND_flat_in*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).flat_in)

template ND_flat_out*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).flat_out)

template ND_guiTtate*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).guiTtate)

template ND_has_port*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).has_port)

template ND_rep*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).rep)

template ND_heapindex*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).heapindex)

template ND_height*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).height)

template ND_hops*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).hops)

template ND_ht*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).ht)

template ND_in*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).`in`)

template ND_inleaf*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).inleaf)

template ND_label*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).label)

template ND_xlabel*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).xlabel)

template ND_lim*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).lim)

template ND_low*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).low)

template ND_lw*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).lw)

template ND_mark*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).mark)

template ND_mval*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).mval)

template ND_n_cluster*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).n_cluster)

template ND_next*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).next)

template ND_NodeType*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).NodeType)

template ND_onstack*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).onstack)

template ND_order*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).order)

template ND_other*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).other)

template ND_out*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).`out`)

template ND_outleaf*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).outleaf)

template ND_par*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).par)

template ND_pinned*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).pinned)

template ND_pos*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).pos)

template ND_prev*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).prev)

template ND_priority*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).priority)

template ND_rank*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).rank)

template ND_ranktype*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).ranktype)

template ND_rw*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).rw)

template NDTave_in*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).save_in)

template NDTave_out*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).save_out)

template NDThape*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).shape)

template NDThape_info*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).shape_info)

template NDThowboxes*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).showboxes)

template NDTtate*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).state)

template ND_clustnode*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).clustnode)

template NDTree_in*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).tree_in)

template NDTree_out*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).tree_out)

template ND_weight_class*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).weight_class)

template ND_width*(n: untyped): untyped =
  ((cast[ptr AgnodeinfoT](AGDATA(n))).width)

template ND_xsize*(n: untyped): untyped =
  (ND_lw(n) + ND_rw(n))

template ND_ysize*(n: untyped): untyped =
  (ND_ht(n))

type
  AgedgeinfoT* {.importc: "Agedgeinfo_t", header: "graphviz/types.h", bycopy.} = object
    hdr* {.importc: "hdr".}: AgrecT
    spl* {.importc: "spl".}: ptr splines
    tailPort* {.importc: "tail_port".}: port
    headPort* {.importc: "head_port".}: port
    label* {.importc: "label".}: ptr textlabelT
    headLabel* {.importc: "head_label".}: ptr textlabelT
    tailLabel* {.importc: "tail_label".}: ptr textlabelT
    xLabel* {.importc: "xlabel".}: ptr textlabelT
    EdgeType* {.importc: "edge_type".}: char
    adjacent* {.importc: "adjacent".}: char ##  true for flat edge with adjacent nodes
    labelOnTop* {.importc: "label_ontop".}: char
    guiState* {.importc: "gui_state".}: cuchar ##  Edge state for GUI ops
    toOrig* {.importc: "to_orig".}: ptr EdgeT ##  for dot's shapes.c
    alg* {.importc: "alg".}: pointer



template ED_alg*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).alg)

template ED_conc_opp_flag*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).conc_opp_flag)

template ED_count*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).count)

template ED_cutvalue*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).cutvalue)

template ED_EdgeType*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).EdgeType)

template ED_adjacent*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).adjacent)

template ED_factor*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).factor)

template ED_guiTtate*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).guiTtate)

template ED_head_label*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).head_label)

template ED_head_port*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).head_port)

template ED_label*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).label)

template ED_xlabel*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).xlabel)

template ED_label_ontop*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).label_ontop)

template ED_minlen*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).minlen)

template ED_path*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).path)

template EDThowboxes*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).showboxes)

template EDTpl*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).spl)

template EDTail_label*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).tail_label)

template EDTail_port*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).tail_port)

template EDTo_orig*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).to_orig)

template EDTo_virt*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).to_virt)

template EDTree_index*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).tree_index)

template ED_xpenalty*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).xpenalty)

template ED_dist*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).dist)

template ED_weight*(e: untyped): untyped =
  ((cast[ptr AgedgeinfoT](AGDATA(e))).weight)

template ag_xget*(x, a: untyped): untyped =
  agXGet(x, a)

template SET_RANKDIR*(g, rd: untyped): untyped =
  (GD_rankdir2(g) = rd)

template agfindedge*(g, t, h: untyped): untyped =
  (agEdge(g, t, h, nil, 0))

template agfindnode*(g, n: untyped): untyped =
  (agNode(g, n, 0))

template agfindgraphattr*(g, a: untyped): untyped =
  (agAttr(g, AGRAPH, a, nil))

template agfindnodeattr*(g, a: untyped): untyped =
  (agAttr(g, AGNODE, a, nil))

template agfindedgeattr*(g, a: untyped): untyped =
  (agAttr(g, AGEDGE, a, nil))

type
  gvlayout_featuresT* {.importc: "gvlayout_features_t", header: "graphviz/types.h", bycopy.} = object
    flags* {.importc: "flags".}: cint

