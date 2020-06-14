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
const cgraphDll* =
  when defined(windows):
    "graphviz.dll"
  elif defined(macosx):
    "libgraphviz.dylib"
  else:
    "libcgraph.so(|.6)"

import cdt


when not defined(NOT):
  template NOT*(x: untyped): untyped =
    (not (x))

when not defined(NIL):
  template NIL*(`type`: untyped): untyped =
    (cast[`type`](0))

##  #define NILgraph		NIL(Agraph_t*)
##  #define NILnode			NIL(Agnode_t*)
##  #define NILedge			NIL(Agedge_t*)
##  #define NILsym			NIL(Agsym_t*)

type
  IdType* = cuint


##  Header of a user record.  These records are attached by client programs
## dynamically at runtime.  A unique string ID must be given to each record
## attached to the same object.  Cgraph has functions to create, search for,
## and delete these records.   The records are maintained in a circular list,
## with obj->data pointing somewhere in the list.  The search function has
## an option to lock this pointer on a given record.  The application must
## be written so only one such lock is outstanding at a time.

type
  Agrec_t* {.importc: "Agrec_t", header: "graphviz/cgraph.h", bycopy.} = object
    name* {.importc: "name".}: cstring
    next* {.importc: "next".}: ptr Agrec_t ##  following this would be any programmer-defined data


##  Object tag for graphs, nodes, and edges.  While there may be several structs
## for a given node or edges, there is only one unique ID (per main graph).
##  const int sizeofseq1 = sizeof(unsigned) * 8 - 4;

type
  Agtag_t* {.importc: "Agtag_t", header: "graphviz/cgraph.h", bycopy.} = object
    objtype* {.importc: "objtype", bitsize: 2.}: cuint ##  see literal tags below
    mtflock* {.importc: "mtflock", bitsize: 1.}: cuint ##  move-to-front lock, see above
    attrwf* {.importc: "attrwf", bitsize: 1.}: cuint ##  attrs written (parity, write.c)
    seq* {.importc: "seq", bitsize: (sizeof(cuint) * 8 - 4).}: cuint ##  sequence no.
    id* {.importc: "id".}: IdType ##  client  ID


##  object tags

const
  AGRAPH* = 0
  AGNODE* = 1
  AGOUTEDGE* = 2
  AGINEDGE* = 3
  AGEDGE* = AGOUTEDGE

##  a generic graph/node/edge header

type
  Agobj_t* {.importc: "Agobj_t", header: "graphviz/cgraph.h", bycopy.} = object
    tag* {.importc: "tag".}: Agtag_t
    data* {.importc: "data".}: ptr Agrec_t


template AGTAG*(obj: untyped): untyped =
  ((cast[ptr Agobj_t]((obj))).tag)

template AGTYPE*(obj: untyped): untyped =
  (AGTAG(obj).objtype)

template AGID*(obj: untyped): untyped =
  (AGTAG(obj).id)

template AGSEQ*(obj: untyped): untyped =
  (AGTAG(obj).seq)

template AGATTRWF*(obj: untyped): untyped =
  (AGTAG(obj).attrwf)

template AGDATA*(obj: untyped): untyped =
  ((cast[ptr Agobj_t]((obj))).data)

##  This is the node struct allocated per graph (or subgraph).  It resides
## in the n_dict of the graph.  The node set is maintained by libdict, but
## transparently to libgraph callers.  Every node may be given an optional
## string name at its time of creation, or it is permissible to pass NIL(char*)
## for the name.

