## 	Public interface for the dictionary library
## *
## *      Written by Kiem-Phong Vo
##

const gvcDll* =
  when defined(windows):
      "cdt.dll"
  elif defined(macosx):
      "libcdt.dylib"
  else:
      "libcdt.so(|.5)"

const
  cdtVersion* = 20050420

# when defined(_WIN32):
#   const
#     __EXPORT__* = __declspec(dllexport)
#     __IMPORT__* = __declspec(dllimport)

##  for libdict compatibility

# type
#   size_t* = uint
#   uint16_t* = uint16
#   int32t* = int32
#   uint8_t* = uint8

# type
#   DtLinkT* = _dtlink_s
#   Dthold_t* = _dthold_s
#   DtdiscT* = _dtdisc_s
#   DtmethodT* = _dtmethod_s
#   DtdataT* = _dtdata_s
#   DtT* = _dt_s
#   Dict_t* = _dt_s

##  structure to hold methods that manipulate an object
type
  DtdiscT* {.importc: "Dtdisc_t", header: "graphviz/cdt.h", bycopy.} = object
    key* {.importc: "key".}: cint ##  where the key begins in an object
    size* {.importc: "size".}: cint ##  key size and type
    link* {.importc: "link".}: cint ##  offset to DtLinkT field
    makef* {.importc: "makef".}: DtmakeF ##  object constructor
    freef* {.importc: "freef".}: DtfreeF ##  object destructor
    comparf* {.importc: "comparf".}: DtcomparF ##  to compare two objects
    hashf* {.importc: "hashf".}: DthashF ##  to compute hash value of an object
    memoryf* {.importc: "memoryf".}: DtmemoryF ##  to allocate/free memory
    eventf* {.importc: "eventf".}: DteventF ##  to process events


  DtmemoryF* = proc (a1: ptr DtT; a2: pointer; a3: csize_t; a4: ptr DtdiscT): pointer
  DtsearchF* = proc (a1: ptr DtT; a2: pointer; a3: cint): pointer
  DtmakeF* = proc (a1: ptr DtT; a2: pointer; a3: ptr DtdiscT): pointer
  DtfreeF* = proc (a1: ptr DtT; a2: pointer; a3: ptr DtdiscT)
  DtcomparF* = proc (a1: ptr DtT; a2: pointer; a3: pointer; a4: ptr DtdiscT): cint
  DthashF* = proc (a1: ptr DtT; a2: pointer; a3: ptr DtdiscT): cuint
  DteventF* = proc (a1: ptr DtT; a2: cint; a3: pointer; a4: ptr DtdiscT): cint

  DtmethodT* {.importc: "Dtmemory_f", header: "graphviz/cdt.h", bycopy.} = object
    searchf* {.importc: "searchf".}: DtsearchF ##  search function
    `type`* {.importc: "type".}: cint ##  type of operation

#                                 ##  for hash dt, > 0: fixed table size

