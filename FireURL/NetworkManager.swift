import SwiftHTTP

internal class NetworkManager {
   private let host : String
   private let port : Int

   private static let defaults = NSUserDefaults.standardUserDefaults()

   private static var hostPref : String {
      get {
         return defaults.valueForKey("host_perference") as! String
      }
   }

   private static var portPref : Int {
      get {
         guard let port = defaults.valueForKey("port_perference") as? String where Int(port) != nil else {
            return 0
         }
         return Int(port)!
      }
   }

   static let sharedInstance = NetworkManager(host: hostPref, port: portPref);

   init() {
      fatalError("Default constructor not available.")
   }

   init(host : String, port : Int) {
      self.host = host
      self.port = port
   }

   func performPostRequest(params : Dictionary<String, String>, callback : ((succeed : Bool)->())?) throws {
      var succeed : Bool = false

      let opt = try HTTP.POST("http://" + host + ":" + String(port), parameters: params)
      opt.start { response in
         guard response.statusCode != nil && response.statusCode == 200 else {
            succeed = false
            return
         }
         succeed = true

         defer {
            if let callback = callback {
               callback(succeed: succeed)
            }
         }
      }
   }
}
