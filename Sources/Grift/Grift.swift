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

public struct GraphStruct {

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

  public func addVertex(_ vertex: Vertex) -> GraphStruct? {
    return  Grift.addVertex(graphStruct: self, vertex: vertex)
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

  public func addEdge(_ edgeVertices: VertexPair) -> GraphStruct? {
    return Grift.addEdge(graphStruct: self, edgeVertices: edgeVertices)
  }
}

public typealias VertexPair = (Vertex, Vertex)

public typealias GraphStructArray = [GraphStruct]

public func addVertex(graphStruct: GraphStruct, vertex: Vertex) -> GraphStruct? {
  if graphStruct.hasVertex(vertex) {
    return nil
  }
  return GraphStruct(
    vertices: graphStruct.vertices + [vertex],
    edges: graphStruct.edges
  )
}

public func addEdge(graphStruct: GraphStruct, edgeVertices: VertexPair) -> GraphStruct? {
  let (fromVertex, toVertex) = edgeVertices
  let newEdge = Edge(from: fromVertex.id, to: toVertex.id)

  if graphStruct.hasEdge(newEdge) ||
    !graphStruct.hasVertex(fromVertex) ||
    !graphStruct.hasVertex(toVertex)
  {
    return nil
  }

  return GraphStruct(
    vertices: graphStruct.vertices,
    edges: graphStruct.edges + [newEdge]
  )
}

private func findParentGraphStruct(_ graphStructArray: GraphStructArray, _ vertex: Vertex) -> GraphStruct? {
  let found = graphStructArray.filter({
    return $0.hasVertex(vertex)
  })
  if found.count > 0 {
    return found[0]
  }
  return nil
}

