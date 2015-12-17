import UIKit

class ViewController: UIViewController {
   
   dynamic private func firePasteBoardNotificationHandler(notification: NSNotification){
      FireManager.firePasteBoard {
         print("Quitting application")
         exit(0) // Early quits the application
      }
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      // Register background to foreground notification handler
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "firePasteBoardNotificationHandler:", name:"FIRE_URL_DID_BECOME_ACTIVE", object: nil)
   }


   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }

}

