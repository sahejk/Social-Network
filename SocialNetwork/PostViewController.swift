
import UIKit
import Snap

class PostViewController :UIViewController {

    var profilePic : UIImageView!
    var titleLable : UILabel!
    var titleText : UITextField!
    var post :UIButton!


   func  setImageview(image :UIImage){
        self.profilePic = UIImageView(image: image)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable = UILabel()
        titleText = UITextField()

        titleLable.text = "Add title"
        titleLable.textColor = UIColor.blackColor()

        titleText.textColor = UIColor.blackColor()
        titleText.layer.borderWidth = 2;
        titleText.layer.borderColor = UIColor.blackColor().CGColor

        post = UIButton()
        post.titleLabel?.textColor=UIColor.blackColor()
        post.setTitle("Post Image", forState: UIControlState.Normal)
        post.backgroundColor=UIColor.grayColor()
        post.tintColor=UIColor.blackColor()
        post.addTarget(self, action: "postImage", forControlEvents: UIControlEvents.TouchUpInside)


        post.layer.borderColor=UIColor.blackColor().CGColor
        post.layer.borderWidth=3.0


        self.view.addSubview(self.profilePic)
        self.view.addSubview(titleLable)
        self.view.addSubview(titleText)
        self.view.addSubview(post)

        let padding = UIEdgeInsetsMake(30, 30, 30, 30)

        self.profilePic.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).with.offset(padding.top*3) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(150)
            make.width.equalTo(150)

    }

        self.titleLable.snp_makeConstraints { make in
            make.top.equalTo(self.profilePic.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(60)
            make.width.equalTo(150)

        }

        self.titleText.snp_makeConstraints { make in
            make.top.equalTo(self.titleLable.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(150)

        }

        self.post.snp_makeConstraints { make in
            make.top.equalTo(self.titleText.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(150)

        }



}
    func displayAlertMessage(alertTitle:NSString, alertDescription:NSString) -> Void {
        // hide activityIndicator view and display alert message
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }


    func postImage() {

        var imageData = UIImagePNGRepresentation(profilePic.image)
        var imageDataEncoded = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        var params = ["title": titleText.text, "name":"test.jpg", "content": imageDataEncoded]

        let httpHelper = HTTPHelper()
        var request = httpHelper.buildRequest("photos", method: "POST", authType: HTTPRequestAuthType.HTTPTokenAuth, requestContentType: HTTPRequestContentType.HTTPJsonContent)

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros, error: nil)
        httpHelper.sendRequest(request, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = httpHelper.getErrorMessage(error)
                self.displayAlertMessage("Error", alertDescription: errorMessage)

                return
            }

            var eror: NSError?
            let jsonDataDict = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions(0), error: &eror) as NSDictionary


    })



    }


}
