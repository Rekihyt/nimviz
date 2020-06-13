# nimviz
A very barebones wrapper for the graphviz c api.
Currently untested on windows/macos.

Requires the graphviz dev files and headers.
The debian package for them is libgraphviz-dev.

## Examples

Basic graph opening and closing and render

```nim
import nimviz
var
  graph = agopen("G", agDirected, nil)
  gvc = gvContext()
  node = graph.agnode("node1", 1)

let f = open("graph.gv")
var g = agread(f, nil);

echo gvLayout(gvc, graph, "dot")
echo gvRender(gvc, graph, "plain", cast[ptr File](stdout))

echo gvFreeLayout(gvc, graph)
echo gvFreeContext(gvc)
```