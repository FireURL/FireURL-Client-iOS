import UIKit

class ViewController: UIViewController {
   
   dynamic private func didBecomeActiveHandler(notification: NSNotification){
      FireManager.sharedInstance.firePasteBoard()
   }

   dynamic private func didFireURIHandler(notification: NSNotification) {
      reportStop()
      if let succeed = notification.object?["succeed"] where succeed != nil && succeed as! Int == 0 {
         let alert = UIAlertController(title: "Failed to Fire URL", message: "Please check if server is configured correctly!", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
         presentViewController(alert, animated: true, completion: nil)
      }
   }

   dynamic private func didCancelFireURIHandler(notification: NSNotification) {
      reportStop()
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      // Register background to foreground notification handlers
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActiveHandler:", name:"com.prankymat.fireURL.didBecomeActive", object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFireURIHandler:", name: "com.prankymat.fireURL.didFireURI", object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didCancelFireURIHandler:", name: "com.prankymat.fireURL.didCancelFireURI", object: nil)
   }


   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }

   @IBOutlet weak var actionButton: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

   @IBOutlet weak var targetURL: UITextField!
   
   @IBAction func actionButtonClicked(sender: AnyObject) {
      if FireManager.sharedInstance.firing {
         FireManager.sharedInstance.stopAllFiring()
         reportStop()
      } else {
         if let uri = targetURL.text {
            reportStart()
            FireManager.sharedInstance.fireURIStr(uri)
         }
      }
   }

   func reportStop() {
      activityIndicator.stopAnimating()
      actionButton.setTitle("Start Firing", forState: .Normal)
   }

   func reportStart() {
      activityIndicator.startAnimating()
      actionButton.setTitle("Stop Firing", forState: .Normal)
   }
}

