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
import gvcext

type
  GVCOMMONT* {.importc: "GVCOMMON_t", header: "graphviz/gvcommon.h", bycopy.} = object
    info* {.importc: "info".}: cstringArray
    cmdName* {.importc: "cmdname".}: cstring
    verbose* {.importc: "verbose".}: cint
    config* {.importc: "config".}: bool
    autoOutfileNames* {.importc: "auto_outfile_names".}: bool
    errorFn* {.importc: "errorfn".}: proc (fmt: cstring) {.varargs.}
    showBoxes* {.importc: "show_boxes".}: cstringArray ##  emit code for correct box coordinates
    lib* {.importc: "lib".}: cstringArray ##  rendering state
    viewNum* {.importc: "viewNum".}: cint ##  current view - 1 based count of views,
                                      ## 			    all pages in all layers
    builtIns* {.importc: "builtins".}: ptr LtSymlistT
    demandLoading* {.importc: "demand_loading".}: cint

