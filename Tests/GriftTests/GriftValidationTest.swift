import XCTest
import Grift
import Foundation

class GriftValidationTests: XCTestCase {

  func testVertexValidation() {

    // EMPTY GRAPH IS VALID
    XCTAssertTrue(Grift.validateGraphInternals(Graph()))

    let va = Vertex(title: "VA", body: "")
    let vb = Vertex(title: "VA", body: "")

    // REJECT GRAPH WITH DUPLICATE VERTICES
    let gA = Graph(vertices: [va, va])
    XCTAssertFalse(validateGraphInternals(gA))

    // ACCEPT GRAPH WITH TWO VETICES
    let gB = Graph(vertices: [va, vb])
    XCTAssertTrue(validateGraphInternals(gB))
  }

  func testEdgeValidation() {
    // EMPTY GRAPH IS VALID
    XCTAssertEqual(Grift.validateGraphInternals(Graph()), true)

    // REJECT GRAPH WITH INTERNAL EDGES BUT NO VERTECIES
    let gA = Graph(
      edges: [Edge(from: NSUUID(), to: NSUUID())]
    )
    XCTAssertFalse(
      validateGraphInternals(gA)
    )

    // ACCEPT GRAPH WITH VALID VERTICES
    let gB = Graph(
      vertices: [
        Vertex(title: "VA", body: ""),
        Vertex(title: "VB", body: ""),
      ]
    )
    XCTAssertTrue(
      validateGraphInternals(gB)
    )

    // REJECT GRAPH WITH EDGES THAT DON'T MAGCH VERTICES
    let gC = Graph(
      vertices: [
        Vertex(title: "VA", body: ""),
        Vertex(title: "VB", body: ""),
      ],
      edges: [Edge(from: NSUUID(), to: NSUUID())]
    )
    XCTAssertFalse(
      validateGraphInternals(gC)
    )
  }
  static var allTests : [(String, (GriftValidationTests) -> () throws -> Void)] {
    return [
      ("testEdgeValidation", testEdgeValidation),
      ("testVertexValidation", testVertexValidation),
    ]
  }
}
