import UIKit

class ViewController: UIViewController {
   
   dynamic private func didBecomeActiveHandler(notification: NSNotification){
      if let str = UIPasteboard.generalPasteboard().string,
         let url = FireManager.convertURI(str) {
         targetURL.text = url
      }

      serverConfigLabel.text = "\(NetworkManager.hostPref):\(NetworkManager.portPref)"
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

   dynamic private func didFindFireableURIHandler(notification: NSNotification) {
      guard let uri = notification.object?["uri"] else {
         return
      }
      if let uri = uri as? String {
         targetURL.text = uri
      }
   }

   dynamic private func dismissKeyboard() {
      view.endEditing(true)
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      // Register background to foreground notification handlers
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActiveHandler:", name:"com.prankymat.fireURL.didBecomeActive", object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFireURIHandler:", name: "com.prankymat.fireURL.didFireURI", object: nil)
      NSNotificationCenter.defaultCenter().addObserver(self, selector: "didCancelFireURIHandler:", name: "com.prankymat.fireURL.didCancelFireURI", object: nil)

      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
      view.addGestureRecognizer(tap)
   }


   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }

   @IBOutlet weak var actionButton: UIButton!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

   @IBOutlet weak var targetURL: UITextField!
   
   @IBOutlet weak var serverConfigLabel: UILabel!

   @IBAction func actionButtonClicked(sender: AnyObject) {
      switch FireManager.sharedInstance.firing {
      case true:
         FireManager.sharedInstance.stopAllFiring()
         reportStop()

      case false:
         if let uri = targetURL.text {
            reportStart()
            FireManager.sharedInstance.fireURIStr(uri)
         }
      }
   }

   @IBAction func githubClicked(sender: AnyObject) {
      UIApplication.sharedApplication().openURL(NSURL(string: "https://fireurl.github.io/")!)
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