#  stuff that may be in shared memory

  DtdataT* {.importc: "DtdataS", header: "graphviz/cdt.h", bycopy.} = object
    `type`* {.importc: "type".}: cint ##  type of dictionary
    here* {.importc: "here".}: ptr DtLinkT ##  finger to last search element
    hh* {.importc: "hh".}: INNER_C_UNION_cdt_66
    ntab* {.importc: "ntab".}: cint ##  number of hash slots
    size* {.importc: "size".}: cint ##  number of objects
    loop* {.importc: "loop".}: cint ##  number of nested loops
    minp* {.importc: "minp".}: cint ##  min path before splay, always even

  DtT* {.importc: "Dt_t", header: "graphviz/cdt.h", bycopy.} = object
    searchF* {.importc: "searchf".}: DtsearchF ##  search function
    disc* {.importc: "disc".}: ptr DtdiscT ##  method to manipulate objs
    data* {.importc: "data".}: ptr DtdataT ##  sharable data
    memoryF* {.importc: "memoryf".}: DtmemoryF ##  function to alloc/free memory
    meth* {.importc: "meth".}: ptr DtmethodT ##  dictionary method
    `type`* {.importc: "type".}: cint ##  type information
    nView* {.importc: "nview".}: cint ##  number of parent view dictionaries
    view* {.importc: "view".}: ptr DtT ##  next on viewpath
    walk* {.importc: "walk".}: ptr DtT ##  dictionary being walked
    user* {.importc: "user".}: pointer ##  for user's usage
  DictT* = DtT

  INNER_C_UNION_cdt_66* {.importc: "no_name", header: "graphviz/cdt.h", bycopy, union.} = object
    htab* {.importc: "Htab".}: ptr ptr DtLinkT ##  hash table
    head* {.importc: "Head".}: ptr DtLinkT ##  linked list


  DtLinkT* {.importc: "DtlinkS", header: "graphviz/cdt.h", bycopy.} = object
    right* {.importc: "right".}: ptr DtLinkT ##  right child
    hl* {.importc: "hl".}: INNER_C_UNION_cdt_44
    
  INNER_C_UNION_cdt_44* {.importc: "no_name", header: "graphviz/cdt.h", bycopy, union.} = object
    hash* {.importc: "Hash".}: cuint ##  hash value
    left* {.importc: "Left".}: ptr DtLinkT ##  left child


  Dthold_t* {.importc: "DtholdS", header: "graphviz/cdt.h", bycopy.} = object
    hdr* {.importc: "hdr".}: DtLinkT ##  header
    obj* {.importc: "obj".}: pointer ##  user object

  Dtstat_t* {.importc: "DtstatS", header: "graphviz/cdt.h", bycopy.} = object
    dtMeth* {.importc: "dt_meth".}: cint ##  method type
    dtSize* {.importc: "dt_tize".}: cint ##  number of elements
    dtN* {.importc: "dt_n".}: cint ##  number of chains or levels
    dtMax* {.importc: "dt_max".}: cint ##  max size of a chain or a level
    dtCount* {.importc: "dt_count".}: ptr cint ##  counts of chains or levels by size


##  private structure to hold an object
##  method to manipulate dictionary structure
##  structure to get status of a dictionary

##  the dictionary structure itself
# template DTDISC*(dc, ky, sz, lk, mkf, frf, cmpf, hshf, memf, evf: untyped): untyped =
#   (
#     (dc).key = (ky)
#     (dc).size = (sz)
#     (dc).link = (lk)
#     (dc).makef = (mkf)
#     (dc).freef = (frf)
#     (dc).comparf = (cmpf)
#     (dc).hashf = (hshf)
#     (dc).memoryf = (memf)
#     (dc).eventf = (evf))


## 
##  flag set if the last search operation actually found the object

const
  DT_FOUND* = 0o000000100000

##  supported storage methods

const
  DT_SET* = 1
  DT_BAG* = 2
  DT_OSET* = 4
  DT_OBAG* = 10
  DT_LIST* = 20
  DT_STACK* = 40
  DT_QUEUE* = 100
  DT_DEQUE* = 200
  DT_METHODS* = 377

##  asserts to dtdisc()

const
  DT_SAMECMP* = 1
  DT_SAMEHASH* = 2

##  types of search

const
  DT_INSERT* = 1
  DT_DELETE* = 2
  DT_SEARCH* = 4
  DT_NEXT* = 10
  DT_PREV* = 20
  DT_RENEW* = 40
  DT_CLEAR* = 100
  DT_FIRST* = 200
  DT_LAST* = 400
  DT_MATCH* = 1000
  DT_VSEARCH* = 2000
  DT_ATTACH* = 4000
  DT_DETACH* = 10000
  DT_APPEND* = 20000

##  events

const
  DT_OPEN* = 1
  DT_CLOSE* = 2
  DT_DISC* = 3
  DT_METH* = 4
  DT_ENDOPEN* = 5
  DT_ENDCLOSE* = 6
  DT_HASHSIZE* = 7

##  public data

# when defined(_BLD_cdt) and defined(__EXPORT__):
#   const
#     extern* = __EXPORT__
# when not defined(_BLD_cdt) and defined(__IMPORT__):
#   const
#     extern* = __IMPORT__
var dtSet* {.importc: "Dtset", header: "graphviz/cdt.h".}: ptr DtmethodT
var dtBag* {.importc: "Dtbag", header: "graphviz/cdt.h".}: ptr DtmethodT
var dtOset* {.importc: "Dtoset", header: "graphviz/cdt.h".}: ptr DtmethodT
var dtObag* {.importc: "Dtobag", header: "graphviz/cdt.h".}: ptr DtmethodT
var dtList* {.importc: "Dtlist", header: "graphviz/cdt.h".}: ptr DtmethodT
var dtStack* {.importc: "Dtstack", header: "graphviz/cdt.h".}: ptr DtmethodT
var dtQueue* {.importc: "Dtqueue", header: "graphviz/cdt.h".}: ptr DtmethodT
var dtDeque* {.importc: "Dtdeque", header: "graphviz/cdt.h".}: ptr DtmethodT

