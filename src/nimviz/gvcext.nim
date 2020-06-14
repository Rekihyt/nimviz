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
##  Common header used by both clients and plugins

##
##  Define an apis array of name strings using an enumerated api_t as index.
##  The enumerated type is defined here.  The apis array is
##  inititialized in gvplugin.c by redefining ELEM and reinvoking APIS.
##
##
##  Define api_t using names based on the plugin names with API_ prefixed.
##

# 
# template ELEM(x) = type `API_ x`
# type APIS =  ELEM(render) ELEM(layout) ELEM(textlayout) ELEM(device) ELEM(loadimage)
type api_t* {.importc, header: "graphviz/gvcext.h", bycopy.}= enum
  render, layout, textlayout, device, loadimage
  # render

##  typedef enum { APIS /*_DUMMY_ELEM_=0*/ } api_t; /* API_render, API_layout, ... */
##  Stupid but true: The sole purpose of "_DUMMY_ELEM_=0"
##  is to avoid a "," after the last element of the enum
##  because some compilers when using "-pedantic"
##  generate an error for about the dangling ","
##  but only if this header is used from a .cpp file!
##  Setting it to 0 makes sure that the enumeration
##  does not define an extra value.  (It does however
##  define _DUMMY_ELEM_ as an enumeration symbol,
##  but its value duplicates that of the first
##  symbol in the enumeration - in this case "render".)
##
##  One could wonder why trailing "," in:
##  	int nums[]={1,2,3,};
##  is OK, but in:
##  	typedef enum {a,b,c,} abc_t;
##  is not!!!
##
##  #undef ELEM

# import gvcjob
type
  GVJT* {.importc: "GVJ_t", header: "graphviz/gvcext.h", bycopy.} = object
  GVGT* {.importc: "GVG_t", header: "graphviz/gvcext.h", bycopy.} = object
  GVCT* {.importc: "GVC_t", header: "graphviz/gvcext.h", bycopy.} = object
  gvplugin_available_t* {.importc: "gvplugin_available_t", header: "graphviz/gvcext.h", bycopy.} = object

type
  LtSymlistT* {.importc: "lt_symlist_t", header: "graphviz/gvcext.h", bycopy.} = object
    name* {.importc: "name".}: cstring
    address* {.importc: "address".}: pointer


## visual studio
##  #ifdef WIN32
##  #ifndef GVC_EXPORTS
##  __declspec(dllimport) lt_tymlist_t lt_preloaded_tymbols[];
##  #else
## __declspec(dllexport) lt_tymlist_t lt_preloaded_tymbols[];

# when not defined(LTDL_H):
#   var lt_preloaded_tymbols* {.importc: "lt_preloaded_tymbols", header: "graphviz/gvcext.h".}: UncheckedArray[
#       lt_tymlist_t]
##  #endif
## end visual studio
##  #ifndef WIN32
##  #if defined(GVDLL)
##  	__declspec(dllexport) lt_tymlist_t lt_preloaded_tymbols[];
##  #else

# when not defined(LTDL_H):
#   var lt_preloaded_tymbols* {.importc: "lt_preloaded_tymbols", header: "graphviz/gvcext.h".}: UncheckedArray[
#       lt_tymlist_t]
##  #endif
##  #endif

##  #endif
