//
//  WebSocketsHandler.swift
//  WebServer
//
//  Created by huhuegg on 2017/5/4.
//
//

import PerfectLib
import PerfectWebSockets
import PerfectHTTP

let kWebsocketCommandName = "cmd"
let kWebsocketDataName = "data"
let kWebsocketCodeName = "code"
let kWebsocketMsgName = "msg"
public class WebSocketsHandler: WebSocketSessionHandler {
    //客户端与服务器协议匹配
    public var socketProtocol: String? = ""
    
    // 连接建立后handleSession立即被调用
    public func handleSession(request: HTTPRequest, socket: WebSocket) {
        
        WS.instance.addClientIfNeed(self, request: request, socket: socket) { (isSuccess) in
            
        }

        // 收取文本消息
        socket.readStringMessage {
            // 数据， 消息操作码， 消息是否完整
            string, op, fin in
            // Print some information to the console for informational purposes.
            //print("Read msg: \(string) op: \(op) fin: \(fin)")
            
            // 当连接超时或网络错误时数据为nil，以此为依据关闭客户端socket
            if let string = string {
                do {
                    if let decoded = try string.jsonDecode() as? [String:AnyObject] {
                        if let command = decoded[kWebsocketCommandName] as? String, let data = decoded[kWebsocketDataName] as? [String:Any] {

                            print("<---Client(\(socket.socketMemoryAddress()))# command:\(command) data:\(data)")
                            WS.instance.processRequestMessage(socket, command: WSCommand.response(name: command), data: data)
                            
                        } else {
                            print("reqMsg format error: \(string)")
                        }
                    }
                } catch {
                    print("decodeMsg failed:\(string)")
                }
            } else {
                WS.instance.removeClient(socket, callback: { (isSuccess) in
                    socket.close()
                })
            }

        }

    }
    
    

}