##  compatibility stuff; will go away

when not defined(KPVDEL):
  var dtOrder* {.importc: "Dtorder", header: "graphviz/cdt.h".}: ptr DtmethodT
  var dtTree* {.importc: "Dttree", header: "graphviz/cdt.h".}: ptr DtmethodT
  var dtHash* {.importc: "Dthash", header: "graphviz/cdt.h".}: ptr DtmethodT
  var uscoreDttree* {.importc: "Dttree", header: "graphviz/cdt.h".}: DtmethodT
  var uscoreDthash* {.importc: "Dthash", header: "graphviz/cdt.h".}: DtmethodT
  var uscoreDtlist* {.importc: "Dtlist", header: "graphviz/cdt.h".}: DtmethodT
  var uscoreDtqueue* {.importc: "Dtqueue", header: "graphviz/cdt.h".}: DtmethodT
  var uscoreDtstack* {.importc: "Dtstack", header: "graphviz/cdt.h".}: DtmethodT
##  public functions

# when defined(_BLD_cdt) and defined(__EXPORT__):
#   const
#     extern* = __EXPORT__
proc dtopen*(a1: ptr DtdiscT; a2: ptr DtmethodT): ptr DtT {.importc: "dtopen",
    dynlib: gvcDll.}
proc dtclose*(a1: ptr DtT): cint {.importc: "dtclose", dynlib: gvcDll.}
proc dtview*(a1: ptr DtT; a2: ptr DtT): ptr DtT {.importc: "dtview", dynlib: gvcDll.}
proc dtdisc*(dt: ptr DtT; a2: ptr DtdiscT; a3: cint): ptr DtdiscT {.importc: "dtdisc",
    dynlib: gvcDll.}
proc dtmethod*(a1: ptr DtT; a2: ptr DtmethodT): ptr DtmethodT {.importc: "dtmethod",
    dynlib: gvcDll.}
proc dtflatten*(a1: ptr DtT): ptr DtLinkT {.importc: "dtflatten", dynlib: gvcDll.}
proc dtextract*(a1: ptr DtT): ptr DtLinkT {.importc: "dtextract", dynlib: gvcDll.}
proc dtrestore*(a1: ptr DtT; a2: ptr DtLinkT): cint {.importc: "dtrestore",
    dynlib: gvcDll.}
proc dttreeset*(a1: ptr DtT; a2: cint; a3: cint): cint {.importc: "dttreeset",
    dynlib: gvcDll.}
proc dtwalk*(a1: ptr DtT; a2: proc (a1: ptr DtT; a2: pointer; a3: pointer): cint;
            a3: pointer): cint {.importc: "dtwalk", dynlib: gvcDll.}
proc dtrenew*(a1: ptr DtT; a2: pointer): pointer {.importc: "dtrenew", dynlib: gvcDll.}
proc dtsize*(a1: ptr DtT): cint {.importc: "dtsize", dynlib: gvcDll.}
proc dtstat*(a1: ptr DtT; a2: ptr Dtstat_t; a3: cint): cint {.importc: "dtstat",
    dynlib: gvcDll.}
proc dtstrhash*(a1: cuint; a2: pointer; a3: cint): cuint {.importc: "dtstrhash",
    dynlib: gvcDll.}
##  internal functions for translating among holder, object and key

# template _DT*(dt: untyped): untyped =
#   (cast[ptr DtT]((dt)))

# template _DTDSC*(dc, ky, sz, lk, cmpf: untyped): untyped =
#   (
#     ky = dc.key
#     sz = dc.size
#     lk = dc.link
#     cmpf = dc.comparf)

# template _DTLNK*(o, lk: untyped): untyped =
#   (cast[ptr DtLinkT]((cast[cstring]((o)) + lk)))

# template _DTOBJ*(e, lk: untyped): untyped =
#   (if lk < 0: (cast[ptr Dthold_t]((e))).obj else: cast[pointer]((
#       cast[cstring]((e)) - lk)))

# template _DTKEY*(o, ky, sz: untyped): untyped =
#   cast[pointer]((if sz < 0: (cast[cstringArray]((cast[cstring]((o)) + ky)))[] else: (
#       cast[cstring]((o)) + ky)))

