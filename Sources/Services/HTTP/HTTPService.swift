//
//  HTTPService.swift
//  Perfect_Service
//
//  Created by huhuegg on 2017/6/8.
//
//
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMustache

//enum HTTPRouteMethod:String {
//    case get = "GET"
//    case post = "POST"
//}

public class HTTPService {
    var server:HTTPServer
    var routes:Routes
    var isDocumentRootExisted = false
    
    //HTTP服务初始化
    init() {
        self.server = HTTPServer()
        self.routes = Routes()
    }
    convenience init(localAddress:String = "0.0.0.0", port:UInt16 = 8080, documentRoot:String = "~/webroot") {
        self.init()
        server.serverAddress = localAddress
        server.serverPort = port
        server.documentRoot = documentRoot
        let serverDocumentDir = Dir(server.documentRoot)
        do {
            try serverDocumentDir.create()
            isDocumentRootExisted = true
        } catch {
            print("serverDocumentDir create failed!")
            isDocumentRootExisted = false
        }
    }
    
    //在DocumentRoot目录下创建所需目录
    public func createSubPath(subPath:String) -> Bool {
        guard isDocumentRootExisted else {
            return false
        }
        let dir = Dir(server.documentRoot + "/" + subPath)
        do {
            try dir.create()
            return true
        } catch {
            print("createSubPath: \(subPath) failed(\(error))")
            return false
        }
    }
    
    //添加route
    public func add(method: HTTPMethod, uri: String, handler: @escaping RequestHandler) {
        self.routes.add(Route(method: method, uri: uri, handler: handler))
    }
    
    public func start() -> Bool {
        do {
            try server.start()
            print("start http service success!")
            return true
        } catch  {
            print("start http service failed!")
            return false
        }
    }
}
