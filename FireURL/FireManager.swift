import UIKit

internal class FireManager {
   private static func convertURI(str : String) -> String? {
      // returns str if valid URI, nil otherwise
      return NSURL(string: str) != nil ? str : nil
   }

   private static func fireURI(uri: String, callback: (Void->Void)?) {
      print("firing...")
      do {
         try NetworkManager.sharedInstance.performPostRequest(["url": uri]) { (succeed) -> () in
            print("Succeed when firing url: \(succeed)")
            if let callback = callback {
               callback()
            }
         }
      } catch {
         print("error")
      }
   }

   static func fireURIStr(strUri: String, callback: (Void->Void)?) {
      if let uri = FireManager.convertURI(strUri) {
         FireManager.fireURI(uri, callback: callback)
      }
   }

   static func firePasteBoard(callback: (Void->Void)?) {
      if let theString = UIPasteboard.generalPasteboard().string {
         FireManager.fireURIStr(theString, callback: callback)
      }
   }

}