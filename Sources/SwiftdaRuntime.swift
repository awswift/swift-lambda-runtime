import Foundation

public struct SwiftdaRuntime {
    typealias Entrypoint = (_ event: [String: Any], _ context: [String: Any], _ callback: (Any?) -> Void) -> Void
    
    public let inputHandle: FileHandle
    public let outputHandle: FileHandle
    var finisher: (Void) -> Void
    var waiter: (Void) -> Void
    
    public init(inputHandle: FileHandle = FileHandle.standardInput, outputHandle: FileHandle = FileHandle.standardOutput) {
        self.inputHandle = inputHandle
        self.outputHandle = outputHandle
        self.finisher = { exit(0) }
        self.waiter = { dispatchMain() }
    }
    
    public func run(_ function: Entrypoint) {
        let inputData = inputHandle.readDataToEndOfFile()
        let json = try! JSONSerialization.jsonObject(with: inputData, options: []) as! [String: Any]
        
        let event = json["event"] as! [String: Any]
        let context = json["context"] as! [String: Any]
        
        function(event, context) { result in
            let outputData = try! JSONSerialization.data(withJSONObject: result ?? [:], options: [])
            outputHandle.write(outputData)
            finisher()
        }
        
        waiter()
    }
}


