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
  gvrender_engine_t* {.importc: "gvrender_engine_t", header: "graphviz/gvplugin_render.h",
                      bycopy.} = object
    begin_job* {.importc: "begin_job".}: proc (job: ptr GVJ_t)
    end_job* {.importc: "end_job".}: proc (job: ptr GVJ_t)
    begin_graph* {.importc: "begin_graph".}: proc (job: ptr GVJ_t)
    end_graph* {.importc: "end_graph".}: proc (job: ptr GVJ_t)
    begin_layer* {.importc: "begin_layer".}: proc (job: ptr GVJ_t; layername: cstring;
        layerNum: cint; numLayers: cint)
    end_layer* {.importc: "end_layer".}: proc (job: ptr GVJ_t)
    begin_page* {.importc: "begin_page".}: proc (job: ptr GVJ_t)
    end_page* {.importc: "end_page".}: proc (job: ptr GVJ_t)
    begin_cluster* {.importc: "begin_cluster".}: proc (job: ptr GVJ_t)
    end_cluster* {.importc: "end_cluster".}: proc (job: ptr GVJ_t)
    begin_nodes* {.importc: "begin_nodes".}: proc (job: ptr GVJ_t)
    end_nodes* {.importc: "end_nodes".}: proc (job: ptr GVJ_t)
    begin_edges* {.importc: "begin_edges".}: proc (job: ptr GVJ_t)
    end_edges* {.importc: "end_edges".}: proc (job: ptr GVJ_t)
    begin_node* {.importc: "begin_node".}: proc (job: ptr GVJ_t)
    end_node* {.importc: "end_node".}: proc (job: ptr GVJ_t)
    begin_edge* {.importc: "begin_edge".}: proc (job: ptr GVJ_t)
    end_edge* {.importc: "end_edge".}: proc (job: ptr GVJ_t)
    begin_anchor* {.importc: "begin_anchor".}: proc (job: ptr GVJ_t; href: cstring;
        tooltip: cstring; target: cstring; id: cstring)
    end_anchor* {.importc: "end_anchor".}: proc (job: ptr GVJ_t)
    begin_label* {.importc: "begin_label".}: proc (job: ptr GVJ_t; `type`: label_type)
    end_label* {.importc: "end_label".}: proc (job: ptr GVJ_t)
    textspan* {.importc: "textspan".}: proc (job: ptr GVJ_t; p: pointf;
        span: ptr textspan_t)
    resolve_color* {.importc: "resolve_color".}: proc (job: ptr GVJ_t;
        color: ptr gvcolor_t)
    ellipse* {.importc: "ellipse".}: proc (job: ptr GVJ_t; A: ptr pointf; filled: cint)
    polygon* {.importc: "polygon".}: proc (job: ptr GVJ_t; A: ptr pointf; n: cint;
                                       filled: cint)
    beziercurve* {.importc: "beziercurve".}: proc (job: ptr GVJ_t; A: ptr pointf; n: cint;
        arrow_at_ttart: cint; arrow_at_end: cint; a6: cint)
    polyline* {.importc: "polyline".}: proc (job: ptr GVJ_t; A: ptr pointf; n: cint)
    comment* {.importc: "comment".}: proc (job: ptr GVJ_t; comment: cstring)
    library_thape* {.importc: "library_thape".}: proc (job: ptr GVJ_t; name: cstring;
        A: ptr pointf; n: cint; filled: cint)

