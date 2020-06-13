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

import
  types

##  Type indicating granularity and method
##   l_undef    - unspecified
##   l_node     - polyomino using nodes and edges
##   l_clust    - polyomino using nodes and edges and top-level clusters
##                (assumes ND_clust(n) unused by application)
##   l_graph    - polyomino using computer graph bounding box
##   l_array    - array based on graph bounding boxes
##   l_aspect   - tiling based on graph bounding boxes preserving aspect ratio
##   l_hull     - polyomino using convex hull (unimplemented)
##   l_tile     - tiling using graph bounding box (unimplemented)
##   l_bisect   - alternate bisection using graph bounding box (unimplemented)
##

type
  pack_mode* {.size: sizeof(cint).} = enum
    l_undef, l_clust, l_node, l_graph, l_array, l_aspect


const
  PK_COL_MAJOR* = (1 shl 0)
  PK_USER_VALS* = (1 shl 1)
  PK_LEFT_ALIGN* = (1 shl 2)
  PK_RIGHT_ALIGN* = (1 shl 3)
  PK_TOP_ALIGN* = (1 shl 4)
  PK_BOT_ALIGN* = (1 shl 5)
  PK_INPUT_ORDER* = (1 shl 6)

type
  packval_t* = cuint
  pack_info* {.importc: "pack_info", header: "graphviz/pack.h", bycopy.} = object
    aspect* {.importc: "aspect".}: cfloat ##  desired aspect ratio
    sz* {.importc: "sz".}: cint  ##  row/column size size
    margin* {.importc: "margin".}: cuint ##  margin left around objects, in points
    doSplines* {.importc: "doSplines".}: cint ##  use splines in constructing graph shape
    mode* {.importc: "mode".}: pack_mode ##  granularity and method
    fixed* {.importc: "fixed".}: ptr boolean ##  fixed[i] == true implies g[i] should not be moved
    vals* {.importc: "vals".}: ptr packval_t ##  for arrays, sort numbers
    flags* {.importc: "flags".}: cint


## visual studio

when defined(WIN32):
  when not defined(GVC_EXPORTS):
    const
      extern* = __declspec(dllimport)
## end visual studio

proc putRects*(ng: cint; bbs: ptr boxf; pinfo: ptr pack_info): ptr point {.
    importc: "putRects", header: "graphviz/pack.h".}
proc packRects*(ng: cint; bbs: ptr boxf; pinfo: ptr pack_info): cint {.
    importc: "packRects", header: "graphviz/pack.h".}
proc putGraphs*(a1: cint; a2: ptr ptr Agraph_t; a3: ptr Agraph_t; a4: ptr pack_info): ptr point {.
    importc: "putGraphs", header: "graphviz/pack.h".}
proc packGraphs*(a1: cint; a2: ptr ptr Agraph_t; a3: ptr Agraph_t; a4: ptr pack_info): cint {.
    importc: "packGraphs", header: "graphviz/pack.h".}
proc packSubgraphs*(a1: cint; a2: ptr ptr Agraph_t; a3: ptr Agraph_t; a4: ptr pack_info): cint {.
    importc: "packSubgraphs", header: "graphviz/pack.h".}
proc pack_graph*(ng: cint; gs: ptr ptr Agraph_t; root: ptr Agraph_t; fixed: ptr boolean): cint {.
    importc: "pack_graph", header: "graphviz/pack.h".}
proc shiftGraphs*(a1: cint; a2: ptr ptr Agraph_t; a3: ptr point; a4: ptr Agraph_t; a5: cint): cint {.
    importc: "shiftGraphs", header: "graphviz/pack.h".}
proc getPackMode*(g: ptr Agraph_t; dflt: pack_mode): pack_mode {.
    importc: "getPackMode", header: "graphviz/pack.h".}
proc getPack*(a1: ptr Agraph_t; not_def: cint; dflt: cint): cint {.importc: "getPack",
    header: "graphviz/pack.h".}
proc getPackInfo*(g: ptr Agraph_t; dflt: pack_mode; dfltMargin: cint; a4: ptr pack_info): pack_mode {.
    importc: "getPackInfo", header: "graphviz/pack.h".}
proc getPackModeInfo*(g: ptr Agraph_t; dflt: pack_mode; a3: ptr pack_info): pack_mode {.
    importc: "getPackModeInfo", header: "graphviz/pack.h".}
proc parsePackModeInfo*(p: cstring; dflt: pack_mode; pinfo: ptr pack_info): pack_mode {.
    importc: "parsePackModeInfo", header: "graphviz/pack.h".}
proc isConnected*(a1: ptr Agraph_t): cint {.importc: "isConnected", header: "graphviz/pack.h".}
proc ccomps*(a1: ptr Agraph_t; a2: ptr cint; a3: cstring): ptr ptr Agraph_t {.
    importc: "ccomps", header: "graphviz/pack.h".}
proc cccomps*(a1: ptr Agraph_t; a2: ptr cint; a3: cstring): ptr ptr Agraph_t {.
    importc: "cccomps", header: "graphviz/pack.h".}
proc pccomps*(a1: ptr Agraph_t; a2: ptr cint; a3: cstring; a4: ptr boolean): ptr ptr Agraph_t {.
    importc: "pccomps", header: "graphviz/pack.h".}
proc nodeInduce*(a1: ptr Agraph_t): cint {.importc: "nodeInduce", header: "graphviz/pack.h".}
proc mapClust*(a1: ptr Agraph_t): ptr Agraph_t {.importc: "mapClust", header: "graphviz/pack.h".}