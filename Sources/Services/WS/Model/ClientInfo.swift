//
//  ClientInfo.swift
//  WebServer
//
//  Created by huhuegg on 2017/5/15.
//
//

import PerfectWebSockets
import PerfectHTTP

public class ClientInfo {
    var handler:WebSocketSessionHandler?
    var request:HTTPRequest?
    var socket:WebSocket?
    var userSid:String?
}
