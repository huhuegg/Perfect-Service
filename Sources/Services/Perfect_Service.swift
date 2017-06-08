
public enum PerfectServiceType {
    case websocket
    case mysql(host:String, port:Int32, user:String, password:String, db:String, charset:String, reconnect:Bool, connectTimeout:Int, readTimeout:Int, writeTimeout:Int)
    case redis(host:String, port:Int32, password:String, timeout:Double)
}

public class PerfectService {
    static var psInstance = PerfectService()
    
    static var instance:PerfectService {
        return psInstance
    }

}
