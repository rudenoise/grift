import XCTest

public func allTests() -> [XCTestCaseEntry] {
  return [
    testCase(GriftTests.allTests),
    testCase(GriftValidationTests.allTests),
    testCase(GriftFileIOTests.allTests),
    testCase(GriftJSONTests.allTests),
  ]
}