type
  Agsubnode_t* {.importc: "Agsubnode_t", header: "graphviz/cgraph.h", bycopy.} = object
    seq_link* {.importc: "seq_link".}: Dtlink_t ##  the node-per-graph-or-subgraph record
    ##  must be first
    id_link* {.importc: "id_link".}: Dtlink_t
    node* {.importc: "node".}: ptr Agnode_t ##  the object
    in_id* {.importc: "in_id".}: ptr Dtlink_t
    out_id* {.importc: "out_id".}: ptr Dtlink_t ##  by node/ID for random access
    in_seq* {.importc: "in_seq".}: ptr Dtlink_t
    out_seq* {.importc: "out_seq".}: ptr Dtlink_t ##  by node/sequence for serial access

  Agnode_t* {.importc: "Agnode_t", header: "graphviz/cgraph.h", bycopy.} = object
    base* {.importc: "base".}: Agobj_t
    root* {.importc: "root".}: ptr Agraph_t
    mainsub* {.importc: "mainsub".}: Agsubnode_t ##  embedded for main graph

  Agedge_t* {.importc: "Agedge_t", header: "graphviz/cgraph.h", bycopy.} = object
    base* {.importc: "base".}: Agobj_t
    id_link* {.importc: "id_link".}: Dtlink_t ##  main graph only
    seq_link* {.importc: "seq_link".}: Dtlink_t
    node* {.importc: "node".}: ptr Agnode_t ##  the endpoint node

  Agedgepair_t* {.importc: "Agedgepair_t", header: "graphviz/cgraph.h", bycopy.} = object
    `out`* {.importc: "out".}: Agedge_t
    `in`* {.importc: "in".}: Agedge_t

  Agdesc_t* {.importc: "Agdesc_t", header: "graphviz/cgraph.h", bycopy.} = object
    directed* {.importc: "directed", bitsize: 1.}: cuint ##  graph descriptor
    ##  if edges are asymmetric
    strict* {.importc: "strict", bitsize: 1.}: cuint ##  if multi-edges forbidden
    no_loop* {.importc: "no_loop", bitsize: 1.}: cuint ##  if no loops
    maingraph* {.importc: "maingraph", bitsize: 1.}: cuint ##  if this is the top level graph
    flatlock* {.importc: "flatlock", bitsize: 1.}: cuint ##  if sets are flattened into lists in cdt
    no_write* {.importc: "no_write", bitsize: 1.}: cuint ##  if a temporary subgraph
    has_attrs* {.importc: "has_attrs", bitsize: 1.}: cuint ##  if string attr tables should be initialized
    has_cmpnd* {.importc: "has_cmpnd", bitsize: 1.}: cuint ##  if may contain collapsed nodes

  #  disciplines for external resources needed by libgraph

  Agmemdisc_t* {.importc: "Agmemdisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    open* {.importc: "open".}: proc (a1: ptr Agdisc_t): pointer ##  memory allocator
    ##  independent of other resources
    alloc* {.importc: "alloc".}: proc (state: pointer; req: csize_t): pointer
    resize* {.importc: "resize".}: proc (state: pointer; `ptr`: pointer; old: csize_t;
                                     req: csize_t): pointer
    free* {.importc: "free".}: proc (state: pointer; `ptr`: pointer)
    close* {.importc: "close".}: proc (state: pointer)

  Agiddisc_t* {.importc: "Agiddisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    open* {.importc: "open".}: proc (g: ptr Agraph_t; a2: ptr Agdisc_t): pointer ##  object ID allocator
    ##  associated with a graph
    map* {.importc: "map".}: proc (state: pointer; objtype: cint; str: cstring;
                               id: ptr IdType; createflag: cint): clong
    alloc* {.importc: "alloc".}: proc (state: pointer; objtype: cint; id: IdType): clong
    free* {.importc: "free".}: proc (state: pointer; objtype: cint; id: IdType)
    print* {.importc: "print".}: proc (state: pointer; objtype: cint; id: IdType): cstring
    close* {.importc: "close".}: proc (state: pointer)
    idregister* {.importc: "idregister".}: proc (state: pointer; objtype: cint;
        obj: pointer)

  Agiodisc_t* {.importc: "Agiodisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    afread* {.importc: "afread".}: proc (chan: pointer; buf: cstring; bufsize: cint): cint
    putstr* {.importc: "putstr".}: proc (chan: pointer; str: cstring): cint
    flush* {.importc: "flush".}: proc (chan: pointer): cint ##  sync
                                                     ##  error messages?

  Agdisc_t* {.importc: "Agdisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    mem* {.importc: "mem".}: ptr Agmemdisc_t ##  user's discipline
    id* {.importc: "id".}: ptr Agiddisc_t
    io* {.importc: "io".}: ptr Agiodisc_t


#  default resource disciplines
# visual studio

# when defined(_MSC_VER) and not defined(CGRAPH_EXPORTS):
  # const
    # extern* = __declspec(dllimport)
# end visual studio


  Agattr_t* {.importc: "Agattr_t", header: "graphviz/cgraph.h", bycopy.} = object
    h* {.importc: "h".}: Agrec_t ##  dynamic string attributes
    ##  common data header
    dict* {.importc: "dict".}: ptr Dict_t ##  shared dict to interpret attr field
    str* {.importc: "str".}: cstringArray ##  the attribute string values

  Agsym_t* {.importc: "Agsym_t", header: "graphviz/cgraph.h", bycopy.} = object
    link* {.importc: "link".}: Dtlink_t ##  symbol in one of the above dictionaries
    name* {.importc: "name".}: cstring ##  attribute's name
    defval* {.importc: "defval".}: cstring ##  its default value for initialization
    id* {.importc: "id".}: cint  ##  its index in attr[]
    kind* {.importc: "kind".}: cuchar ##  referent object type
    fixed* {.importc: "fixed".}: cuchar ##  immutable value
    print* {.importc: "print".}: cuchar ##  always print

  INNER_C_tTRUCT_cgraph_335* {.importc: "no_name", header: "graphviz/cgraph.h", bycopy.} = object
    n* {.importc: "n".}: ptr Dict_t
    e* {.importc: "e".}: ptr Dict_t
    g* {.importc: "g".}: ptr Dict_t

  Agdatadict_t* {.importc: "Agdatadict_t", header: "graphviz/cgraph.h", bycopy.} = object
    h* {.importc: "h".}: Agrec_t ##  set of dictionaries per graph
    ##  installed in list of graph recs
    dict* {.importc: "dict".}: INNER_C_tTRUCT_cgraph_335

  Agdstate_t* {.importc: "Agdstate_t", header: "graphviz/cgraph.h", bycopy.} = object
    mem* {.importc: "mem".}: pointer
    id* {.importc: "id".}: pointer ##  IO must be initialized and finalized outside Cgraph,
                               ##  and channels (FILES) are passed as void* arguments.

  Agobjfn_t* = proc (g: ptr Agraph_t; obj: ptr Agobj_t; arg: pointer)
  Agobjupdfn_t* = proc (g: ptr Agraph_t; obj: ptr Agobj_t; arg: pointer; sym: ptr Agsym_t)
  INNER_C_tTRUCT_cgraph_214* {.importc: "no_name", header: "graphviz/cgraph.h", bycopy.} = object
    ins* {.importc: "ins".}: Agobjfn_t
    `mod`* {.importc: "mod".}: Agobjupdfn_t
    del* {.importc: "del".}: Agobjfn_t

  Agcbdisc_t* {.importc: "Agcbdisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    graph* {.importc: "graph".}: INNER_C_tTRUCT_cgraph_214
    node* {.importc: "node".}: INNER_C_tTRUCT_cgraph_214
    edge* {.importc: "edge".}: INNER_C_tTRUCT_cgraph_214

  Agcbstack_t* {.importc: "Agcbstack_t", header: "graphviz/cgraph.h", bycopy.} = object
    f* {.importc: "f".}: ptr Agcbdisc_t ##  object event callbacks
    ##  methods
    state* {.importc: "state".}: pointer ##  closure
    prev* {.importc: "prev".}: ptr Agcbstack_t ##  kept in a stack, unlike other disciplines

  Agclos_t* {.importc: "Agclos_t", header: "graphviz/cgraph.h", bycopy.} = object
    disc* {.importc: "disc".}: Agdisc_t ##  resource discipline functions
    state* {.importc: "state".}: Agdstate_t ##  resource closures
    strdict* {.importc: "strdict".}: ptr Dict_t ##  shared string dict
    seq* {.importc: "seq".}: array[3, uint64] ##  local object sequence number counter
    cb* {.importc: "cb".}: ptr Agcbstack_t ##  user and system callback function stacks
    callbacks_enabled* {.importc: "callbacks_enabled".}: cuchar ##  issue user callbacks or hold them?
    lookup_by_name* {.importc: "lookup_by_name".}: array[3, ptr Dict_t]
    lookup_by_id* {.importc: "lookup_by_id".}: array[3, ptr Dict_t]

  Agraph_t* {.importc: "Agraph_t", header: "graphviz/cgraph.h", bycopy.} = object
    base* {.importc: "base".}: Agobj_t
    desc* {.importc: "desc".}: Agdesc_t
    link* {.importc: "link".}: Dtlink_t
    n_seq* {.importc: "n_seq".}: ptr Dict_t ##  the node set in sequence
    n_id* {.importc: "n_id".}: ptr Dict_t ##  the node set indexed by ID
    e_seq* {.importc: "e_seq".}: ptr Dict_t
    e_id* {.importc: "e_id".}: ptr Dict_t ##  holders for edge sets
    g_dict* {.importc: "g_dict".}: ptr Dict_t ##  subgraphs - descendants
    parent* {.importc: "parent".}: ptr Agraph_t
    root* {.importc: "root".}: ptr Agraph_t ##  subgraphs - ancestors
    clos* {.importc: "clos".}: ptr Agclos_t ##  shared resources


var agMemDisc* {.importc: "AgMemDisc", header: "graphviz/cgraph.h".}: Agmemdisc_t
var agIdDisc* {.importc: "AgIdDisc", header: "graphviz/cgraph.h".}: Agiddisc_t
var agIoDisc* {.importc: "AgIoDisc", header: "graphviz/cgraph.h".}: Agiodisc_t
var agDefaultDisc* {.importc: "AgDefaultDisc", header: "graphviz/cgraph.h".}: Agdisc_t

# {.push dynlib: cgraphDll.}

proc agPushDisc*(g: ptr Agraph_t; disc: ptr Agcbdisc_t; state: pointer) {.
    importc: "agpushdisc", dynlib: cgraphDll.}
proc agPopDisc*(g: ptr Agraph_t; disc: ptr Agcbdisc_t): cint {.importc: "agpopdisc",
    dynlib: cgraphDll.}
proc agCallBacks*(g: ptr Agraph_t; flag: cint): cint {.importc: "agcallbacks",
    dynlib: cgraphDll.}
##  return prev value
##  graphs

proc agOpen*(name: cstring; desc: Agdesc_t; disc: ptr Agdisc_t): ptr Agraph_t {.
    importc: "agopen", dynlib: cgraphDll.}
proc agClose*(g: ptr Agraph_t): cint {.importc: "agclose", dynlib: cgraphDll.}
proc agRead*(chan: pointer; disc: ptr Agdisc_t): ptr Agraph_t {.importc: "agread",
    dynlib: cgraphDll.}
proc agMemRead*(cp: cstring): ptr Agraph_t {.importc: "agmemread", dynlib: cgraphDll.}
proc agReadLine*(a1: cint) {.importc: "agreadline", dynlib: cgraphDll.}
proc agSetFile*(a1: cstring) {.importc: "agsetfile", dynlib: cgraphDll.}
proc agConcat*(g: ptr Agraph_t; chan: pointer; disc: ptr Agdisc_t): ptr Agraph_t {.
    importc: "agconcat", dynlib: cgraphDll.}
proc agWrite*(g: ptr Agraph_t; chan: pointer): cint {.importc: "agwrite",
    dynlib: cgraphDll.}
proc agIsDirected*(g: ptr Agraph_t): cint {.importc: "agisdirected", dynlib: cgraphDll.}
proc agIsUndirected*(g: ptr Agraph_t): cint {.importc: "agisundirected",
    dynlib: cgraphDll.}
proc agIsStrict*(g: ptr Agraph_t): cint {.importc: "agisstrict", dynlib: cgraphDll.}
proc agIsSimple*(g: ptr Agraph_t): cint {.importc: "agissimple", dynlib: cgraphDll.}
##  nodes

proc agNode*(g: ptr Agraph_t; name: cstring; createflag: cint): ptr Agnode_t {.
    importc: "agnode", dynlib: cgraphDll.}
proc agIdNode*(g: ptr Agraph_t; id: IdType; createflag: cint): ptr Agnode_t {.
    importc: "agidnode", dynlib: cgraphDll.}
proc agSubNode*(g: ptr Agraph_t; n: ptr Agnode_t; createflag: cint): ptr Agnode_t {.
    importc: "agsubnode", dynlib: cgraphDll.}
proc agFstNode*(g: ptr Agraph_t): ptr Agnode_t {.importc: "agfstnode",
    dynlib: cgraphDll.}
proc agNxtNode*(g: ptr Agraph_t; n: ptr Agnode_t): ptr Agnode_t {.importc: "agnxtnode",
    dynlib: cgraphDll.}
proc agLstNode*(g: ptr Agraph_t): ptr Agnode_t {.importc: "aglstnode",
    dynlib: cgraphDll.}
proc agPvNode*(g: ptr Agraph_t; n: ptr Agnode_t): ptr Agnode_t {.importc: "agprvnode",
    dynlib: cgraphDll.}
proc agSubRep*(g: ptr Agraph_t; n: ptr Agnode_t): ptr Agsubnode_t {.importc: "agsubrep",
    dynlib: cgraphDll.}
proc agNodeBefore*(u: ptr Agnode_t; v: ptr Agnode_t): cint {.importc: "agnodebefore",
    dynlib: cgraphDll.}
##  we have no shame
##  and neither do we
##  edges

proc agEdge*(g: ptr Agraph_t; t: ptr Agnode_t; h: ptr Agnode_t; name: cstring;
            createflag: cint): ptr Agedge_t {.importc: "agedge", dynlib: cgraphDll.}
proc agIdEdge*(g: ptr Agraph_t; t: ptr Agnode_t; h: ptr Agnode_t; id: IdType;
              createflag: cint): ptr Agedge_t {.importc: "agidedge",
    dynlib: cgraphDll.}
proc agSubEdge*(g: ptr Agraph_t; e: ptr Agedge_t; createflag: cint): ptr Agedge_t {.
    importc: "agsubedge", dynlib: cgraphDll.}
proc agFstIn*(g: ptr Agraph_t; n: ptr Agnode_t): ptr Agedge_t {.importc: "agfstin",
    dynlib: cgraphDll.}
proc agNxtIn*(g: ptr Agraph_t; e: ptr Agedge_t): ptr Agedge_t {.importc: "agnxtin",
    dynlib: cgraphDll.}
proc agFstOut*(g: ptr Agraph_t; n: ptr Agnode_t): ptr Agedge_t {.importc: "agfstout",
    dynlib: cgraphDll.}
proc agNxtOut*(g: ptr Agraph_t; e: ptr Agedge_t): ptr Agedge_t {.importc: "agnxtout",
    dynlib: cgraphDll.}
proc agFstEdge*(g: ptr Agraph_t; n: ptr Agnode_t): ptr Agedge_t {.importc: "agfstedge",
    dynlib: cgraphDll.}
proc agNxtEdge*(g: ptr Agraph_t; e: ptr Agedge_t; n: ptr Agnode_t): ptr Agedge_t {.
    importc: "agnxtedge", dynlib: cgraphDll.}
##  generic

proc agraphOf*(obj: pointer): ptr Agraph_t {.importc: "agraphof", dynlib: cgraphDll.}
proc agRoot*(obj: pointer): ptr Agraph_t {.importc: "agroot", dynlib: cgraphDll.}
proc agContains*(a1: ptr Agraph_t; a2: pointer): cint {.importc: "agcontains",
    dynlib: cgraphDll.}
proc agNameOf*(a1: pointer): cstring {.importc: "agnameof", dynlib: cgraphDll.}
proc agRelabel*(obj: pointer; name: cstring): cint {.importc: "agrelabel",
    dynlib: cgraphDll.}
##  scary

proc agRelabel_node*(n: ptr Agnode_t; newname: cstring): cint {.
    importc: "agrelabel_node", dynlib: cgraphDll.}
proc agDelete*(g: ptr Agraph_t; obj: pointer): cint {.importc: "agdelete",
    dynlib: cgraphDll.}
proc agDelSubG*(g: ptr Agraph_t; sub: ptr Agraph_t): clong {.importc: "agdelsubg",
    dynlib: cgraphDll.}
##  could be agclose

proc agDelNode*(g: ptr Agraph_t; arg_n: ptr Agnode_t): cint {.importc: "agdelnode",
    dynlib: cgraphDll.}
proc agDelEdge*(g: ptr Agraph_t; arg_e: ptr Agedge_t): cint {.importc: "agdeledge",
    dynlib: cgraphDll.}
proc agObjKind*(a1: pointer): cint {.importc: "agobjkind", dynlib: cgraphDll.}
##  strings

proc agstrdup*(a1: ptr Agraph_t; a2: cstring): cstring {.importc: "agstrdup",
    dynlib: cgraphDll.}
proc agstrdup_html*(a1: ptr Agraph_t; a2: cstring): cstring {.importc: "agstrdup_html",
    dynlib: cgraphDll.}
proc aghtmlstr*(a1: cstring): cint {.importc: "aghtmlstr", dynlib: cgraphDll.}
proc agstrbind*(g: ptr Agraph_t; a2: cstring): cstring {.importc: "agstrbind",
    dynlib: cgraphDll.}
proc agstrfree*(a1: ptr Agraph_t; a2: cstring): cint {.importc: "agstrfree",
    dynlib: cgraphDll.}
proc agcanon*(a1: cstring; a2: cint): cstring {.importc: "agcanon", dynlib: cgraphDll.}
proc agstrcanon*(a1: cstring; a2: cstring): cstring {.importc: "agstrcanon",
    dynlib: cgraphDll.}
proc agcanonStr*(str: cstring): cstring {.importc: "agcanonStr", dynlib: cgraphDll.}
##  manages its own buf
##  definitions for dynamic string attributes


proc agattr*(g: ptr Agraph_t; kind: cint; name: cstring; value: cstring): ptr Agsym_t {.
    importc: "agattr", dynlib: cgraphDll.}
proc agattrsym*(obj: pointer; name: cstring): ptr Agsym_t {.importc: "agattrsym",
    dynlib: cgraphDll.}
proc agnxtattr*(g: ptr Agraph_t; kind: cint; attr: ptr Agsym_t): ptr Agsym_t {.
    importc: "agnxtattr", dynlib: cgraphDll.}
proc agcopyattr*(oldobj: pointer; newobj: pointer): cint {.importc: "agcopyattr",
    dynlib: cgraphDll.}
proc agbindrec*(obj: pointer; name: cstring; size: cuint; move_to_front: cint): pointer {.
    importc: "agbindrec", dynlib: cgraphDll.}
proc aggetrec*(obj: pointer; name: cstring; move_to_front: cint): ptr Agrec_t {.
    importc: "aggetrec", dynlib: cgraphDll.}
proc agdelrec*(obj: pointer; name: cstring): cint {.importc: "agdelrec",
    dynlib: cgraphDll.}
proc aginit*(g: ptr Agraph_t; kind: cint; rec_name: cstring; rec_tize: cint;
            move_to_front: cint) {.importc: "aginit", dynlib: cgraphDll.}
proc agclean*(g: ptr Agraph_t; kind: cint; rec_name: cstring) {.importc: "agclean",
    dynlib: cgraphDll.}
proc agget*(obj: pointer; name: cstring): cstring {.importc: "agget", dynlib: cgraphDll.}
proc agxget*(obj: pointer; sym: ptr Agsym_t): cstring {.importc: "agxget",
    dynlib: cgraphDll.}
proc agSet*(obj: pointer; name: cstring; value: cstring): cint {.importc: "agset",
    dynlib: cgraphDll.}
proc agxset*(obj: pointer; sym: ptr Agsym_t; value: cstring): cint {.importc: "agxset",
    dynlib: cgraphDll.}
proc agSafeSet*(obj: pointer; name: cstring; value: cstring; def: cstring): cint {.
    importc: "agsafeset", dynlib: cgraphDll.}
##  defintions for subgraphs

proc agsubg*(g: ptr Agraph_t; name: cstring; cflag: cint): ptr Agraph_t {.
    importc: "agsubg", dynlib: cgraphDll.}
##  constructor

proc agidsubg*(g: ptr Agraph_t; id: IdType; cflag: cint): ptr Agraph_t {.
    importc: "agidsubg", dynlib: cgraphDll.}
##  constructor

proc agfstsubg*(g: ptr Agraph_t): ptr Agraph_t {.importc: "agfstsubg",
    dynlib: cgraphDll.}
proc agnxtsubg*(subg: ptr Agraph_t): ptr Agraph_t {.importc: "agnxtsubg",
    dynlib: cgraphDll.}
proc agparent*(g: ptr Agraph_t): ptr Agraph_t {.importc: "agparent", dynlib: cgraphDll.}
##  set cardinality

proc agnnodes*(g: ptr Agraph_t): cint {.importc: "agnnodes", dynlib: cgraphDll.}
proc agnedges*(g: ptr Agraph_t): cint {.importc: "agnedges", dynlib: cgraphDll.}
proc agnsubg*(g: ptr Agraph_t): cint {.importc: "agnsubg", dynlib: cgraphDll.}
proc agdegree*(g: ptr Agraph_t; n: ptr Agnode_t; `in`: cint; `out`: cint): cint {.
    importc: "agdegree", dynlib: cgraphDll.}
proc agcountuniqedges*(g: ptr Agraph_t; n: ptr Agnode_t; `in`: cint; `out`: cint): cint {.
    importc: "agcountuniqedges", dynlib: cgraphDll.}
##  memory

proc agalloc*(g: ptr Agraph_t; size: csize_t): pointer {.importc: "agalloc",
    dynlib: cgraphDll.}
proc agrealloc*(g: ptr Agraph_t; `ptr`: pointer; oldsize: csize_t; size: csize_t): pointer {.
    importc: "agrealloc", dynlib: cgraphDll.}
proc agfree*(g: ptr Agraph_t; `ptr`: pointer) {.importc: "agfree", dynlib: cgraphDll.}

# {.pop.}

type VmMallocT* = object
# extern struct _vmalloc_s *agheap(Agraph_t * g);
##  an engineering compromise is a joy forever
proc agheap*(g: ptr Agraph_t): ptr VmMallocT {.importc: "agheap", dynlib: cgraphDll.}


proc aginternalmapclearlocalnames*(g: ptr Agraph_t) {.
    importc: "aginternalmapclearlocalnames", dynlib: cgraphDll.}
template agnew*(g, t: untyped): untyped =
  (cast[ptr t](agalloc(g, sizeof((t)))))

template agnnew*(g, n, t: untyped): untyped =
  (cast[ptr t](agalloc(g, (n) * sizeof((t)))))

##  error handling

type
  Agerrlevel_t* {.size: sizeof(cint).} = enum
    AGWARN, AGERR, AGMAX, AGPREV
  Agusererrf* = proc (a1: cstring): cint


proc agseterr*(a1: Agerrlevel_t): Agerrlevel_t {.importc: "agseterr",
    dynlib: cgraphDll.}
proc aglasterr*(): cstring {.importc: "aglasterr", dynlib: cgraphDll.}
proc agerr*(level: Agerrlevel_t; fmt: cstring): cint {.varargs, importc: "agerr",
    dynlib: cgraphDll.}
proc agerrorf*(fmt: cstring) {.varargs, importc: "agerrorf", dynlib: cgraphDll.}
proc agwarningf*(fmt: cstring) {.varargs, importc: "agwarningf", dynlib: cgraphDll.}
proc agerrors*(): cint {.importc: "agerrors", dynlib: cgraphDll.}
proc agreseterrors*(): cint {.importc: "agreseterrors", dynlib: cgraphDll.}
proc agseterrf*(a1: Agusererrf): Agusererrf {.importc: "agseterrf", dynlib: cgraphDll.}
##  data access macros
##  this assumes that e[0] is out and e[1] is inedge, see edgepair in edge.c

template AGIN2OUT*(e: untyped): untyped =
  ((e) - 1)

template AGOUT2IN*(e: untyped): untyped =
  ((e) + 1)

template AGOPP*(e: untyped): untyped =
  (if (AGTYPE(e) == AGINEDGE): AGIN2OUT(e) else: AGOUT2IN(e))

template AGMKOUT*(e: untyped): untyped =
  (if AGTYPE(e) == AGOUTEDGE: (e) else: AGIN2OUT(e))

template AGMKIN*(e: untyped): untyped =
  (if AGTYPE(e) == AGINEDGE: (e) else: AGOUT2IN(e))

template AGTAIL*(e: untyped): untyped =
  (AGMKIN(e).node)

template AGHEAD*(e: untyped): untyped =
  (AGMKOUT(e).node)

template agtail*(e: untyped): untyped =
  AGTAIL(e)

template aghead*(e: untyped): untyped =
  AGHEAD(e)

template agopp*(e: untyped): untyped =
  AGOPP(e)

template ageqedge*(e, f: untyped): untyped =
  (AGMKOUT(e) == AGMKOUT(f))

const
  TAILPORT_ID* = "tailport"
  HEADPORT_ID* = "headport"

# when defined(_MSC_VER) and not defined(CGRAPH_EXPORTS):
 # const
 #   extern* = __declspec(dllimport)

var
  agDirected* {.importc: "Agdirected", dynlib: cgraphDll.}: Agdesc_t
  agStrictDirected* {.importc: "Agstrictdirected", dynlib: cgraphDll.}: Agdesc_t
  agUndirected* {.importc: "Agundirected", dynlib: cgraphDll.}: Agdesc_t
  agStrictUndirected* {.importc: "Agstrictundirected", dynlib: cgraphDll.}: Agdesc_t

##  fast graphs

proc agflatten*(g: ptr Agraph_t; flag: cint) {.importc: "agflatten", dynlib: cgraphDll.}
type
  Agnoderef_t* = Agsubnode_t
  Agedgeref_t* = Dtlink_t

template AGHEADPOINTER*(g: untyped): untyped =
  cast[ptr Agnoderef_t]((g.n_seq.data.hh.head))

template AGRIGHTPOINTER*(rep: untyped): untyped =
  cast[ptr Agnoderef_t]((if (rep).seq_link.right: (
      cast[pointer](((rep).seq_link.right)) - offsetof(Agsubnode_t, seq_link)) else: 0))

template AGLEFTPOINTER*(rep: untyped): untyped =
  cast[ptr Agnoderef_t](
    if (rep).seq_link.hl.left:
      cast[pointer]((rep).seq_link.hl.left - offsetof(Agsubnode_t, seq_link))
    else: 0
  )

template FIRSTNREF*(g: untyped): untyped =
  agflatten(g, 1)
  AGHEADPOINTER(g)

template NEXTNREF*(g, rep: untyped): untyped =
  if AGRIGHTPOINTER(rep) == AGHEADPOINTER(g): 0
  else: AGRIGHTPOINTER(rep)

template PREVNREF*(g, rep: untyped): untyped =
  if (rep) == AGHEADPOINTER(g): 0
  else: AGLEFTPOINTER(rep)

template LASTNREF*(g: untyped): untyped =
  agflatten(g, 1)
  if AGHEADPOINTER(g): AGLEFTPOINTER(AGHEADPOINTER(g))
  else: 0

template NODEOF*(rep: untyped): untyped =
  ((rep).node)

template FIRSTOUTREF*(g, sn: untyped): untyped =
  agflatten(g, 1)
  (sn).out_seq

template LASTOUTREF*(g, sn: untyped): untyped =
  agflatten(g, 1)
  cast[ptr Agedgeref_t](dtlast(sn.out_seq))

template FIRSTINREF*(g, sn: untyped): untyped =
  agflatten(g, 1)
  (sn).in_seq

template NEXTEREF*(g, rep: untyped): untyped =
  (rep).right

template PREVEREF*(g, rep: untyped): untyped =
  (rep).hl.left

##  this is expedient but a bit slimey because it "knows" that dict entries of both nodes
## and edges are embedded in main graph objects but allocated separately in subgraphs

template AGSNMAIN*(sn: untyped): untyped =
  (sn) == (addr(((sn).node.mainsub)))

template EDGEOF*(sn, rep: untyped): untyped =
  if AGSNMAIN(sn):
    cast[ptr Agedge_t]((cast[ptr cuchar]((rep)) - offsetof(Agedge_t, seq_link)))
  else: cast[ptr Dthold_t](rep.obj)
