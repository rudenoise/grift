import XCTest
import Grift
import Foundation

class GriftTests: XCTestCase {
  func testInitialization() {

    // TEST BASIC TYPES AND INITIALISATION

    // VERTEX BASICS
    let vertexA = Grift.Vertex(
      title:"Vertex A",
      body:"Some text..."
    )

    XCTAssertEqual(vertexA.title, "Vertex A")
    XCTAssertEqual(vertexA.body, "Some text...")

    let vertexB = Grift.Vertex(
      title:"Vertex B",
      body:"Some more text..."
    )

    XCTAssertEqual(vertexB.title, "Vertex B")
    XCTAssertEqual(vertexB.body, "Some more text...")

    // COMBINE VERTEX, EDGE AND GRAPH
    let graphA = Grift.Graph(
      vertices: [
        vertexA,
        vertexB
      ],
      edges: [
        Grift.Edge(
          from: vertexA.id,
          to: vertexB.id,
          note: "a link l to r"
        )
      ]
    )!

    XCTAssertEqual(graphA.edges[0].from, vertexA.id)
    XCTAssertEqual(graphA.edges[0].to, vertexB.id)

    // TEST THAT DEFAULTS ARE EFFECTIVE
    let emptyGraph = Grift.Graph()!

    XCTAssertEqual(emptyGraph.edges.count, 0)
    XCTAssertEqual(emptyGraph.vertices.count, 0)

  }

  func testGraphHasVertexWithId() {
    let vertexA = Vertex(title: "Vertex A", body: "...")
    let vertexB = Vertex(title: "Vertex B", body: "...")
    let graph = Grift.Graph(vertices: [vertexA])!
    XCTAssertEqual(graph.hasVertexWithId(vertexA.id), true)
    XCTAssertEqual(graph.hasVertexWithId(vertexB.id), false)
  }

  func testGraphHasVertex() {
    let vertexA = Vertex(title: "Vertex A", body: "...")
    let vertexB = Vertex(title: "Vertex B", body: "...")
    let graph = Grift.Graph(vertices: [vertexA])!
    XCTAssertEqual(graph.hasVertex(vertexA), true)
    XCTAssertEqual(graph.hasVertex(vertexB), false)
  }

  func testGraphAddVertex() {
    let graphA = Grift.Graph()!
    XCTAssertEqual(graphA.vertices.count, 0)

    // ADD A VERTEX USING A METHOD, UNWRAPPIN THE OPTIONAL IMEDIATLY
    let vertexA = Vertex(title: "First Virtex", body: "Yes, the first.")
    let graphA2 = graphA.addVertex(vertexA)!
    XCTAssertEqual(graphA2.vertices.count, 1)

    // ADD A VERTEX USING A FUNCTION, UNWRAPPIN THE OPTIONAL IMEDIATLY
    let graphA3 = graphA2.addVertex(
      Vertex(title: "Another Virtex", body: "Yes, the first.")
    )!
    XCTAssertEqual(graphA3.vertices.count, 2)

    // PREVENT RE-ADDING SAME VERTEX
    let graphA4 = graphA3.addVertex(vertexA)
    XCTAssertEqual(graphA4 == nil, true)
  }

  func testGraphHasEdge() {
    let vertexA = Vertex(title: "VA", body: "...")
    let vertexB = Vertex(title: "VB", body: "...")
    let vertexC = Vertex(title: "VC", body: "...")
    let edgeA = Edge(from: vertexA.id, to: vertexB.id)
    let graphA = Grift.Graph()!
    // ENSURE hasEdge IS PRESENT
    // AND RETURNS FALSE WHEN EMPTY
    XCTAssertEqual(
      graphA.hasEdge(Edge(from: vertexA.id, to: vertexC.id)),
      false
    )
    // ENSURE EDGE IS NOT DETECTED WHEN NO MATCH
    let graphB = Grift.Graph(
      vertices: [vertexA, vertexB, vertexC],
      edges: [edgeA]
    )!
    XCTAssertEqual(
      graphB.hasEdge(Edge(from: vertexA.id, to: vertexC.id)),
      false
    )
    // ENSURE EDGE WITH SAME FROM/TO IDS ARE DETECTED
    XCTAssertEqual(
      graphB.hasEdge(Edge(from: vertexA.id, to: vertexB.id)),
      true
    )
  }

  func testGraphAddEdge() {
    let graph = Grift.Graph(vertices: [
      Vertex(title: "Vertex A", body: "..."),
      Vertex(title: "Vertex B", body: "...")
    ])!

    // ENSURE A NEW EDGE CAN BE ADDED
    let graph2 = graph.addEdge(
      Grift.Edge(from: graph.vertices[0].id, to: graph.vertices[1].id)
    )!
    XCTAssertEqual(graph2.edges[0].from == graph2.vertices[0].id, true)
    XCTAssertEqual(graph2.edges[0].to == graph2.vertices[1].id, true)

    // ENSURE DUPLICATE EDGES CAN'T BE ADDED
    let graph3 = graph2.addEdge(
      Grift.Edge(from: graph.vertices[0].id, to: graph.vertices[1].id)
    )
    XCTAssertEqual(graph3 == nil, true)

    // ENSURE EDGES WITH VERTICES OUTSIDE GRAPH CAN'T BE ADDED
    let graph4 = graph2.addEdge(
      Grift.Edge(
        from: graph.vertices[0].id,
        to: NSUUID()
      )
    )
    XCTAssertEqual(graph4 == nil, true)

  }

  static var allTests : [(String, (GriftTests) -> () throws -> Void)] {
    return [
      ("testInitialization", testInitialization),
      ("testGraphHasVertex", testGraphHasVertex),
      ("testGraphHasVertex", testGraphHasVertexWithId),
      ("testGraphAddVertex", testGraphAddVertex),
      ("testGraphHasEdge", testGraphHasEdge),
      ("testGraphAddEdge", testGraphAddEdge),
    ]
  }
}
