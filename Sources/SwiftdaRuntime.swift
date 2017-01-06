import Foundation

public struct SwiftdaRuntime {
    public let inputHandle: FileHandle
    public let outputHandle: FileHandle
    
    public init(inputHandle: FileHandle = FileHandle.standardInput, outputHandle: FileHandle = FileHandle.standardOutput) {
        self.inputHandle = inputHandle
        self.outputHandle = outputHandle
    }
    
    public func run(_ function: (_ event: Any, _ context: Any) -> Any?) {
        let inputData = inputHandle.readDataToEndOfFile()
        let json = try! JSONSerialization.jsonObject(with: inputData, options: []) as! [String: Any]
        
        let event = json["event"]!
        let context = json["context"]!
        
        let output = function(event, context) ?? [:]
        
        let outputData = try! JSONSerialization.data(withJSONObject: output, options: [])
        outputHandle.write(outputData)
    }
    
    public static func run(_ function: (_ event: Any, _ context: Any) -> Any?) {
        return SwiftdaRuntime().run(function)
    }
}


