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

##  #include "arith.h"

type
  hsvrgbacolor_t* {.importc: "hsvrgbacolor_t", header: "graphviz/color.h", bycopy.} = object
    name* {.importc: "name".}: cstring
    h* {.importc: "h".}: cuchar
    s* {.importc: "s".}: cuchar
    v* {.importc: "v".}: cuchar
    r* {.importc: "r".}: cuchar
    g* {.importc: "g".}: cuchar
    b* {.importc: "b".}: cuchar
    a* {.importc: "a".}: cuchar


##  possible representations of color in gvcolor_t

type
  color_type_t* {.size: sizeof(cint).} = enum
    HSVA_DOUBLE, RGBA_BYTE, RGBA_WORD, CMYK_BYTE, RGBA_DOUBLE, COLOR_STRING,
    COLOR_INDEX


##  gvcolor_t can hold a color spec in a choice or representations

type
  INNER_C_UNION_color_36* {.importc: "no_name", header: "graphviz/color.h", bycopy.} = object {.
      union.}
    RGBA* {.importc: "RGBA".}: array[4, cdouble]
    HSVA* {.importc: "HSVA".}: array[4, cdouble]
    rgba* {.importc: "rgba".}: array[4, cuchar]
    cmyk* {.importc: "cmyk".}: array[4, cuchar]
    rrggbbaa* {.importc: "rrggbbaa".}: array[4, cint]
    string* {.importc: "string".}: cstring
    index* {.importc: "index".}: cint

  gvcolor_t* {.importc: "gvcolor_t", header: "graphviz/color.h", bycopy.} = object
    u* {.importc: "u".}: INNER_C_UNION_color_36
    `type`* {.importc: "type".}: color_type_t


const
  COLOR_MALLOC_FAIL* = -1
  COLOR_UNKNOWN* = 1
  COLOR_OK* = 0
