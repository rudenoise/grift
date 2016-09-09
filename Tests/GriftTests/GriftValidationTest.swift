import XCTest
import Grift
import Foundation

class GriftValidationTests: XCTestCase {

  func testVertexValidation() {

    // EMPTY GRAPH IS VALID
    XCTAssertTrue(Grift.validateGraphStructInternals(GraphStruct()))

    let va = Vertex(title: "VA", body: "")
    let vb = Vertex(title: "VA", body: "")

    // REJECT GRAPH WITH DUPLICATE VERTICES
    let gA = GraphStruct(vertices: [va, va])
    XCTAssertFalse(validateGraphStructInternals(gA))

    // ACCEPT GRAPH WITH TWO VETICES
    let gB = GraphStruct(vertices: [va, vb])
    XCTAssertTrue(validateGraphStructInternals(gB))
  }

  func testEdgeValidation() {
    // EMPTY GRAPH IS VALID
    XCTAssertEqual(Grift.validateGraphStructInternals(GraphStruct()), true)

    // REJECT GRAPH WITH INTERNAL EDGES BUT NO VERTECIES
    let gA = GraphStruct(
      edges: [Edge(from: NSUUID(), to: NSUUID())]
    )
    XCTAssertFalse(
      validateGraphStructInternals(gA)
    )

    // ACCEPT GRAPH WITH VALID VERTICES
    let gB = GraphStruct(
      vertices: [
        Vertex(title: "VA", body: ""),
        Vertex(title: "VB", body: ""),
      ]
    )
    XCTAssertTrue(
      validateGraphStructInternals(gB)
    )

    // REJECT GRAPH WITH EDGES THAT DON'T MAGCH VERTICES
    let gC = GraphStruct(
      vertices: [
        Vertex(title: "VA", body: ""),
        Vertex(title: "VB", body: ""),
      ],
      edges: [Edge(from: NSUUID(), to: NSUUID())]
    )
    XCTAssertFalse(
      validateGraphStructInternals(gC)
    )
  }
  static var allTests : [(String, (GriftValidationTests) -> () throws -> Void)] {
    return [
      ("testEdgeValidation", testEdgeValidation),
      ("testVertexValidation", testVertexValidation),
    ]
  }
}
