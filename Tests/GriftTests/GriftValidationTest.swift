import XCTest
import Grift
import Foundation

class GriftValidationTests: XCTestCase {

  func testVertexValidation() {

    // EMPTY GRAPH IS VALID
    XCTAssertTrue(Graph() != nil)

    let va = Vertex(title: "VA", body: "")
    let vb = Vertex(title: "VA", body: "")

    // REJECT GRAPH WITH DUPLICATE VERTICES
    let gA = Graph(vertices: [va, va])
    XCTAssertTrue(gA == nil)

    // ACCEPT GRAPH WITH TWO VETICES
    let gB = Graph(vertices: [va, vb])
    XCTAssertTrue(gB != nil)
  }

  func testEdgeValidation() {
    // EMPTY GRAPH IS VALID
    XCTAssertTrue(Graph() != nil)

    // REJECT GRAPH WITH INTERNAL EDGES BUT NO VERTECIES
    let gA = Graph(
      edges: [Edge(from: NSUUID(), to: NSUUID())]
    )
    XCTAssertTrue(
      gA == nil
    )

    // ACCEPT GRAPH WITH VALID VERTICES
    let gB = Graph(
      vertices: [
        Vertex(title: "VA", body: ""),
        Vertex(title: "VB", body: ""),
      ]
    )
    XCTAssertTrue(gB != nil)

    // REJECT GRAPH WITH EDGES THAT DON'T MAGCH VERTICES
    let gC = Graph(
      vertices: [
        Vertex(title: "VA", body: ""),
        Vertex(title: "VB", body: ""),
      ],
      edges: [Edge(from: NSUUID(), to: NSUUID())]
    )
    XCTAssertTrue(
      gC == nil
    )
  }

  static var allTests : [(String, (GriftValidationTests) -> () throws -> Void)] {
    return [
      ("testEdgeValidation", testEdgeValidation),
      ("testVertexValidation", testVertexValidation),
    ]
  }
}
