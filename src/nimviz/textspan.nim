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

##  Bold, Italic, Underline, Sup, Sub, Strike
##  Stored in textfont_t.flags, which is 7 bits, so full
##  Probably should be moved to textspan_t

import geom

const
  HTML_BF* = (1 shl 0)
  HTML_IF* = (1 shl 1)
  HTML_UL* = (1 shl 2)
  HTML_SUP* = (1 shl 3)
  HTML_SUB* = (1 shl 4)
  HTML_S* = (1 shl 5)
  HTML_OL* = (1 shl 6)

type
  PostscriptAlias* {.importc: "PostscriptAlias", header: "graphviz/textspan.h", bycopy.} = object
    name* {.importc: "name".}: cstring
    family* {.importc: "family".}: cstring
    weight* {.importc: "weight".}: cstring
    stretch* {.importc: "stretch".}: cstring
    style* {.importc: "style".}: cstring
    xfig_code* {.importc: "xfig_code".}: cint
    svg_font_family* {.importc: "svg_font_family".}: cstring
    svg_font_weight* {.importc: "svg_font_weight".}: cstring
    svg_font_ttyle* {.importc: "svg_font_ttyle".}: cstring


##  font information
##  If name or color is NULL, or size < 0, that attribute
##  is unspecified.
##

type
  TextFontT* {.importc: "textfont_t", header: "graphviz/textspan.h", bycopy.} = object
    name* {.importc: "name".}: cstring
    color* {.importc: "color".}: cstring
    postscriptAlias* {.importc: "postscript_alias".}: ptr PostscriptAlias
    size* {.importc: "size".}: cdouble
    flags* {.importc: "flags", bitsize: 7.}: cuint ##  HTML_UL, HTML_IF, HTML_BF, etc.
    cnt* {.importc: "cnt", bitsize: (sizeof(cuint) * 8 - 7).}: cuint ##  reference count


##  atomic unit of text emitted using a single htmlfont_t

type
  TextSpanT* {.importc: "textspan_t", header: "graphviz/textspan.h", bycopy.} = object
    str* {.importc: "str".}: cstring ##  stored in utf-8
    font* {.importc: "font".}: ptr TextFontT
    layout* {.importc: "layout".}: pointer
    freeLayout* {.importc: "free_layout".}: proc (layout: pointer) ##  FIXME - this is ugly
    yOffSetLayout* {.importc: "yoffset_layout".}: cdouble
    yOffSetCenterLine* {.importc: "yoffset_centerline".}: cdouble
    size* {.importc: "size".}: pointf
    just* {.importc: "just".}: char ##  'l' 'n' 'r'
                                ##  FIXME

