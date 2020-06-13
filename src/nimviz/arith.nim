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
##  geometric functions (e.g. on points and boxes) with application to, but
##  no specific dependance on graphs

##  for sincos

when defined(HAVE_VALUES_H):
  when defined(MIN):
    template MIN*(a, b: untyped): untyped =
      (if (a) < (b): (a) else: (b))

  when defined(MAX):
    template MAX*(a, b: untyped): untyped =
      (if (a) > (b): (a) else: (b))

  when defined(ABS):
    template ABS*(a: untyped): untyped =
      (if (a) >= 0: (a) else: -(a))

template AVG*(a, b: untyped): untyped =
  ((a + b) div 2)

template SGN*(a: untyped): untyped =
  (if ((a) < 0): -1 else: 1)

template CMP*(a, b: untyped): untyped =
  (if ((a) < (b)): -1 else: (if ((a) > (b)): 1 else: 0))

when defined(BETWEEN):
  template BETWEEN*(a, b, c: untyped): untyped =
    (((a) <= (b)) and ((b) <= (c)))

template ROUND*(f: untyped): untyped =
  (if (f >= 0): (int)(f + 0.5) else: (int)(f - 0.5))

template RADIANS*(deg: untyped): untyped =
  ((deg) div 180.0 * M_PI)

template DEGREES*(rad: untyped): untyped =
  ((rad) div M_PI * 180.0)

template SQR*(a: untyped): untyped =
  ((a) * (a))

##  #ifdef HAVE_SINCOS
##      extern void sincos(double x, double *s, double *c);
##  #else
##  # define sincos(x,s,c) *s = sin(x); *c = cos(x)
##  #endif
