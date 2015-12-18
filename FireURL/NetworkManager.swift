import Alamofire
import Foundation

internal class NetworkManager {
   private static let defaults = NSUserDefaults(suiteName: "group.com.PrankyMat.FireURL")!
   static var hostPref : String {
      get {
         guard let host = defaults.valueForKey("host_perference") as? String else {
            return "0.0.0.0"
         }

         return host
      }
   }

   static var portPref : Int {
      get {
         guard let port = defaults.valueForKey("port_perference") as? String where Int(port) != nil else {
            return 0
         }


         return Int(port)!
      }
   }

   static let sharedInstance = NetworkManager();

   func performPostRequest(params : Dictionary<String, String>, callback : ((succeed : Bool)->())?) throws -> Request {
      return Alamofire.request(.POST, "http://\(NetworkManager.hostPref):\(NetworkManager.portPref)/", parameters: params)
         .response { (_, _, _, error) -> Void in
            if let callback = callback {
               callback(succeed: error == nil)
            }
      }
   }
}
