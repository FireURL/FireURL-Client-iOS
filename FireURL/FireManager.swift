import UIKit
import Alamofire

internal class FireManager {

   static let sharedInstance = FireManager()

   var firing = false
   var currentReq : Request? = nil

   static func convertURI(str : String) -> String? {
      // returns str if valid URI, nil otherwise
      return NSURL(string: str) != nil ? str : nil
   }

   private func fireURI(uri: String) {
      firing = true
      do {
         currentReq = try NetworkManager.sharedInstance.performPostRequest(["url": uri]) { (succeed) -> () in
            NSNotificationCenter.defaultCenter().postNotificationName("com.prankymat.fireURL.didFireURI", object: ["succeed": succeed])
            self.firing = false
            self.currentReq = nil
         }
      } catch let e {
         print("Error when firing URL, error: \(e)")
      }
   }

   func fireURIStr(strUri: String) {
      if let uri = FireManager.convertURI(strUri) {
         fireURI(uri)
      }
   }

   func stopAllFiring() {
      if let currentReq = currentReq {
         currentReq.cancel()
         self.firing = false
         NSNotificationCenter.defaultCenter().postNotificationName("com.prankymat.fireURL.didCancelFireURI", object: nil)
      }
      currentReq = nil
   }

}