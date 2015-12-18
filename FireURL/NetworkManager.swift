import Alamofire
import Foundation

internal class NetworkManager {
   private static let defaults = NSUserDefaults.standardUserDefaults()

   private static var hostPref : String {
      get {
         defaults.synchronize()
         guard let host = defaults.valueForKey("host_perference") as? String else {
            return "0.0.0.0"
         }
         return host
      }
   }

   private static var portPref : Int {
      get {
         defaults.synchronize()
         guard let port = defaults.valueForKey("port_perference") as? String where Int(port) != nil else {
            return 0
         }
         return Int(port)!
      }
   }

   static let sharedInstance = NetworkManager();

   func performPostRequest(params : Dictionary<String, String>, callback : ((succeed : Bool)->())?) throws -> Request {
      return Alamofire.request(.POST, "http://\(NetworkManager.hostPref):\(NetworkManager.portPref)/", parameters: params)
         .response { (req, res, data, error) -> Void in
            if let callback = callback {
               callback(succeed: error == nil)
            }
      }
   }
}
