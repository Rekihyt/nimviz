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

when defined(HAVE_POINTF_S):
  type
    Ppoint_t* = pointf_t
    Pvector_t* = pointf_t
else:
  type
    Pxy_t* {.importc: "Pxy_t", header: "graphviz/pathgeom.h", bycopy.} = object
      x* {.importc: "x".}: cdouble
      y* {.importc: "y".}: cdouble

    Ppoint_t* = Pxy_t
    Pvector_t* = Pxy_t
type
  Ppoly_t* {.importc: "Ppoly_t", header: "graphviz/pathgeom.h", bycopy.} = object
    ps* {.importc: "ps".}: ptr Ppoint_t
    pn* {.importc: "pn".}: cint

  Ppolyline_t* = Ppoly_t
  Pedge_t* {.importc: "Pedge_t", header: "graphviz/pathgeom.h", bycopy.} = object
    a* {.importc: "a".}: Ppoint_t
    b* {.importc: "b".}: Ppoint_t


##  opaque state handle for visibility graph operations

# type
  # vconfig_t* = vconfig_s

proc freePath*(p: ptr Ppolyline_t) {.importc: "freePath", header: "graphviz/pathgeom.h".}