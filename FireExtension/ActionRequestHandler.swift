import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

   func beginRequestWithExtensionContext(context: NSExtensionContext) {
      for item: AnyObject in context.inputItems {
         let inputItem = item as! NSExtensionItem
         for provider: AnyObject in inputItem.attachments! {
            let itemProvider = provider as! NSItemProvider
            if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
               // Handler for generic URLs
               itemProvider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil, completionHandler:  {
                  (list, error) in
                  if let result = list as? NSURL {
                     FireManager.sharedInstance.fireURIStr(String(result))
                  }
               })
            } else if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
               // Handler for Safari
               itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil, completionHandler: {
                  (list, error) in
                  if let results = list as? NSDictionary {
                     NSOperationQueue.mainQueue().addOperationWithBlock {
                        if let baseURL = results.valueForKeyPath("NSExtensionJavaScriptPreprocessingResultsKey.baseURI") as? String {
                           FireManager.sharedInstance.fireURIStr(baseURL)
                        } else {
                           fatalError("Cannot get URI from webpage!")
                        }
                     }
                  }
               })
            }
         }
      }
   }
}
