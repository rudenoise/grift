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
    let tg1 = Grift.readFromFile(path: "./Tests/GriftTests/files/basicGraph.json")!
    XCTAssertTrue(tg1.id == NSUUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"))
    XCTAssertEqual(tg1.vertices.count, 0)
  }

  func testReadGraphWithVertices() {
    let tg2Opt = Grift.readFromFile(path: "./Tests/GriftTests/files/graphWithVertices.json")
    XCTAssertTrue(tg2Opt != nil)
    let tg2 = tg2Opt!
    XCTAssertEqual(tg2.id, NSUUID(uuidString: "757907EA-F28B-4149-A773-5819F03418F6"))
    XCTAssertEqual(tg2.vertices.count, 2)
    XCTAssertEqual(tg2.vertices[0].id, NSUUID(uuidString: "33A20585-02E5-4EDD-A7EB-1FC35F45C7C7"))
    XCTAssertEqual(tg2.vertices[0].title, "Vertex A")
    XCTAssertEqual(tg2.vertices[0].body, "Vertex A body...")
    XCTAssertEqual(tg2.vertices[1].id, NSUUID(uuidString: "2F1D77D7-D34E-467E-B93A-3AEF8FB6C41A"))
    XCTAssertEqual(tg2.vertices[1].title, "Vertex B")
    XCTAssertEqual(tg2.vertices[1].body, "Vertex B body...")
  }

  func testReadGraphWithVerticesAndEdges() {
    let tg3Opt = Grift.readFromFile(path: "./Tests/GriftTests/files/graphWithVerticesAndEdges.json")
    XCTAssertTrue(tg3Opt != nil)
    let tg3 = tg3Opt!
    XCTAssertEqual(tg3.id, NSUUID(uuidString: "757907EA-F28B-4149-A773-5819F03418F6"))
    XCTAssertEqual(tg3.vertices.count, 3)
    XCTAssertEqual(tg3.edges.count, 2)
    XCTAssertEqual(tg3.edges[0].id, NSUUID(uuidString: "A9509DD7-8EFB-420F-9D3F-85EDD5854259"))
    XCTAssertEqual(tg3.edges[0].from, tg3.vertices[0].id)
    XCTAssertEqual(tg3.edges[1].id, NSUUID(uuidString: "9E9A109F-3445-4EC1-B8DE-3A0936D127E1"))
    XCTAssertTrue(Grift.validateGraphInternals(tg3))
  }

	func testWriteEmptyGraph() {
    let tg1 = Grift.readFromFile(path: "./Tests/GriftTests/files/basicGraph.json")!
		XCTAssertTrue(tg1.writeToPath("/tmp/basicGraph.json"))
    let tg2 = Grift.readFromFile(path: "/tmp/basicGraph.json")
		XCTAssertTrue(tg2 != nil)
	}

  static var allTests : [(String, (GriftJSONTests) -> () throws -> Void)] {
    return [
      ("testReadEmptyGraph", testReadEmptyGraph),
      ("testReadGraphWithVertices", testReadGraphWithVertices),
      ("testReadGraphWithVerticesAndEdges", testReadGraphWithVerticesAndEdges),
			("testWriteEmptyGraph", testWriteEmptyGraph)
    ]
  }
}
