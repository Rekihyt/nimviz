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

##  #define NILgraph		NIL(AGraphT*)
##  #define NILnode			NIL(AgNodeT*)
##  #define NILedge			NIL(AgEdgeT*)
##  #define NILsym			NIL(AgSymT*)

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
  AgrecT* {.importc: "Agrec_t", header: "graphviz/cgraph.h", bycopy.} = object
    name* {.importc: "name".}: cstring
    next* {.importc: "next".}: ptr AgrecT ##  following this would be any programmer-defined data


##  Object tag for graphs, nodes, and edges.  While there may be several structs
## for a given node or edges, there is only one unique ID (per main graph).
##  const int sizeofseq1 = sizeof(unsigned) * 8 - 4;

type
  AgtagT* {.importc: "Agtag_t", header: "graphviz/cgraph.h", bycopy.} = object
    objType* {.importc: "objtype", bitsize: 2.}: cuint ##  see literal tags below
    mtFlock* {.importc: "mtflock", bitsize: 1.}: cuint ##  move-to-front lock, see above
    attrWF* {.importc: "attrwf", bitsize: 1.}: cuint ##  attrs written (parity, write.c)
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
  AgobjT* {.importc: "Agobj_t", header: "graphviz/cgraph.h", bycopy.} = object
    tag* {.importc: "tag".}: AgtagT
    data* {.importc: "data".}: ptr AgrecT


template AGTAG*(obj: untyped): untyped =
  ((cast[ptr AgobjT]((obj))).tag)

template AGTYPE*(obj: untyped): untyped =
  (AGTAG(obj).objType)

template AGID*(obj: untyped): untyped =
  (AGTAG(obj).id)

template AGSEQ*(obj: untyped): untyped =
  (AGTAG(obj).seq)

template AGATTRWF*(obj: untyped): untyped =
  (AGTAG(obj).attrWF)

template AGDATA*(obj: untyped): untyped =
  ((cast[ptr AgobjT]((obj))).data)

##  This is the node struct allocated per graph (or subgraph).  It resides
## in the n_dict of the graph.  The node set is maintained by libdict, but
## transparently to libgraph callers.  Every node may be given an optional
## string name at its time of creation, or it is permissible to pass NIL(char*)
## for the name.

