
public enum PerfectServiceType {
    case mysql()
}

public class PerfectService {
    static var psInstance = PerfectService()
    
    static var instance:PerfectService {
        return psInstance
    }

    
}
