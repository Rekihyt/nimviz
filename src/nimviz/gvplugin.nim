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
##  Header used by plugins

import
  gvcext

##
##  Terminology:
##
##     package         - e.g. libgvplugin_cairo.so
##        api	      - e.g. render
##           type      - e.g. "png", "ps"
##

type
  gvplugin_installed_t* {.importc: "gvplugin_installed_t", header: "graphviz/gvplugin.h",
                         bycopy.} = object
    id* {.importc: "id".}: cint ##  an id that is only unique within a package
                            ## 			of plugins of the same api.
                            ## 			A renderer-type such as "png" in the cairo package
                            ## 			has an id that is different from the "ps" type
                            ## 			in the same package
    `type`* {.importc: "type".}: cstring ##  a string name, such as "png" or "ps" that
                                     ## 			distinguishes different types withing the same
                                     ## 			 (renderer in this case)
    quality* {.importc: "quality".}: cint ##  an arbitrary integer used for ordering plugins of
                                      ## 			the same type from different packages
    engine* {.importc: "engine".}: pointer ##  pointer to the jump table for the plugin
    features* {.importc: "features".}: pointer ##  pointer to the feature description
                                           ## 				void* because type varies by api

  gvplugin_api_t* {.importc: "gvplugin_api_t", header: "graphviz/gvplugin.h", bycopy.} = object
    api* {.importc: "api".}: api_t
    types* {.importc: "types".}: ptr gvplugin_installed_t

  gvplugin_library_t* {.importc: "gvplugin_library_t", header: "graphviz/gvplugin.h", bycopy.} = object
    packagename* {.importc: "packagename".}: cstring ##  used when this plugin is builtin and has
                                                 ## 					no pathname
    apis* {.importc: "apis".}: ptr gvplugin_api_t

