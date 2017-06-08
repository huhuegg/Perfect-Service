//
//  WebSocketClients+ProcessMessage.swift
//  WebServer
//
//  Created by huhuegg on 2017/5/15.
//
//

import PerfectWebSockets
import PerfectThread
import PerfectHTTP

enum DataType {
    case string
    case dictStringAny
    case arryAny
    case arrayString
    case int
    case double
    case bool
    
    func desc()->String {
        switch self {
        case .string:
            return "String"
        case .dictStringAny:
            return "Dictionary<String,Any>"
        case .arryAny:
            return "Array<Any>"
        case .arrayString:
            return "Array<String>"
        case .int:
            return "Int"
        case .double:
            return "Double"
        case .bool:
            return "Bool"
            
        }
    }
}

public class DataTypeCheck {
    class func dataCheck(_ data:[String:Any]?, types:[String:DataType])->Bool {
        guard let d = data else {
            print("需要检测的数据不存在")
            return false
        }
        
        for key in types.keys {
            if let value = d[key] {
                let type = types[key]!
                let isSuccess = check(value, type: type)
                
                if !isSuccess {
                    print("key:\(key) isSuccess:\(isSuccess.description) needType:\(type.desc())")
                    return false
                }
            } else {
                print("需要检测的key:\(key)在数据中不存在")
                return false
            }
        }
        return true
    }
    
    class func check(_ value:Any, type:DataType)->Bool {
        var status:Bool = false
        switch type {
        case .string:
            if value is String {
                status = true
            }
            break
        case .dictStringAny:
            if value is Dictionary<String,Any> {
                status = true
            }
            break
        case .arryAny:
            if value is Array<Any> {
                status = true
            }
            break
        case .arrayString:
            if value is Array<String> {
                status = true
            }
            break
        case .int:
            if value is Int {
                status = true
            }
            break
        case .double:
            if value is Double {
                status = true
            }
            break
        case .bool:
            if value is Bool {
                status = true
            }
            break
        }
        return status
    }
}

public enum WSCommand {
    case request(name: String)
    case response(name: String)
}

extension WS {
    public func processRequestMessage(_ socket: WebSocket, command:WSCommand, data:[String:Any]?) {
        switch command {
        case .request(name: let commandName):
            printLog("command:\(commandName) data:\(String(describing: data))")
            break
        default:
            printLog("command type error!")
        }

    }
}

extension WS {    

    fileprivate func sendMsg(_ socket: WebSocket, command:WSCommand, code:Bool, msg:String, data:[String:Any]?) {
        var dict:[String:Any] = [:]
        
        switch command {
        case .response(name: let command):
            dict[kWebsocketCommandName] = command
            break
        default:
            printLog("command type error!")
            return
        }
        dict[kWebsocketCodeName] = code ? 0:1
        dict[kWebsocketMsgName] = msg
        dict[kWebsocketDataName] = data
        do {
            let message = try dict.jsonEncodedString()
            print("--->Client(\(socket.socketMemoryAddress()))#(\(String(describing: dict[kWebsocketCommandName]))) \(message)")
            socket.sendStringMessage(string: message, final: true) {
                
                // This callback is called once the message has been sent.
                // Recurse to read and echo new message.
                
                self.clientInfo(socket, callback: { (clientInfo) in
                    if let c = clientInfo {
                        if let handler = c.handler, let request = c.request {
                            //self.printLog("handler.handleSession command:\(command)")
                            handler.handleSession(request: request, socket: socket)
                        } else {
                            print("clientInfo error!")
                        }
                    } else {
                        print("socket clientInfo not found")
                    }
                })
            }
        } catch  {
            print("dict.jsonEncodedString failed")
        }
        
    }

}
