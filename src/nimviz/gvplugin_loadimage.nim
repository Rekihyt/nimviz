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
  types, gvplugin, gvcjob

# when defined(GVDLL):
#   const
#     extern* = __declspec(dllexport)
## visual studio

# when defined(WIN32):
#   when not defined(GVC_EXPORTS):
#     const
#       extern* = __declspec(dllimport)
## end visual studio

proc gvusershape_file_access*(us: ptr usershape_t): boolean {.
    importc: "gvusershape_file_access", header: "graphviz/gvplugin_loadimage.h".}
proc gvusershape_file_release*(us: ptr usershape_t) {.
    importc: "gvusershape_file_release", header: "graphviz/gvplugin_loadimage.h".}
type
  gvloadimage_engine_t* {.importc: "gvloadimage_engine_t",
                         header: "graphviz/gvplugin_loadimage.h", bycopy.} = object
    loadimage* {.importc: "loadimage".}: proc (job: ptr GVJ_t; us: ptr usershape_t;
        b: boxf; filled: boolean)


when defined(extern):