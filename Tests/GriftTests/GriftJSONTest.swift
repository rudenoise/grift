import XCTest
import Grift
import Foundation

class GriftJSONTests: XCTestCase {

  func testReadEmptyGraph() {

    // REJECT INVALID FILE PATH
    XCTAssertTrue(
      Grift.readFromFile(path: "/tmp/i/dont/exist.json") == nil
    )
    // ACCEPT WELL FORMED JSON
    // ENSURE JSON IS TURNED INTO EXPECTED TOPIC GRAPH
    // EMPTY BUT FOR TOPIC ID
    let g1 = Grift.readFromFile(path: "./Tests/GriftTests/files/basicGraph.json")!
    XCTAssertTrue(g1.id == NSUUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    XCTAssertEqual(g1.vertices.count, 0)
  }

  func testReadGraphWithVertices() {
    let g2Opt = Grift.readFromFile(path: "./Tests/GriftTests/files/graphWithVertices.json")
    XCTAssertTrue(g2Opt != nil)
    let g2 = g2Opt!
    XCTAssertEqual(g2.id, NSUUID(uuidString: "757907EA-F28B-4149-A773-5819F03418F6"))
    XCTAssertEqual(g2.vertices.count, 2)
    XCTAssertEqual(g2.vertices[0].id, NSUUID(uuidString: "33A20585-02E5-4EDD-A7EB-1FC35F45C7C7"))
    XCTAssertEqual(g2.vertices[0].title, "Vertex A")
    XCTAssertEqual(g2.vertices[0].body, "Vertex A body...")
    XCTAssertEqual(g2.vertices[1].id, NSUUID(uuidString: "2F1D77D7-D34E-467E-B93A-3AEF8FB6C41A"))
    XCTAssertEqual(g2.vertices[1].title, "Vertex B")
    XCTAssertEqual(g2.vertices[1].body, "Vertex B body...")
  }

  func testReadGraphWithVerticesAndEdges() {
    let g3Opt = Grift.readFromFile(path: "./Tests/GriftTests/files/graphWithVerticesAndEdges.json")
    XCTAssertTrue(g3Opt != nil)
    let g3 = g3Opt!
    XCTAssertEqual(g3.id, NSUUID(uuidString: "757907EA-F28B-4149-A773-5819F03418F6"))
    XCTAssertEqual(g3.vertices.count, 3)
    XCTAssertEqual(g3.edges.count, 2)
    XCTAssertEqual(g3.edges[0].id, NSUUID(uuidString: "A9509DD7-8EFB-420F-9D3F-85EDD5854259"))
    XCTAssertEqual(g3.edges[0].from, g3.vertices[0].id)
    XCTAssertEqual(g3.edges[1].id, NSUUID(uuidString: "9E9A109F-3445-4EC1-B8DE-3A0936D127E1"))
  }

	func testWriteEmptyGraph() {
    let g1 = Grift.readFromFile(path: "./Tests/GriftTests/files/basicGraph.json")!
		XCTAssertTrue(g1.writeToPath("/tmp/basicGraph.json"))
    let g2 = Grift.readFromFile(path: "/tmp/basicGraph.json")
		XCTAssertTrue(g2 != nil)
		XCTAssertEqual(g1.id, g2!.id)
	}

  func testWriteGraphWithVertices() {
    let gA = Grift.readFromFile(path: "./Tests/GriftTests/files/graphWithVertices.json")!
		XCTAssertTrue(gA.writeToPath("/tmp/basicGraph.json"))
    let gB = Grift.readFromFile(path: "/tmp/basicGraph.json")!
		XCTAssertEqual(gA.id, gB.id)
		XCTAssertEqual(gA.vertices.count, gB.vertices.count)
		XCTAssertEqual(gA.vertices[0].id, gB.vertices[0].id)
		XCTAssertEqual(gA.vertices[1].id, gB.vertices[1].id)
	}

  func testWriteGraphWithVerticesAndEdges() {
    let gA = Grift.readFromFile(path: "./Tests/GriftTests/files/graphWithVerticesAndEdges.json")!
		XCTAssertTrue(gA.writeToPath("/tmp/basicGraph.json"))
    let gB = Grift.readFromFile(path: "/tmp/basicGraph.json")!
		XCTAssertEqual(gA.id, gB.id)
		XCTAssertEqual(gA.edges.count, gB.edges.count)
		XCTAssertEqual(gA.edges[1].id, gB.edges[1].id)
	}

  static var allTests : [(String, (GriftJSONTests) -> () throws -> Void)] {
    return [
      ("testReadEmptyGraph", testReadEmptyGraph),
      ("testReadGraphWithVertices", testReadGraphWithVertices),
      ("testReadGraphWithVerticesAndEdges", testReadGraphWithVerticesAndEdges),
			("testWriteEmptyGraph", testWriteEmptyGraph),
      ("testWriteGraphWithVertices", testWriteGraphWithVertices),
			("testWriteGraphWithVerticesAndEdges", testWriteGraphWithVerticesAndEdges)
    ]
  }
}