# template _DTCMP*(dt, k1, k2, dc, cmpf, sz: untyped): untyped =
#   (if cmpf: (cmpf[])(dt, k1, k2, dc) else: (if sz <= 0: strcmp(k1, k2) else: memcmp(k1, k2, sz)))

# template _DTHSH*(dt, ky, dc, sz: untyped): untyped =
#   (if dc.hashf: (dc.hashf[])(dt, ky, dc) else: dtstrhash(0, ky, sz))

# ##  special search function for tree structure only

# template _DTMTCH*(dt, key, action: untyped): void =
#   while true:
#     var _e: ptr DtLinkT
#     var
#       _o: pointer
#       _k: pointer
#       _key: pointer
#     var _dc: ptr DtdiscT
#     var
#       _ky: cint
#       _tz: cint
#       _lk: cint
#       _cmp: cint
#     var _cmpf: Dtcompar_f
#     _dc = (dt).disc
#     _DTDSC(_dc, _ky, _tz, _lk, _cmpf)
#     _key = (key)
#     _e = (dt).data.here
#     while _e:
#       _o = _DTOBJ(_e, _lk)
#       _k = _DTKEY(_o, _ky, _tz)
#       if (_cmp = _DTCMP((dt), _key, _k, _dc, _cmpf, _tz)) == 0:
#         break
#       _e = if _cmp < 0: _e.hl._left else: _e.right
#     action(if _e: _o else: cast[pointer](0))
#     if not 0:
#       break

# template _DTSRCH*(dt, obj, action: untyped): void =
#   while true:
#     var _e: ptr DtLinkT
#     var
#       _o: pointer
#       _k: pointer
#       _key: pointer
#     var _dc: ptr DtdiscT
#     var
#       _ky: cint
#       _tz: cint
#       _lk: cint
#       _cmp: cint
#     var _cmpf: Dtcompar_f
#     _dc = (dt).disc
#     _DTDSC(_dc, _ky, _tz, _lk, _cmpf)
#     _key = _DTKEY(obj, _ky, _tz)
#     _e = (dt).data.here
#     while _e:
#       _o = _DTOBJ(_e, _lk)
#       _k = _DTKEY(_o, _ky, _tz)
#       if (_cmp = _DTCMP((dt), _key, _k, _dc, _cmpf, _tz)) == 0:
#         break
#       _e = if _cmp < 0: _e.hl._left else: _e.right
#     action(if _e: _o else: cast[pointer](0))
#     if not 0:
#       break

# template DTTREEMATCH*(dt, key, action: untyped): untyped =
#   _DTMTCH(_DT(dt), cast[pointer]((key)), action)

# template DTTREESEARCH*(dt, obj, action: untyped): untyped =
#   _DTSRCH(_DT(dt), cast[pointer]((obj)), action)

# template dtvnext*(d: untyped): untyped =
#   (_DT(d).view)

# template dtvcount*(d: untyped): untyped =
#   (_DT(d).nview)

# template dtvhere*(d: untyped): untyped =
#   (_DT(d).walk)

# template dtlink*(d, e: untyped): untyped =
#   ((cast[ptr DtLinkT]((e))).right)

# template dtobj*(d, e: untyped): untyped =
#   _DTOBJ((e), _DT(d).disc.link)

# template dtfinger*(d: untyped): untyped =
#   (if _DT(d).data.here: dtobj((d), _DT(d).data.here) else: cast[pointer]((0)))

# template dtfirst*(d: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((0)), DT_FIRST)

# template dtnext*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_NEXT)

# template dtleast*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_SEARCH or DT_NEXT)

# template dtlast*(d: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((0)), DT_LAST)

# template dtprev*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_PREV)

# template dtmost*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_SEARCH or DT_PREV)

# template dtsearch*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_SEARCH)

# template dtmatch*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_MATCH)

# template dtinsert*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_INSERT)

# template dtappend*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_INSERT or DT_APPEND)

# template dtdelete*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_DELETE)

# template dtattach*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_ATTACH)

# template dtdetach*(d, o: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((o)), DT_DETACH)

# template dtclear*(d: untyped): untyped =
#   ((_DT(d).searchf)[])((d), cast[pointer]((0)), DT_CLEAR)

# template dtfound*(d: untyped): untyped =
#   (_DT(d).`type` and DT_FOUND)

const
  dtPrime* = 17109811

# template dtcharhash*(h, c: untyped): untyped =
#   ((cast[cuint]((h)) + cast[cuint]((c))) * DT_PRIME)
