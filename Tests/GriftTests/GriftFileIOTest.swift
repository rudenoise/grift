import XCTest
import Grift
import Foundation

class GriftFileIOTests: XCTestCase {

  func testReadFile() {
    XCTAssertEqual(
      "Hello!\nHi!\n",
      Grift.readFile(path: "./Tests/GriftTests/files/hello.txt")!
    )
    XCTAssertTrue(
      Grift.readFromFile(path: "./I/dont/exist.txt") == nil
    )
  }

  func testWriteFile() {

    let dateformatter = DateFormatter()

    dateformatter.dateStyle = DateFormatter.Style.fullStyle
    dateformatter.timeStyle = DateFormatter.Style.fullStyle

    let now = dateformatter.string(from: Date())

    // WRITE THE FILE
    XCTAssertTrue(Grift.writeStringToFile(
      string: "Hello from \(now)!\n",
      path: "/tmp/test.txt"
    ))

    // READ THE NEW FILE
    XCTAssertEqual(
      "Hello from \(now)!\n",
      Grift.readFile(path: "/tmp/test.txt")!
    )
  }

  static var allTests : [(String, (GriftFileIOTests) -> () throws -> Void)] {
    return [
      ("testReadFile", testReadFile),
      ("testWriteFile", testWriteFile),
    ]
  }
}
