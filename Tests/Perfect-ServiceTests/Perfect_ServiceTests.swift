import XCTest
@testable import Perfect_Service

class Perfect_ServiceTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Perfect_Service().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