type
  AgSubNodeT* {.importc: "Agsubnode_t", header: "graphviz/cgraph.h", bycopy.} = object
    seqLink* {.importc: "seq_link".}: DtLinkT ##  the node-per-graph-or-subgraph record
    ##  must be first
    idLink* {.importc: "id_link".}: DtLinkT
    node* {.importc: "node".}: ptr AgNodeT ##  the object
    inId* {.importc: "in_id".}: ptr DtLinkT
    outId* {.importc: "out_id".}: ptr DtLinkT ##  by node/ID for random access
    inSeq* {.importc: "in_seq".}: ptr DtLinkT
    outSeq* {.importc: "out_seq".}: ptr DtLinkT ##  by node/sequence for serial access

  AgNodeT* {.importc: "Agnode_t", header: "graphviz/cgraph.h", bycopy.} = object
    base* {.importc: "base".}: AgobjT
    root* {.importc: "root".}: ptr AGraphT
    mainSub* {.importc: "mainsub".}: AgSubNodeT ##  embedded for main graph

  AgEdgeT* {.importc: "Agedge_t", header: "graphviz/cgraph.h", bycopy.} = object
    base* {.importc: "base".}: AgobjT
    idLink* {.importc: "id_link".}: DtLinkT ##  main graph only
    seqLink* {.importc: "seq_link".}: DtLinkT
    node* {.importc: "node".}: ptr AgNodeT ##  the endpoint node

  AgEdgePairT* {.importc: "Agedgepair_t", header: "graphviz/cgraph.h", bycopy.} = object
    `out`* {.importc: "out".}: AgEdgeT
    `in`* {.importc: "in".}: AgEdgeT

  AgDescT* {.importc: "Agdesc_t", header: "graphviz/cgraph.h", bycopy.} = object
    directed* {.importc: "directed", bitsize: 1.}: cuint ##  graph descriptor
    ##  if edges are asymmetric
    strict* {.importc: "strict", bitsize: 1.}: cuint ##  if multi-edges forbidden
    noLoop* {.importc: "no_loop", bitsize: 1.}: cuint ##  if no loops
    mainGraph* {.importc: "maingraph", bitsize: 1.}: cuint ##  if this is the top level graph
    flatLock* {.importc: "flatlock", bitsize: 1.}: cuint ##  if sets are flattened into lists in cdt
    noWrite* {.importc: "no_write", bitsize: 1.}: cuint ##  if a temporary subgraph
    hasAttrs* {.importc: "has_attrs", bitsize: 1.}: cuint ##  if string attr tables should be initialized
    hasCmpnd* {.importc: "has_cmpnd", bitsize: 1.}: cuint ##  if may contain collapsed nodes

  #  disciplines for external resources needed by libgraph

  AgMemDiscT* {.importc: "Agmemdisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    open* {.importc: "open".}: proc (a1: ptr AgDiscT): pointer ##  memory allocator
    ##  independent of other resources
    alloc* {.importc: "alloc".}: proc (state: pointer; req: csize_t): pointer
    resize* {.importc: "resize".}: proc (state: pointer; `ptr`: pointer; old: csize_t;
                                     req: csize_t): pointer
    free* {.importc: "free".}: proc (state: pointer; `ptr`: pointer)
    close* {.importc: "close".}: proc (state: pointer)

  AgIdDiscT* {.importc: "Agiddisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    open* {.importc: "open".}: proc (g: ptr AGraphT; a2: ptr AgDiscT): pointer ##  object ID allocator
    ##  associated with a graph
    map* {.importc: "map".}: proc (state: pointer; objtype: cint; str: cstring;
                               id: ptr IdType; createflag = true): clong
    alloc* {.importc: "alloc".}: proc (state: pointer; objtype: cint; id: IdType): clong
    free* {.importc: "free".}: proc (state: pointer; objtype: cint; id: IdType)
    print* {.importc: "print".}: proc (state: pointer; objtype: cint; id: IdType): cstring
    close* {.importc: "close".}: proc (state: pointer)
    idRegister* {.importc: "idregister".}: proc (state: pointer; objtype: cint;
        obj: pointer)

  AgIoDiscT* {.importc: "Agiodisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    afRead* {.importc: "afread".}: proc (chan: pointer; buf: cstring; bufsize: cint): cint
    putStr* {.importc: "putstr".}: proc (chan: pointer; str: cstring): cint
    flush* {.importc: "flush".}: proc (chan: pointer): cint ##  sync
                                                     ##  error messages?

  AgDiscT* {.importc: "Agdisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    mem* {.importc: "mem".}: ptr AgMemDiscT ##  user's discipline
    id* {.importc: "id".}: ptr AgIdDiscT
    io* {.importc: "io".}: ptr AgIoDiscT


#  default resource disciplines
# visual studio

# when defined(_MSC_VER) and not defined(CGRAPH_EXPORTS):
  # const
    # extern* = __declspec(dllimport)
# end visual studio


  AgattrT* {.importc: "Agattr_t", header: "graphviz/cgraph.h", bycopy.} = object
    h* {.importc: "h".}: AgrecT ##  dynamic string attributes
    ##  common data header
    dict* {.importc: "dict".}: ptr DictT ##  shared dict to interpret attr field
    str* {.importc: "str".}: cstringArray ##  the attribute string values

  AgSymT* {.importc: "Agsym_t", header: "graphviz/cgraph.h", bycopy.} = object
    link* {.importc: "link".}: DtLinkT ##  symbol in one of the above dictionaries
    name* {.importc: "name".}: cstring ##  attribute's name
    defVal* {.importc: "defval".}: cstring ##  its default value for initialization
    id* {.importc: "id".}: cint  ##  its index in attr[]
    kind* {.importc: "kind".}: cuchar ##  referent object type
    fixed* {.importc: "fixed".}: cuchar ##  immutable value
    print* {.importc: "print".}: cuchar ##  always print

  INNER_CTTRUCT_cgraph_335* {.importc: "no_name", header: "graphviz/cgraph.h", bycopy.} = object
    n* {.importc: "n".}: ptr DictT
    e* {.importc: "e".}: ptr DictT
    g* {.importc: "g".}: ptr DictT

  AgDataDictT* {.importc: "Agdatadict_t", header: "graphviz/cgraph.h", bycopy.} = object
    h* {.importc: "h".}: AgrecT ##  set of dictionaries per graph
    ##  installed in list of graph recs
    dict* {.importc: "dict".}: INNER_CTTRUCT_cgraph_335

  AgDStateT* {.importc: "Agdstate_t", header: "graphviz/cgraph.h", bycopy.} = object
    mem* {.importc: "mem".}: pointer
    id* {.importc: "id".}: pointer ##  IO must be initialized and finalized outside Cgraph,
                               ##  and channels (FILES) are passed as void* arguments.

  AgObjFnT* = proc (g: ptr AGraphT; obj: ptr AgobjT; arg: pointer)
  AgObjUpdFnT* = proc (g: ptr AGraphT; obj: ptr AgobjT; arg: pointer; sym: ptr AgSymT)
  INNER_CTTRUCT_cgraph_214* {.importc: "no_name", header: "graphviz/cgraph.h", bycopy.} = object
    ins* {.importc: "ins".}: AgObjFnT
    `mod`* {.importc: "mod".}: AgObjUpdFnT
    del* {.importc: "del".}: AgObjFnT

  AgCbDiscT* {.importc: "Agcbdisc_t", header: "graphviz/cgraph.h", bycopy.} = object
    graph* {.importc: "graph".}: INNER_CTTRUCT_cgraph_214
    node* {.importc: "node".}: INNER_CTTRUCT_cgraph_214
    edge* {.importc: "edge".}: INNER_CTTRUCT_cgraph_214

  AgCbStackT* {.importc: "Agcbstack_t", header: "graphviz/cgraph.h", bycopy.} = object
    f* {.importc: "f".}: ptr AgCbDiscT ##  object event callbacks
    ##  methods
    state* {.importc: "state".}: pointer ##  closure
    prev* {.importc: "prev".}: ptr AgCbStackT ##  kept in a stack, unlike other disciplines

  AgClosT* {.importc: "Agclos_t", header: "graphviz/cgraph.h", bycopy.} = object
    disc* {.importc: "disc".}: AgDiscT ##  resource discipline functions
    state* {.importc: "state".}: AgDStateT ##  resource closures
    strDict* {.importc: "strdict".}: ptr DictT ##  shared string dict
    seq* {.importc: "seq".}: array[3, uint64] ##  local object sequence number counter
    cb* {.importc: "cb".}: ptr AgCbStackT ##  user and system callback function stacks
    callbacksEnabled* {.importc: "callbacks_enabled".}: cuchar ##  issue user callbacks or hold them?
    lookupByName* {.importc: "lookup_by_name".}: array[3, ptr DictT]
    lookupById* {.importc: "lookup_by_id".}: array[3, ptr DictT]

  AGraphT* {.importc: "Agraph_t", header: "graphviz/cgraph.h", bycopy.} = object
    base* {.importc: "base".}: AgobjT
    desc* {.importc: "desc".}: AgDescT
    link* {.importc: "link".}: DtLinkT
    nSeq* {.importc: "n_seq".}: ptr DictT ##  the node set in sequence
    nId* {.importc: "n_id".}: ptr DictT ##  the node set indexed by ID
    eSeq* {.importc: "e_seq".}: ptr DictT
    eId* {.importc: "e_id".}: ptr DictT ##  holders for edge sets
    gDict* {.importc: "g_dict".}: ptr DictT ##  subgraphs - descendants
    parent* {.importc: "parent".}: ptr AGraphT
    root* {.importc: "root".}: ptr AGraphT ##  subgraphs - ancestors
    clos* {.importc: "clos".}: ptr AgClosT ##  shared resources


var agMemDisc* {.importc: "AgMemDisc", header: "graphviz/cgraph.h".}: AgMemDiscT
var agIdDisc* {.importc: "AgIdDisc", header: "graphviz/cgraph.h".}: AgIdDiscT
var agIoDisc* {.importc: "AgIoDisc", header: "graphviz/cgraph.h".}: AgIoDiscT
var agDefaultDisc* {.importc: "AgDefaultDisc", header: "graphviz/cgraph.h".}: AgDiscT

# {.push dynlib: cgraphDll.}

proc agPushDisc*(g: ptr AGraphT; disc: ptr AgCbDiscT; state: pointer) {.
    importc: "agpushdisc", dynlib: cgraphDll.}
proc agPopDisc*(g: ptr AGraphT; disc: ptr AgCbDiscT): cint {.importc: "agpopdisc",
    dynlib: cgraphDll.}
proc agCallBacks*(g: ptr AGraphT; flag: cint): cint {.importc: "agcallbacks",
    dynlib: cgraphDll.}
##  return prev value
##  graphs

proc agOpen*(name: cstring; desc: AgDescT; disc: ptr AgDiscT): ptr AGraphT {.
    importc: "agopen", dynlib: cgraphDll.}
proc agClose*(g: ptr AGraphT): cint {.importc: "agclose", dynlib: cgraphDll.}
proc agRead*(chan: pointer; disc: ptr AgDiscT = nil): ptr AGraphT {.importc: "agread",
    dynlib: cgraphDll.}
proc agMemRead*(cp: cstring): ptr AGraphT {.importc: "agmemread", dynlib: cgraphDll.}
proc agReadLine*(a1: cint) {.importc: "agreadline", dynlib: cgraphDll.}
proc agSetFile*(a1: cstring) {.importc: "agsetfile", dynlib: cgraphDll.}
proc agConcat*(g: ptr AGraphT; chan: pointer; disc: ptr AgDiscT): ptr AGraphT {.
    importc: "agconcat", dynlib: cgraphDll.}
proc agWrite*(g: ptr AGraphT; chan: pointer): cint {.importc: "agwrite",
    dynlib: cgraphDll.}
proc agIsDirected*(g: ptr AGraphT): cint {.importc: "agisdirected", dynlib: cgraphDll.}
proc agIsUndirected*(g: ptr AGraphT): cint {.importc: "agisundirected",
    dynlib: cgraphDll.}
proc agIsStrict*(g: ptr AGraphT): cint {.importc: "agisstrict", dynlib: cgraphDll.}
proc agIsSimple*(g: ptr AGraphT): cint {.importc: "agissimple", dynlib: cgraphDll.}
##  nodes

proc agNode*(g: ptr AGraphT; name: cstring; createflag = true): ptr AgNodeT {.
    importc: "agnode", dynlib: cgraphDll.}
proc agIdNode*(g: ptr AGraphT; id: IdType; createflag = true): ptr AgNodeT {.
    importc: "agidnode", dynlib: cgraphDll.}
proc agSubNode*(g: ptr AGraphT; n: ptr AgNodeT; createflag = true): ptr AgNodeT {.
    importc: "agsubnode", dynlib: cgraphDll.}
proc agFstNode*(g: ptr AGraphT): ptr AgNodeT {.importc: "agfstnode",
    dynlib: cgraphDll.}
proc agNxtNode*(g: ptr AGraphT; n: ptr AgNodeT): ptr AgNodeT {.importc: "agnxtnode",
    dynlib: cgraphDll.}
proc agLstNode*(g: ptr AGraphT): ptr AgNodeT {.importc: "aglstnode",
    dynlib: cgraphDll.}
proc agPvNode*(g: ptr AGraphT; n: ptr AgNodeT): ptr AgNodeT {.importc: "agprvnode",
    dynlib: cgraphDll.}
proc agSubRep*(g: ptr AGraphT; n: ptr AgNodeT): ptr AgSubNodeT {.importc: "agsubrep",
    dynlib: cgraphDll.}
proc agNodeBefore*(u: ptr AgNodeT; v: ptr AgNodeT): cint {.importc: "agnodebefore",
    dynlib: cgraphDll.}
##  we have no shame
##  and neither do we
##  edges

proc agEdge*(g: ptr AGraphT; t: ptr AgNodeT; h: ptr AgNodeT; name: cstring;
            createflag = true): ptr AgEdgeT {.importc: "agedge", dynlib: cgraphDll.}
proc agIdEdge*(g: ptr AGraphT; t: ptr AgNodeT; h: ptr AgNodeT; id: IdType;
              createflag = true): ptr AgEdgeT {.importc: "agidedge",
    dynlib: cgraphDll.}
proc agSubEdge*(g: ptr AGraphT; e: ptr AgEdgeT; createflag = true): ptr AgEdgeT {.
    importc: "agsubedge", dynlib: cgraphDll.}
proc agFstIn*(g: ptr AGraphT; n: ptr AgNodeT): ptr AgEdgeT {.importc: "agfstin",
    dynlib: cgraphDll.}
proc agNxtIn*(g: ptr AGraphT; e: ptr AgEdgeT): ptr AgEdgeT {.importc: "agnxtin",
    dynlib: cgraphDll.}
proc agFstOut*(g: ptr AGraphT; n: ptr AgNodeT): ptr AgEdgeT {.importc: "agfstout",
    dynlib: cgraphDll.}
proc agNxtOut*(g: ptr AGraphT; e: ptr AgEdgeT): ptr AgEdgeT {.importc: "agnxtout",
    dynlib: cgraphDll.}
proc agFstEdge*(g: ptr AGraphT; n: ptr AgNodeT): ptr AgEdgeT {.importc: "agfstedge",
    dynlib: cgraphDll.}
proc agNxtEdge*(g: ptr AGraphT; e: ptr AgEdgeT; n: ptr AgNodeT): ptr AgEdgeT {.
    importc: "agnxtedge", dynlib: cgraphDll.}
##  generic

proc aGraphOf*(obj: pointer): ptr AGraphT {.importc: "agraphof", dynlib: cgraphDll.}
proc agRoot*(obj: pointer): ptr AGraphT {.importc: "agroot", dynlib: cgraphDll.}
proc agContains*(a1: ptr AGraphT; a2: pointer): cint {.importc: "agcontains",
    dynlib: cgraphDll.}
proc agNameOf*(a1: pointer): cstring {.importc: "agnameof", dynlib: cgraphDll.}
proc agRelabel*(obj: pointer; name: cstring): cint {.importc: "agrelabel",
    dynlib: cgraphDll.}
##  scary

proc agRelabelNode*(n: ptr AgNodeT; newname: cstring): cint {.
    importc: "agrelabel_node", dynlib: cgraphDll.}
proc agDelete*(g: ptr AGraphT; obj: pointer): cint {.importc: "agdelete",
    dynlib: cgraphDll.}
proc agDelSubG*(g: ptr AGraphT; sub: ptr AGraphT): clong {.importc: "agdelsubg",
    dynlib: cgraphDll.}
##  could be agclose

proc agDelNode*(g: ptr AGraphT; arg_n: ptr AgNodeT): cint {.importc: "agdelnode",
    dynlib: cgraphDll.}
proc agDelEdge*(g: ptr AGraphT; arg_e: ptr AgEdgeT): cint {.importc: "agdeledge",
    dynlib: cgraphDll.}
proc agObjKind*(a1: pointer): cint {.importc: "agobjkind", dynlib: cgraphDll.}
##  strings

proc agStrDup*(a1: ptr AGraphT; a2: cstring): cstring {.importc: "agstrdup",
    dynlib: cgraphDll.}
proc agStrDupHtml*(a1: ptr AGraphT; a2: cstring): cstring {.importc: "agstrdup_html",
    dynlib: cgraphDll.}
proc agHtmlStr*(a1: cstring): cint {.importc: "aghtmlstr", dynlib: cgraphDll.}
proc agStrBind*(g: ptr AGraphT; a2: cstring): cstring {.importc: "agstrbind",
    dynlib: cgraphDll.}
proc agStrFree*(a1: ptr AGraphT; a2: cstring): cint {.importc: "agstrfree",
    dynlib: cgraphDll.}
proc agCanon*(a1: cstring; a2: cint): cstring {.importc: "agcanon", dynlib: cgraphDll.}
proc agStrCanon*(a1: cstring; a2: cstring): cstring {.importc: "agstrcanon",
    dynlib: cgraphDll.}
proc agCanonStr*(str: cstring): cstring {.importc: "agcanonStr", dynlib: cgraphDll.}
##  manages its own buf
##  definitions for dynamic string attributes


proc agAttr*(g: ptr AGraphT; kind: cint; name: cstring; value: cstring): ptr AgSymT {.
    importc: "agattr", dynlib: cgraphDll.}
proc agAttrSym*(obj: pointer; name: cstring): ptr AgSymT {.importc: "agattrsym",
    dynlib: cgraphDll.}
proc agNxtAttr*(g: ptr AGraphT; kind: cint; attr: ptr AgSymT): ptr AgSymT {.
    importc: "agnxtattr", dynlib: cgraphDll.}
proc agCopyAttr*(oldobj: pointer; newobj: pointer): cint {.importc: "agcopyattr",
    dynlib: cgraphDll.}
proc agBindRec*(obj: pointer; name: cstring; size: cuint; moveTo_front: cint): pointer {.
    importc: "agbindrec", dynlib: cgraphDll.}
proc agGetRec*(obj: pointer; name: cstring; moveTo_front: cint): ptr AgrecT {.
    importc: "aggetrec", dynlib: cgraphDll.}
proc agDelRec*(obj: pointer; name: cstring): cint {.importc: "agdelrec",
    dynlib: cgraphDll.}
proc agInit*(g: ptr AGraphT; kind: cint; rec_name: cstring; recTize: cint;
            moveTo_front: cint) {.importc: "aginit", dynlib: cgraphDll.}
proc agClean*(g: ptr AGraphT; kind: cint; rec_name: cstring) {.importc: "agclean",
    dynlib: cgraphDll.}
proc agGet*(obj: pointer; name: cstring): cstring {.importc: "agget", dynlib: cgraphDll.}
proc agXGet*(obj: pointer; sym: ptr AgSymT): cstring {.importc: "agxget",
    dynlib: cgraphDll.}
proc agSet*(obj: pointer; name: cstring; value: cstring): cint {.importc: "agset",
    dynlib: cgraphDll.}
proc agXSet*(obj: pointer; sym: ptr AgSymT; value: cstring): cint {.importc: "agxset",
    dynlib: cgraphDll.}
proc agSafeSet*(obj: pointer; name: cstring; value: cstring; def: cstring = ""): cint {.
    importc: "agsafeset", dynlib: cgraphDll.}
##  defintions for subgraphs

proc agSubG*(g: ptr AGraphT; name: cstring; cflag = true): ptr AGraphT {.
    importc: "agsubg", dynlib: cgraphDll.}
##  constructor

proc agIdSubG*(g: ptr AGraphT; id: IdType; cflag = true): ptr AGraphT {.
    importc: "agidsubg", dynlib: cgraphDll.}
##  constructor

proc agFstSubG*(g: ptr AGraphT): ptr AGraphT {.importc: "agfstsubg",
    dynlib: cgraphDll.}
proc agNxtSubG*(subg: ptr AGraphT): ptr AGraphT {.importc: "agnxtsubg",
    dynlib: cgraphDll.}
proc agParent*(g: ptr AGraphT): ptr AGraphT {.importc: "agparent", dynlib: cgraphDll.}
##  set cardinality

proc agNNodes*(g: ptr AGraphT): cint {.importc: "agnnodes", dynlib: cgraphDll.}
proc agNEdges*(g: ptr AGraphT): cint {.importc: "agnedges", dynlib: cgraphDll.}
proc agNSubG*(g: ptr AGraphT): cint {.importc: "agnsubg", dynlib: cgraphDll.}
proc agDegree*(g: ptr AGraphT; n: ptr AgNodeT; `in`: cint; `out`: cint): cint {.
    importc: "agdegree", dynlib: cgraphDll.}
proc agCountUniqEdges*(g: ptr AGraphT; n: ptr AgNodeT; `in`: cint; `out`: cint): cint {.
    importc: "agcountuniqedges", dynlib: cgraphDll.}
##  memory

proc agAlloc*(g: ptr AGraphT; size: csize_t): pointer {.importc: "agalloc",
    dynlib: cgraphDll.}
proc agRealloc*(g: ptr AGraphT; `ptr`: pointer; oldsize: csize_t; size: csize_t): pointer {.
    importc: "agrealloc", dynlib: cgraphDll.}
proc agFree*(g: ptr AGraphT; `ptr`: pointer) {.importc: "agfree", dynlib: cgraphDll.}

# {.pop.}

type VmMallocT* = object
# extern struct _vmalloc_s *agHeap(AGraphT * g);
##  an engineering compromise is a joy forever
proc agHeap*(g: ptr AGraphT): ptr VmMallocT {.importc: "agheap", dynlib: cgraphDll.}


proc agInternalmapclearlocalnames*(g: ptr AGraphT) {.
    importc: "aginternalmapclearlocalnames", dynlib: cgraphDll.}
template agNew*(g, t: untyped): untyped =
  (cast[ptr t](agAlloc(g, sizeof((t)))))

template agNnew*(g, n, t: untyped): untyped =
  (cast[ptr t](agAlloc(g, (n) * sizeof((t)))))

##  error handling

type
  AgErrLevelT* {.size: sizeof(cint).} = enum
    AGWARN, AGERR, AGMAX, AGPREV
  AgUserErrF* = proc (a1: cstring): cint


proc agSetErr*(a1: AgErrLevelT): AgErrLevelT {.importc: "agseterr",
    dynlib: cgraphDll.}
proc agLastErr*(): cstring {.importc: "aglasterr", dynlib: cgraphDll.}
proc agErr*(level: AgErrLevelT; fmt: cstring): cint {.varargs, importc: "agerr",
    dynlib: cgraphDll.}
proc agErrorF*(fmt: cstring) {.varargs, importc: "agerrorf", dynlib: cgraphDll.}
proc agWarningF*(fmt: cstring) {.varargs, importc: "agwarningf", dynlib: cgraphDll.}
proc agErrors*(): cint {.importc: "agerrors", dynlib: cgraphDll.}
proc agResetErrors*(): cint {.importc: "agreseterrors", dynlib: cgraphDll.}
proc agSetErrF*(a1: AgUserErrF): AgUserErrF {.importc: "agseterrf", dynlib: cgraphDll.}
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

template agTail*(e: untyped): untyped =
  AGTAIL(e)

template agHead*(e: untyped): untyped =
  AGHEAD(e)

template agOpp*(e: untyped): untyped =
  AGOPP(e)

template agEqedge*(e, f: untyped): untyped =
  (AGMKOUT(e) == AGMKOUT(f))

const
  TAILPORT_ID* = "tailport"
  HEADPORT_ID* = "headport"

# when defined(_MSC_VER) and not defined(CGRAPH_EXPORTS):
 # const
 #   extern* = __declspec(dllimport)

var
  agDirected* {.importc: "Agdirected", dynlib: cgraphDll.}: AgDescT
  agStrictDirected* {.importc: "Agstrictdirected", dynlib: cgraphDll.}: AgDescT
  agUndirected* {.importc: "Agundirected", dynlib: cgraphDll.}: AgDescT
  agStrictUndirected* {.importc: "Agstrictundirected", dynlib: cgraphDll.}: AgDescT

##  fast graphs

proc agFlatten*(g: ptr AGraphT; flag: cint) {.importc: "agflatten", dynlib: cgraphDll.}
type
  AgNodeRefT* = AgSubNodeT
  AgedgerefT* = DtLinkT

template AGHEADPOINTER*(g: untyped): untyped =
  cast[ptr AgNodeRefT]((g.n_seq.data.hh.head))

template AGRIGHTPOINTER*(rep: untyped): untyped =
  cast[ptr AgNodeRefT]((if (rep).seqLink.right: (
      cast[pointer](((rep).seqLink.right)) - offsetof(AgSubNodeT, seqLink)) else: 0))

template AGLEFTPOINTER*(rep: untyped): untyped =
  cast[ptr AgNodeRefT](
    if (rep).seqLink.hl.left:
      cast[pointer]((rep).seqLink.hl.left - offsetof(AgSubNodeT, seqLink))
    else: 0
  )

template FIRSTNREF*(g: untyped): untyped =
  agFlatten(g, 1)
  AGHEADPOINTER(g)

template NEXTNREF*(g, rep: untyped): untyped =
  if AGRIGHTPOINTER(rep) == AGHEADPOINTER(g): 0
  else: AGRIGHTPOINTER(rep)

template PREVNREF*(g, rep: untyped): untyped =
  if (rep) == AGHEADPOINTER(g): 0
  else: AGLEFTPOINTER(rep)

template LASTNREF*(g: untyped): untyped =
  agFlatten(g, 1)
  if AGHEADPOINTER(g): AGLEFTPOINTER(AGHEADPOINTER(g))
  else: 0

template NODEOF*(rep: untyped): untyped =
  ((rep).node)

template FIRSTOUTREF*(g, sn: untyped): untyped =
  agFlatten(g, 1)
  (sn).out_seq

template LASTOUTREF*(g, sn: untyped): untyped =
  agFlatten(g, 1)
  cast[ptr AgedgerefT](dtlast(sn.out_seq))

template FIRSTINREF*(g, sn: untyped): untyped =
  agFlatten(g, 1)
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
    cast[ptr AgEdgeT]((cast[ptr cuchar]((rep)) - offsetof(AgEdgeT, seqLink)))
  else: cast[ptr DtholdT](rep.obj)
