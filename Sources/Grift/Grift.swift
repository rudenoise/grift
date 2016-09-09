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

  public func hasVertex(_ vertex: Vertex) -> Bool {
    let matches = self.vertices.reduce(0) {
      total, existingVertex in
      total + (existingVertex.id == vertex.id ? 1 : 0)
    }
    return matches > 0
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

  public func addEdge(_ edgeVertices: VertexPair) -> Graph? {
    return Grift.addEdge(graph: self, edgeVertices: edgeVertices)
  }
}

public typealias VertexPair = (Vertex, Vertex)

public typealias GraphArray = [Graph]

public func addVertex(graph: Graph, vertex: Vertex) -> Graph? {
  if graph.hasVertex(vertex) {
    return nil
  }
  return Graph(
    vertices: graph.vertices + [vertex],
    edges: graph.edges
  )
}

public func addEdge(graph: Graph, edgeVertices: VertexPair) -> Graph? {
  let (fromVertex, toVertex) = edgeVertices
  let newEdge = Edge(from: fromVertex.id, to: toVertex.id)

  if graph.hasEdge(newEdge) ||
    !graph.hasVertex(fromVertex) ||
    !graph.hasVertex(toVertex)
  {
    return nil
  }

  return Graph(
    vertices: graph.vertices,
    edges: graph.edges + [newEdge]
  )
}

private func findParentGraph(_ graphArray: GraphArray, _ vertex: Vertex) -> Graph? {
  let found = graphArray.filter({
    return $0.hasVertex(vertex)
  })
  if found.count > 0 {
    return found[0]
  }
  return nil
}

