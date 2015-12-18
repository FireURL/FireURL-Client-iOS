import UIKit

class ViewController: UIViewController {
   
   dynamic private func didBecomeActiveHandler(notification: NSNotification){
      FireManager.sharedInstance.firePasteBoard()
   }

   dynamic private func didFireURIHandler(notification: NSNotification) {
      reportStop()
      print("here")
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      // Register background to foreground notification handler
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActiveHandler:", name:"com.prankymat.fireURL.didBecomeActive", object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFireURIHandler", name: "com.prankymat.fireURL.didFireURI", object: nil)
   }


   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }

   @IBOutlet weak var actionButton: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

   @IBOutlet weak var targetURL: UITextField!
   
   @IBAction func actionButtonClicked(sender: AnyObject) {
      print("FireManager.sharedInstance.firing\(FireManager.sharedInstance.firing)")
      if FireManager.sharedInstance.firing {
         FireManager.sharedInstance.stopAllFiring()
         reportStop()
         print("here stop")
      } else {
         if let uri = targetURL.text {
            reportStart()
            FireManager.sharedInstance.fireURIStr(uri)
         }
      }
   }

   func reportStop() {
      activityIndicator.stopAnimating()
      actionButton.titleLabel?.text = "Start Firing"
   }

   func reportStart() {
      activityIndicator.startAnimating()
      actionButton.titleLabel?.text = "Stop Firing"
   }
}

