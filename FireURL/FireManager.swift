import UIKit

internal class FireManager {

   static let sharedInstance = FireManager()

   var firing = false

   private static func convertURI(str : String) -> String? {
      // returns str if valid URI, nil otherwise
      return NSURL(string: str) != nil ? str : nil
   }

   private func fireURI(uri: String) {
      print("firing...")
      firing = true
      do {
         try NetworkManager.sharedInstance.performPostRequest(["url": uri]) { (succeed) -> () in
            print("Succeed when firing url: \(succeed)")
            NSNotificationCenter.defaultCenter().postNotificationName("com.prankymat.fireURL.didFireURI", object: nil)
            self.firing = false
         }
      } catch {
         print("error")
      }
   }

   func fireURIStr(strUri: String) {
      if let uri = FireManager.convertURI(strUri) {
         fireURI(uri)
      }
   }

   func firePasteBoard() {
      if let theString = UIPasteboard.generalPasteboard().string {
         fireURIStr(theString)
      }
   }

   func stopAllFiring() {
      
   }

}