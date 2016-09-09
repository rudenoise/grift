# Grift (Graphs + Swift)

## About

This is a library for creating, manipulating, querying and
persisting Graph Data using the Swift programming language.
It is written in a functional/immutable style.

Developed and tested on Linux (Ubuntu 16.04) using Swift 3 (Preview
6).

The library has basic types for _vertices_ and _edges_ and uses
JSON to persist graphs.

This project is in its early stages and therefore volatile and
likely to change.

## Install

```swift
import PackageDescription

let package = Package(
    name: "Your project/package name",
    dependencies: [
        .Package(
            url: "https://github.com/rudenoise/grift"
            majorVersion: 0
        )
    ]
)
```

## Use

```swift
import Grift

// create some vertices

let vertexA = Vertex(
    name: "Vertex A",
    body: "A string..."
)

let vertexB = Vertex(
    name: "Vertex B",
    body: "Another string..."
)

// create a basic graph, with one edge

let graphA = Graph(
    vertices: [vertexA, vertexB],
    edges: [
        Edge(
            from: vertexA.id,
            to: vertexB.id
        )
    ]
)

// make a similar graph with another vertex

let graphB = graphA.addVertex(
    Vertex(
        name: "Vertex C"
        body: "Text again..."
    )
)

// and another with a further edge

let graphC = graphB.addEdge(
    Edge(from: vertexB.id, to: vertexA.id)
)
```

## License

Licensed under [GPLv3](LICENSE)
