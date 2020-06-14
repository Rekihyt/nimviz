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

import types, gvplugin

const gvcDll* =
  when defined(windows):
      "gvc.dll"
  elif defined(macosx):
      "libgvc.dylib"
  else:
      "libgvc.so(|.6)"

# when defined(GVDLL):
#   const
#     extern* = __declspec(dllexport)
# else:
#   const
#     extern* = true
## visual studio

# when defined(WIN32):
#   when not defined(GVC_EXPORTS):
#     const
#       extern* = __declspec(dllimport)
## end visual studio
 

import gvcext
# type
#   LtSymlistT* = {.importc: "lt_tymlist_t", header: "graphviz/gvcext.h", bycopy.} = object
  #   LtSymlistT* = {.importc: "lt_tymlist_t", header: "graphviz/gvcext.h", bycopy.} = object
  #   name* {.importc: "name".}: cstring
  #   address* {.importc: "address".}: pointer

template layoutDone*(g: untyped): untyped =
  agbindrec(g, "Agraphinfo_t", 0, TRUE) and GD_drawing(g)

##  misc
##  FIXME - this needs eliminating or renaming

proc gvToggle*(a1: cint) {.importc: "gvToggle", dynlib: gvcDll.}
##  set up a graphviz context

proc gvNewContext*(builtins: ptr LtSymlistT; demand_loading: cint): ptr GVCT {.
    importc: "gvNEWcontext", dynlib: gvcDll.}
##   set up a graphviz context - and init graph - retaining old API

proc gvContext*(): ptr GVCT {.importc: "gvContext", dynlib: gvcDll.}
##   set up a graphviz context - and init graph - with builtins

proc gvContextPlugins*(builtins: ptr LtSymlistT; demand_loading: cint): ptr GVCT {.
    importc: "gvContextPlugins", dynlib: gvcDll.}
##  get information associated with a graphviz context

proc gvcInfo*(a1: ptr GVCT): cstringArray {.importc: "gvcInfo", dynlib: gvcDll.}
proc gvcVersion*(a1: ptr GVCT): cstring {.importc: "gvcVersion", dynlib: gvcDll.}
proc gvcBuildDate*(a1: ptr GVCT): cstring {.importc: "gvcBuildDate", dynlib: gvcDll.}
##  parse command line args - minimally argv[0] sets layout engine

proc gvParseArgs*(gvc: ptr GVCT; argc: cint; argv: cstringArray): cint {.
    importc: "gvParseArgs", dynlib: gvcDll.}
proc gvNextInputGraph*(gvc: ptr GVCT): ptr GraphT {.importc: "gvNextInputGraph",
    dynlib: gvcDll.}
proc gvPluginsGraph*(gvc: ptr GVCT): ptr GraphT {.importc: "gvPluginsGraph",
    dynlib: gvcDll.}
##  Compute a layout using a specified engine

proc gvLayout*(gvc: ptr GVCT; g: ptr GraphT; engine: cstring): cint {.
    importc: "gvLayout", dynlib: gvcDll.}
##  Compute a layout using layout engine from command line args

proc gvLayoutJobs*(gvc: ptr GVCT; g: ptr GraphT): cint {.importc: "gvLayoutJobs",
    dynlib: gvcDll.}
##  Render layout into string attributes of the graph

proc attachAttrs*(g: ptr GraphT) {.importc: "attach_attrs", dynlib: gvcDll.}
##  Render layout in a specified format to an open FILE

proc gvRender*(gvc: ptr GVCT; g: ptr GraphT; format: cstring; `out`: ptr File): cint {.
    importc: "gvRender", dynlib: gvcDll.}
##  Render layout in a specified format to a file with the given name

proc gvRenderFilename*(gvc: ptr GVCT; g: ptr GraphT; format: cstring; filename: cstring): cint {.
    importc: "gvRenderFilename", dynlib: gvcDll.}
##  Render layout in a specified format to an external context

proc gvRenderContext*(gvc: ptr GVCT; g: ptr GraphT; format: cstring; context: pointer): cint {.
    importc: "gvRenderContext", dynlib: gvcDll.}
##  Render layout in a specified format to a malloc'ed string

proc gvRenderData*(gvc: ptr GVCT; g: ptr GraphT; format: cstring; result: cstringArray;
                  length: ptr cuint): cint {.importc: "gvRenderData", dynlib: gvcDll.}
##  Free memory allocated and pointed to by *result in gvRenderData

proc gvFreeRenderData*(data: cstring) {.importc: "gvFreeRenderData", dynlib: gvcDll.}
##  Render layout according to -T and -o options found by gvParseArgs

proc gvRenderJobs*(gvc: ptr GVCT; g: ptr GraphT): cint {.importc: "gvRenderJobs",
    dynlib: gvcDll.}
##  Clean up layout data structures - layouts are not nestable (yet)

proc gvFreeLayout*(gvc: ptr GVCT; g: ptr GraphT): cint {.importc: "gvFreeLayout",
    dynlib: gvcDll.}
##  Clean up graphviz context

proc gvFinalize*(gvc: ptr GVCT) {.importc: "gvFinalize", dynlib: gvcDll.}
proc gvFreeContext*(gvc: ptr GVCT): cint {.importc: "gvFreeContext", dynlib: gvcDll.}
##  Return list of plugins of type kind.
##  kind would normally be "render" "layout" "textlayout" "device" "loadimage"
##  The size of the list is stored in sz.
##  The caller is responsible for freeing the storage. This involves
##  freeing each item, then the list.
##  Returns NULL on error, or if there are no plugins.
##  In the former case, sz is unchanged; in the latter, sz = 0.
##
##  At present, the str argument is unused, but may be used to modify
##  the search as in gvplugin_list above.
##

# proc gvPluginList*(gvc: ptr GVCT; kind: cstring; sz: ptr cint; a4: cstring): cstringArray {.
    # importc: "gvPluginList", dynlib: gvcDll.}
## * Add a library from your user application
##  @param gvc Graphviz context to add library to
##  @param lib library to add
##

# proc gvAddLibrary*(gvc: ptr GVCT; lib: ptr gvplugin_library_t) {.
    # importc: "gvAddLibrary", dynlib: gvcDll.}
## * Perform a Transitive Reduction on a graph
##  @param g  graph to be transformed.
##

# proc gvToolTred*(g: ptr GraphT): cint {.importc: "gvToolTred", header: "graphviz/gvc.h".}