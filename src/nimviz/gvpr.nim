##  $Id$Revision:
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
  cgraph

when defined(_MSC_VER):
  type
    ssize_t* = cint
##  Bits for flags variable in gvprstate_t.
##  Included here so that calling programs can use the first
##  two in gvpropts.flags
##
##  If set, gvpr calls exit() on errors

const
  GV_USE_EXIT* = 1

##  If set, gvpr stores output graphs in gvpropts

const
  GV_USE_OUTGRAPH* = 2

##  Use longjmp to return to top-level call in gvpr

const
  GV_USE_JUMP* = 4

##  $tvnext has been set but not used

const
  GV_NEXT_SET* = 8

type
  gvprwr* = proc (a1: pointer; buf: cstring; nbyte: csize_t; a4: pointer): ssize_t
  gvpruserfn* = proc (a1: cstring): cint
  gvprbinding* {.importc: "gvprbinding", header: "graphviz/gvpr.h", bycopy.} = object
    name* {.importc: "name".}: cstring
    fn* {.importc: "fn".}: gvpruserfn

  gvpropts* {.importc: "gvpropts", header: "graphviz/gvpr.h", bycopy.} = object
    ingraphs* {.importc: "ingraphs".}: ptr ptr Agraph_t ##  NULL-terminated array of input graphs
    n_outgraphs* {.importc: "n_outgraphs".}: cint ##  if GV_USE_OUTGRAPH set, output graphs
    outgraphs* {.importc: "outgraphs".}: ptr ptr Agraph_t
    `out`* {.importc: "out".}: gvprwr ##  write function for stdout
    err* {.importc: "err".}: gvprwr ##  write function for stderr
    flags* {.importc: "flags".}: cint
    bindings* {.importc: "bindings".}: ptr gvprbinding ##  array of bindings, terminated with {NULL,NULL}


proc gvpr*(argc: cint; argv: ptr cstring; opts: ptr gvpropts): cint {.importc: "gvpr",
    header: "graphviz/gvpr.h".}