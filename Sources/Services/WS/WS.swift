//
//  WS.swift
//  WebServer
//
//  Created by huhuegg on 2017/5/5.
//
//


import PerfectWebSockets
import PerfectThread


public protocol WSProtocol {
    func processRequestMessage(_ socket: WebSocket, command:WSCommand, data:[String:Any]?)
}
public class WS {
    static var ws = WS()
    
    static var instance:WS {
        return ws
    }
    
    var clients:Dictionary<Int,ClientInfo> = Dictionary()

    let q = Threading.getQueue(name: "#WebSocket Thread#", type: Threading.QueueType.serial)
    
    func printLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
        
        print("\(file.lastFilePathComponent)[\(line)], \(method): \(message)")
    }
    
}

extension WebSocket {
    func socketMemoryAddress() -> Int {
        return unsafeBitCast(self, to: Int.self)
    }
}
