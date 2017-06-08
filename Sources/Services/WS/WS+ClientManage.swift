//
//  WS+Private.swift
//  WebServer
//
//  Created by huhuegg on 2017/5/15.
//
//

import PerfectWebSockets
import PerfectThread
import PerfectHTTP

extension WS {
    func isClientExist(_ socket:WebSocket, callback:@escaping (_ clientInfo:ClientInfo?)->()) {
        q.dispatch {
            self.clientInfo(socket, callback: { (clientInfo) in
                callback(clientInfo)
            })
        }
    }
    
    func addClientIfNeed(_ handler:WebSocketSessionHandler, request: HTTPRequest, socket:WebSocket, callback:@escaping (_ isSuccess:Bool)->()) {
        isClientExist(socket) { (clientInfo) in
            if let _ = clientInfo {
                self.updateClientInfo(handler, request: request, socket: socket, callback: { (isSuccess) in
                    callback(isSuccess)
                })
            } else {
                self.addClient(handler, request: request, socket: socket, callback: { (isSuccess) in
                    callback(isSuccess)
                })
            }
        }
    }
    
    func removeClient(_ socket:WebSocket, callback:@escaping (_ isSuccess:Bool)->()) {
        let address:Int = socket.socketMemoryAddress()
        if let _ = clients[address] {
            print("delClient:\(address)")
            q.dispatch {
                if let _ = self.clients.removeValue(forKey: address) {
                    callback(true)
                } else {
                    callback(false)
                }
            }
        }

    }
    
    func clientInfo(_ socket:WebSocket, callback:@escaping (_ clientInfo:ClientInfo?)->()) {
        q.dispatch {
            let address:Int = socket.socketMemoryAddress()
            if let clientInfo = self.clients[address] {
                callback(clientInfo)
            } else {
                callback(nil)
            }
        }
    
    }

}

extension WS {
    fileprivate func addClient(_ handler:WebSocketSessionHandler, request: HTTPRequest, socket:WebSocket, callback:@escaping (_ isSuccess:Bool)->()) {
        let address:Int = socket.socketMemoryAddress()
        let clientInfo = ClientInfo()
        clientInfo.handler = handler
        clientInfo.request = request
        clientInfo.socket = socket
        
        print("addClient:\(address)")
        q.dispatch {
            self.clients[address] = clientInfo
            callback(true)
        }
    }
    
    fileprivate func updateClientInfo(_ handler:WebSocketSessionHandler, request: HTTPRequest, socket:WebSocket, callback:@escaping (_ isSuccess:Bool)->()) {
        clientInfo(socket) { (clientInfo) in
            if let client = clientInfo {
                self.q.dispatch {
                    client.handler = handler
                    client.request = request
                    callback(true)
                }
            } else {
                callback(false)
            }
        }

    }
}
