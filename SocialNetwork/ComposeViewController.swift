
import UIKit

protocol SelfieComposeDelegate {
    func reloadCollectionViewWithSelfie(selfieImgObject: SelfieImage)
}

class ComposeViewController: UIViewController {
    @IBOutlet weak var thumbImgView: UIImageView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var activityIndicatorView: UIView!

    var thumbImg : UIImage!
    var composeDelegate:SelfieComposeDelegate! = nil
    let httpHelper = HTTPHelper()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.titleTextView.becomeFirstResponder()
        self.thumbImgView.image = thumbImg
        self.automaticallyAdjustsScrollViewInsets = false
        self.activityIndicatorView.layer.cornerRadius = 10

        setNavigationItems()
    }

    func setNavigationItems() {
        self.title = "Compose"

        var cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cancelBtnTapped"))
        self.navigationItem.leftBarButtonItem = cancelBarButtonItem

        var postBarButtonItem = UIBarButtonItem(title: "Post", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("postBtnTapped"))
        self.navigationItem.rightBarButtonItem = postBarButtonItem
    }

    func cancelBtnTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func displayAlertMessage(alertTitle:NSString, alertDescription:NSString) -> Void {
        // hide activityIndicator view and display alert message
        self.activityIndicatorView.hidden = true
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }

    func postBtnTapped() {
        // resign the keyboard for text view
        self.titleTextView.resignFirstResponder()
        self.activityIndicatorView.hidden = false

        // Create Multipart Upload request
        var imgData : NSData = UIImagePNGRepresentation(thumbImg)
        let httpRequest = httpHelper.uploadRequest("upload_photo", data: imgData, title: self.titleTextView.text)

        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                self.displayAlertMessage("Error", alertDescription: errorMessage)

                return
            }

            var eror: NSError?
            let jsonDataDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &eror) as NSDictionary

            var selfieImgObjNew = SelfieImage()

            selfieImgObjNew.imageTitle = jsonDataDict.valueForKey("title") as NSString
            selfieImgObjNew.imageId = jsonDataDict.valueForKey("random_id") as NSString
            selfieImgObjNew.imageThumbnailURL = jsonDataDict.valueForKey("image_url") as NSString

            self.composeDelegate.reloadCollectionViewWithSelfie(selfieImgObjNew)
            self.activityIndicatorView.hidden = true
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
