import Foundation
import XCTest
@testable import SwiftLambdaRuntime

class SwiftLambdaRuntimeTests: XCTestCase {
    func testExample() throws {
        let pipe = Pipe()
        let input: [String: Any] = ["event": ["hello": "world"], "context": ["millis": 123]]
        let inputData = try JSONSerialization.data(withJSONObject: input, options: [])
        pipe.fileHandleForWriting.write(inputData)
        pipe.fileHandleForWriting.closeFile()
        
        var runtime = SwiftLambdaRuntime(inputHandle: pipe.fileHandleForReading, outputHandle: FileHandle.nullDevice)
        runtime.waiter = {}
        runtime.finisher = {}
        runtime.run { event, context, callback in
            XCTAssertEqual(event as! [String: String], ["hello": "world"])
        }
    }


    static var allTests : [(String, (SwiftLambdaRuntimeTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
