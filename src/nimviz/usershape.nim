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
  cdt

type
  imagetype_t* {.size: sizeof(cint).} = enum
    FT_NULL, FT_BMP, FT_GIF, FT_PNG, FT_JPEG, FT_PDF, FT_PS, FT_EPS, FT_SVG, FT_XML,
    FT_RIFF, FT_WEBP, FT_ICO, FT_TIFF
  imagescale_t* {.size: sizeof(cint).} = enum
    IMAGESCALE_FALSE,         ##  no image scaling
    IMAGESCALE_TRUE,          ##  scale image to fit but keep aspect ratio
    IMAGESCALE_WIDTH,         ##  scale image width to fit, keep height fixed
    IMAGESCALE_HEIGHT,        ##  scale image height to fit, keep width fixed
    IMAGESCALE_BOTH           ##  scale image to fit without regard for aspect ratio
  # usershape_t* = usershape_t



type
  usershape_t* {.importc: "usershape_t", header: "graphviz/usershape.h", bycopy.} = object
    link* {.importc: "link".}: Dtlink_t
    name* {.importc: "name".}: cstring
    macro_id* {.importc: "macro_id".}: cint
    must_inline* {.importc: "must_inline".}: bool
    nocache* {.importc: "nocache".}: bool
    f* {.importc: "f".}: ptr FILE
    `type`* {.importc: "type".}: imagetype_t
    stringtype* {.importc: "stringtype".}: cstring
    x* {.importc: "x".}: cint
    y* {.importc: "y".}: cint
    w* {.importc: "w".}: cint
    h* {.importc: "h".}: cint
    dpi* {.importc: "dpi".}: cint
    data* {.importc: "data".}: pointer ##  data loaded by a renderer
    datasize* {.importc: "datasize".}: csize_t ##  size of data (if mmap'ed)
    datafree* {.importc: "datafree".}: proc (us: ptr usershape_t) ##  renderer's function for freeing data

