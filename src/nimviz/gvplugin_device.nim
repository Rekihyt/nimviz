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

type
  gvdevice_engine_t* {.importc: "gvdevice_engine_t", header: "graphviz/gvplugin_device.h",
                      bycopy.} = object
    initialize* {.importc: "initialize".}: proc (firstjob: ptr GVJ_t)
    format* {.importc: "format".}: proc (firstjob: ptr GVJ_t)
    finalize* {.importc: "finalize".}: proc (firstjob: ptr GVJ_t)

