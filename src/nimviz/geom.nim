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
##  geometric types and macros (e.g. points and boxes) with application to, but
##  no specific dependance on graphs

import
  arith

type
  point* {.importc: "point", header: "graphviz/geom.h", bycopy.} = object
    x* {.importc: "x".}: cint
    y* {.importc: "y".}: cint

  pointf* {.importc: "pointf", header: "graphviz/geom.h", bycopy.} = object
    x* {.importc: "x".}: cdouble
    y* {.importc: "y".}: cdouble


##  tell pathplan/pathgeom.h

const
  HAVE_POINTF_S* = true

type
  box* {.importc: "box", header: "graphviz/geom.h", bycopy.} = object
    LL* {.importc: "LL".}: point
    UR* {.importc: "UR".}: point

  boxf* {.importc: "boxf", header: "graphviz/geom.h", bycopy.} = object
    LL* {.importc: "LL".}: pointf
    UR* {.importc: "UR".}: pointf


##  true if point p is inside box b

template INSIDE*(p, b: untyped): untyped =
  (BETWEEN((b).LL.x, (p).x, (b).UR.x) and BETWEEN((b).LL.y, (p).y, (b).UR.y))

##  true if boxes b0 and b1 overlap

template OVERLAP*(b0, b1: untyped): untyped =
  (((b0).UR.x >= (b1).LL.x) and ((b1).UR.x >= (b0).LL.x) and
      ((b0).UR.y >= (b1).LL.y) and ((b1).UR.y >= (b0).LL.y))

##  true if box b0 completely contains b1

template CONTAINS*(b0, b1: untyped): untyped =
  (((b0).UR.x >= (b1).UR.x) and ((b0).UR.y >= (b1).UR.y) and
      ((b0).LL.x <= (b1).LL.x) and ((b0).LL.y <= (b1).LL.y))

##  expand box b as needed to enclose point p

template EXPANDBP*(b, p: untyped): untyped =
  (b).LL.x = MIN((b).LL.x, (p).x)
  (b).LL.y = MIN((b).LL.y, (p).y)
  (b).UR.x = MAX((b).UR.x, (p).x)
  (b).UR.y = MAX((b).UR.y, (p).y)
  # b.LL.x = MIN(b.LL.x, p.x)
  # b.LL.y = MIN(b.LL.y, p.y)
  # b.UR.x = MAX(b.UR.x, p.x)
  # b.UR.y = MAX(b.UR.y, p.y)

##  expand box b0 as needed to enclose box b1

template EXPANDBB*(b0, b1: untyped): untyped =
  (b0).LL.x = MIN((b0).LL.x, (b1).LL.x)
  (b0).LL.y = MIN((b0).LL.y, (b1).LL.y)
  (b0).UR.x = MAX((b0).UR.x, (b1).UR.x)
  (b0).UR.y = MAX((b0).UR.y, (b1).UR.y)
##  clip box b0 to fit box b1

template CLIPBB*(b0, b1: untyped): untyped =
  (b0).LL.x = MAX((b0).LL.x, (b1).LL.x)
  (b0).LL.y = MAX((b0).LL.y, (b1).LL.y)
  (b0).UR.x = MIN((b0).UR.x, (b1).UR.x)
  (b0).UR.y = MIN((b0).UR.y, (b1).UR.y)

template LEN2*(a, b: untyped): untyped =
  (SQR(a) + SQR(b))

template LEN*(a, b: untyped): untyped =
  (sqrt(LEN2((a), (b))))

template DIST2*(p, q: untyped): untyped =
  (LEN2(((p).x - (q).x), ((p).y - (q).y)))

template DIST*(p, q: untyped): untyped =
  (sqrt(DIST2((p), (q))))

const
  POINTS_PER_INCH* = 72
  POINTS_PER_PC*: cdouble = (POINTS_PER_INCH div 6)
  POINTS_PER_CM*: cdouble = (POINTS_PER_INCH * 0.393700787)
  POINTS_PER_MM*: cdouble = (POINTS_PER_INCH * 0.0393700787)

template POINTS*(a_inches: untyped): untyped =
  (ROUND((a_inches) * POINTS_PER_INCH))

template INCH2PS*(a_inches: untyped): untyped =
  ((a_inches) * cast[cdouble](POINTS_PER_INCH))

template PS2INCH*(a_points: untyped): untyped =
  ((a_points) div cast[cdouble](POINTS_PER_INCH))

template P2PF*(p, pf: untyped): untyped =
  (pf).x = (p).x
  (pf).y = (p).y

template PF2P*(pf, p: untyped): untyped =
  (p).x = ROUND((pf).x)
  (p).y = ROUND((pf).y)

template B2BF*(b, bf: untyped): untyped =
  P2PF((b).LL, (bf).LL)
  P2PF((b).UR, (bf).UR)

template BF2B*(bf, b: untyped): untyped =
  PF2P((bf).LL, (b).LL)
  PF2P((bf).UR, (b).UR)

template APPROXEQ*(a, b, tol: untyped): untyped =
  (ABS((a) - (b)) < (tol))

template APPROXEQPT*(p, q, tol: untyped): untyped =
  (DIST2((p), (q)) < SQR(tol))

##  some common tolerance values

const
  MILLIPOINT* = 0.001
  MICROPOINT* = 1e-06
