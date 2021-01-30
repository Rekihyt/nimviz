# nimviz
A very barebones wrapper for the graphviz c api.
Currently untested on windows/macos.

Requires the graphviz dev files and headers.
The debian package for them is libgraphviz-dev.

## Examples

Basic graph opening and closing and render.
You can quickly view output using fim:
```bash
nimble build; ./binary | dot -Tjpg | fim -i --autowindow
```

```nim
import nimviz

var
  graph = agOpen("G", agDirected)
  context = gvContext()
  node1 = graph.agNode("node1")
  node2 = graph.agNode("node2")
  # Create an edge
  edge1 = graph.agEdge(node1, node2, "edge1")

# Set an attribute
discard node2.agSafeSet("color", "green")

discard gvLayout(context, graph, "fdp")
discard gvRender(context, graph, "dot", cast[ptr File](stdout))

discard gvFreeLayout(context, graph)
discard agClose(graph)
discard gvFreeContext(context)
```

## Not Working
Any nested structures, such as DtLinkT and their dependencies.