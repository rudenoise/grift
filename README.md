# Grift (Graphs + Swift)

## About

This is a library for creating, manipulating, querying and
persisting Graph Data using the Swift programming language.
It is written in a functional/immutable style.

Developed and tested on _Linux_ (Ubuntu 16.04) using _Swift 3_.

The library has basic types for _graphs_, _vertices_ and _edges_
and uses JSON for persistence.

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

if let graphA = Graph(
    vertices: [vertexA, vertexB],
    edges: [
        Edge(
            from: vertexA.id,
            to: vertexB.id
        )
    ]
) {
    // grift uses a failable initializer,
    // so wont initailise unless graph is valid

    // make a similar graph with another vertex

    if let graphB = graphA.addVertex(
        Vertex(
            name: "Vertex C"
            body: "Text again..."
        )
    ) {

        // only alows a valid vertex

        // make another with a further edge

        if let graphC = graphB.addEdge(
            Edge(from: vertexB.id, to: vertexA.id)
        ) {
            // etc...
        }
    }

}

```

## License

Licensed under [GPLv3](LICENSE)
