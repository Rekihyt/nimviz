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
  pathgeom

when defined(_BLD_pathplan) and defined(__EXPORT__):
  const
    extern* = __EXPORT__
##  find shortest euclidean path within a simple polygon

proc Pshortestpath*(boundary: ptr Ppoly_t; endpoints: array[2, Ppoint_t];
                   output_route: ptr Ppolyline_t): cint {.importc: "Pshortestpath",
    header: "graphviz/pathplan.h".}
##  fit a spline to an input polyline, without touching barrier segments

proc Proutespline*(barriers: ptr Pedge_t; n_barriers: cint; input_route: Ppolyline_t;
                  endpoint_tlopes: array[2, Pvector_t];
                  output_route: ptr Ppolyline_t): cint {.importc: "Proutespline",
    header: "graphviz/pathplan.h".}
##  utility function to convert from a set of polygonal obstacles to barriers

proc Ppolybarriers*(polys: ptr ptr Ppoly_t; npolys: cint; barriers: ptr ptr Pedge_t;
                   n_barriers: ptr cint): cint {.importc: "Ppolybarriers",
    header: "graphviz/pathplan.h".}
##  function to convert a polyline into a spline representation

proc make_polyline*(line: Ppolyline_t; sline: ptr Ppolyline_t) {.
    importc: "make_polyline", header: "graphviz/pathplan.h".}