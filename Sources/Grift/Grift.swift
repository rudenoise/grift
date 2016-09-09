import Foundation

public struct Edge {

  public init(id: NSUUID? = nil, from: NSUUID, to: NSUUID, note: String? = nil) {
    self.id = id ?? NSUUID()
    self.from = from
    self.to = to
    self.note = note
  }

  public let id: NSUUID
  public let from: NSUUID
  public let to: NSUUID
  public let note: String?

}

public struct Vertex {

  public init(id: NSUUID? = nil, title: String, body: String) {
    self.id = id ?? NSUUID()
    self.title = title
    self.body = body
  }

  public let id: NSUUID
  public let title: String
  public let body: String

}

public struct Graph {

  public init(
    id: NSUUID? = nil,
    vertices: [Vertex] = [],
    edges: [Edge] = []
  ) {

    self.id = id ?? NSUUID()
    self.vertices = vertices
    self.edges = edges
  }

  public let id: NSUUID
  public let vertices: [Vertex]
  public let edges: [Edge]

  public func hasVertexWithId(_ vertexId: NSUUID) -> Bool {
    let matches = self.vertices.reduce(0) {
      total, existingVertex in
      total + (existingVertex.id == vertexId ? 1 : 0)
    }
    return matches > 0
  }

  public func hasVertex(_ vertex: Vertex) -> Bool {
    return self.hasVertexWithId(vertex.id)
  }

  public func addVertex(_ vertex: Vertex) -> Graph? {
    return  Grift.addVertex(graph: self, vertex: vertex)
  }

  public func hasEdge(_ edge: Edge) -> Bool {
    let matches = self.edges.reduce(0) {
      total, existingEdge in
      total + (
        (existingEdge.from == edge.from) &&
        (existingEdge.to == edge.to) ?
        1 : 0
      )
    }
    return matches > 0
  }

  public func addEdge(_ newEdge: Edge) -> Graph? {
    return Grift.addEdge(graph: self, newEdge: newEdge)
  }
}

public typealias VertexPair = (Vertex, Vertex)

private func addVertex(graph: Graph, vertex: Vertex) -> Graph? {
  if graph.hasVertex(vertex) {
    return nil
  }
  return Graph(
    vertices: graph.vertices + [vertex],
    edges: graph.edges
  )
}

private func addEdge(graph: Graph, newEdge: Edge) -> Graph? {

  if graph.hasEdge(newEdge) ||
    !graph.hasVertexWithId(newEdge.from) ||
    !graph.hasVertexWithId(newEdge.to)
  {
    return nil
  }

  return Graph(
    vertices: graph.vertices,
    edges: graph.edges + [newEdge]
  )
}

