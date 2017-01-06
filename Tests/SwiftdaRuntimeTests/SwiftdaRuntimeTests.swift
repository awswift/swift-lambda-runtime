import XCTest
@testable import SwiftdaRuntime

class SwiftdaRuntimeTests: XCTestCase {
    func testExample() throws {
        let pipe = Pipe()
        let input: [String: Any] = ["event": ["hello": "world"], "context": ["millis": 123]]
        let inputData = try JSONSerialization.data(withJSONObject: input, options: [])
        pipe.fileHandleForWriting.write(inputData)
        pipe.fileHandleForWriting.closeFile()
        
        let runtime = SwiftdaRuntime(inputHandle: pipe.fileHandleForReading, outputHandle: FileHandle.nullDevice)
        runtime.run { event, context in
            XCTAssertEqual(event as! [String: String], ["hello": "world"])
            return nil
        }
    }


    static var allTests : [(String, (SwiftdaRuntimeTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
