import UIKit
import Snap


class ProfileViewController :UIViewController, UIActionSheetDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

//    var feedsController :MyListViewController!;

    var header :UILabel!;
    var followerHeader :UILabel!;
    var follower :UILabel!;
    var followingHeader :UILabel!;
    var following :UILabel!;
    var postHeader :UILabel!;
    var postContent :UITextView!;
    var postSubmit :UIButton!;

    var profileHeader :UILabel!;
    var galleryView :UICollectionView!
    var receivedImages = NSMutableArray ()

    var shouldFetchNewData = true
    var dataArray = NSMutableArray()
    var imageUrl  = NSMutableArray()
    var countOfRecieved = 0;

    override init(){
        super.init()
}
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createGalleryView()->UICollectionView{
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        var gallery = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        gallery.dataSource = self
        gallery.delegate = self
        gallery.backgroundColor = UIColor.clearColor()
        gallery.registerClass(SelfieCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: kAdditionalImageCellReuseIdentifier)
        return gallery
    }

    func logoutBtnTapped() {
        clearLoggedinFlagInUserDefaults()
        clearAPITokensFromKeyChain()

        // Set flag to display Sign In view
        shouldFetchNewData = true
        self.viewDidLoad()
    }

    // 1. Clears the NSUserDefaults flag
    func clearLoggedinFlagInUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("userLoggedIn")
        defaults.synchronize()
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell : SelfieCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kAdditionalImageCellReuseIdentifier, forIndexPath: indexPath) as SelfieCollectionViewCell
        cell.startAnimation()
        if(receivedImages[indexPath.row] as Int == 1){
            cell .setImage(dataArray[indexPath.row] as UIImage)
            cell.stopAnimating()
        }
        return cell
    }

    func updateImage(image : UIImage , index : Int){
        receivedImages[index] = 1
        dataArray[index] = image
        galleryView.reloadData()

    }

     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrl.count;
    }

     func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(75, 75);
    }

    // 3. Clears API Auth token from Keychain
    func clearAPITokensFromKeyChain () {
        // clear API Auth Token
        if let userToken = KeychainAccess.passwordForAccount("Auth_Token", service: "KeyChainService") {
            KeychainAccess.deletePasswordForAccount(userToken, account: "Auth_Token", service: "KeyChainService")
        }

        // clear API Auth Expiry
        if let userTokenExpiryDate = KeychainAccess.passwordForAccount("Auth_Token_Expiry",
            service: "KeyChainService") {
                KeychainAccess.deletePasswordForAccount(userTokenExpiryDate, account: "Auth_Token_Expiry",
                    service: "KeyChainService")
        }
    }
    func setNavigationItems() {
        var logOutBtn = UIBarButtonItem(title: "logout", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("logoutBtnTapped"))
        self.navigationItem.leftBarButtonItem = logOutBtn

        var navCameraBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: Selector("cameraBtnTapped"))
        self.navigationItem.rightBarButtonItem = navCameraBtn
    }

    let httpHelper = HTTPHelper()

    func cameraBtnTapped() {

        var picker =  UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)


    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {

        if (buttonIndex == 0) {

        }
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        // dismiss the image picker controller window
        self.dismissViewControllerAnimated(true, completion: nil)

        var image:UIImage!

        // fetch the selected image
        if picker.allowsEditing {
            image = info.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        } else {
            image = info.objectForKey(UIImagePickerControllerOriginalImage) as UIImage
        }
        var postController = PostViewController()
        postController.setImageview(image)
        self.navigationController?.pushViewController(postController, animated: true)

    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func loadSelfieData () ->NSDictionary? {
        var respUser :NSDictionary!
        let httpRequest = httpHelper.buildRequest("users/my_profile", method: "GET",
            authType: HTTPRequestAuthType.HTTPTokenAuth)

        // Send HTTP request to load existing selfie
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                let errorAlert = UIAlertView(title:"Error", message:errorMessage, delegate:nil,
                    cancelButtonTitle:"OK")
                errorAlert.show()

                return
            }
            var jsonerror:NSError?
            respUser = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as NSDictionary
            var stopBool : Bool

            self.header.text =  NSString(format: "Hi  %@", respUser?.valueForKey("name") as String)
            var count1 =  respUser?.valueForKey("followers") as? NSNumber
            var count2 = respUser?.valueForKey("following") as? NSNumber
            self.follower.text = count1?.stringValue
            self.following.text = count2?.stringValue

        })

      return  respUser
    }

    func submitPost(){
        var micropost = NSDictionary(object: self.postContent.text, forKey: "content")
        var jsonData :NSData = NSJSONSerialization.dataWithJSONObject(micropost, options: NSJSONWritingOptions.PrettyPrinted, error:nil)!

        let httpRequest = httpHelper.buildRequest("microposts", method: "POST",authType: HTTPRequestAuthType.HTTPTokenAuth)

        httpRequest.HTTPBody = jsonData

        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            if error != nil {
                let errorMessage = self.httpHelper.getErrorMessage(error)
                self.displayAlertMessage("Error", alertDescription: errorMessage)

                return
            }

            self.displayAlertMessage("Success", alertDescription: "Post has been submitted")
        })

    }

    override func viewDidLoad() {
        super.viewDidLoad();

        var f = Feed()
        f.newPosts()

        self.header = UILabel()
        self.header.textColor = UIColor.blackColor()

        self.profileHeader = UILabel()
        self.profileHeader.textColor = UIColor.blackColor()
        self.profileHeader.text = "Profile Pics"

        galleryView = self.createGalleryView()
        galleryView.layer.borderColor = UIColor.blackColor().CGColor
        galleryView.layer.borderWidth = 3;

        self.follower = UILabel()
        self.follower.textColor = UIColor.blackColor()

        self.followerHeader = UILabel()
        self.followerHeader.textColor = UIColor.blackColor()
        self.followerHeader.text = "Followers"

        self.following = UILabel()
        self.following.textColor = UIColor.blackColor()

        self.followingHeader = UILabel()
        self.followingHeader.textColor = UIColor.blackColor()
        self.followingHeader.text = "Following"

        self.postHeader = UILabel()
        self.postHeader.textColor = UIColor.blackColor()
        self.postHeader.text = "Add a Post"

        self.postContent = UITextView()
        self.postContent.textColor = UIColor.blackColor()
        self.postContent.layer.borderColor = UIColor.blackColor().CGColor
        self.postContent.layer.borderWidth = 3;
        self.postContent.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)

        postSubmit = UIButton()
        postSubmit.titleLabel?.textColor=UIColor.blackColor()
        postSubmit.setTitle("Submit", forState: UIControlState.Normal)
        postSubmit.backgroundColor=UIColor.grayColor()
        postSubmit.tintColor=UIColor.blackColor()
        postSubmit.addTarget(self, action: "submitPost", forControlEvents: UIControlEvents.TouchUpInside)


        postSubmit.layer.borderColor=UIColor.blackColor().CGColor
        postSubmit.layer.borderWidth=3.0


        self.view.addSubview(galleryView)
        self.view.addSubview(profileHeader)
        self.view.addSubview(self.header)
        self.view.addSubview(follower)
        self.view.addSubview(followerHeader)
        self.view.addSubview(following)
        self.view.addSubview(followingHeader)
        self.view.addSubview(postContent)
        self.view.addSubview(postHeader)
        self.view.addSubview(postSubmit)

        let padding = UIEdgeInsetsMake(30, 30, 30, 30)

        self.header.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).with.offset(padding.top*3) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.width.equalTo(100)
        }

        self.profileHeader.snp_makeConstraints { make in
            make.top.equalTo(self.header.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.width.equalTo(100)
        }


        self.galleryView.snp_makeConstraints { make in
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.top.equalTo(self.profileHeader.snp_bottom) // with is an optional semantic filler
            make.height.equalTo(150)
            make.width.equalTo(self.view.bounds.width/2)
        }

        self.followingHeader.snp_makeConstraints { make in
            make.left.equalTo(self.galleryView.snp_right).with.offset(padding.left)
            make.top.equalTo(self.header.snp_top) // with is an optional semantic filler
        }
        self.following.snp_makeConstraints { make in
            make.left.equalTo(self.galleryView.snp_right).with.offset(padding.left)
            make.top.equalTo(self.followingHeader.snp_bottom) // with is an optional semantic filler
        }
        self.followerHeader.snp_makeConstraints { make in
            make.left.equalTo(self.followingHeader.snp_right).with.offset(padding.left)
            make.top.equalTo(self.header.snp_top) // with is an optional semantic filler
        }
        self.follower.snp_makeConstraints { make in
            make.left.equalTo(self.followingHeader.snp_right).with.offset(padding.left)
            make.top.equalTo(self.followerHeader.snp_bottom) // with is an optional semantic filler
        }

        self.postHeader.snp_makeConstraints { make in
            make.left.equalTo(self.galleryView.snp_right).with.offset(padding.left)
            make.top.equalTo(self.profileHeader.snp_top) // with is an optional semantic filler
        }

        self.postContent.snp_makeConstraints { make in
            make.left.equalTo(self.galleryView.snp_right).with.offset(padding.left)
            make.top.equalTo(self.postHeader.snp_bottom)
            make.right.equalTo(self.view.snp_right).with.offset(-padding.left*2)
            make.height.equalTo(90)
        }
        self.postSubmit.snp_makeConstraints { make in
            make.left.equalTo(self.galleryView.snp_right).with.offset(padding.left)
            make.top.equalTo(self.postContent.snp_bottom).with.offset(padding.top)
            make.bottom.equalTo(self.galleryView.snp_bottom)
            make.width.equalTo(80)
        }


        let defaults = NSUserDefaults.standardUserDefaults()

        // is user is not signed in display controller to sign in or sign up
        if defaults.objectForKey("userLoggedIn") == nil {
            self.navigationController?.viewControllers = [LoginViewController()]
        } else {
            // check if API token has expired
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let userTokenExpiryDate : NSString? = KeychainAccess.passwordForAccount("Auth_Token_Expiry",
                service: "KeyChainService")
            let dateFromString : NSDate? = dateFormatter.dateFromString(userTokenExpiryDate!)
            let now = NSDate()

            let comparision = now.compare(dateFromString!)

            // check if should fetch new data
            if shouldFetchNewData {
                shouldFetchNewData = false
                self.setNavigationItems()
            }
            
            // logout and ask user to sign in again if token is expired
            if comparision != NSComparisonResult.OrderedAscending {
                self.logoutBtnTapped()
            }

            let defaults = NSUserDefaults.standardUserDefaults()
            let userId : NSNumber? = defaults.objectForKey("Id") as? NSNumber
            loadSelfieData()

            let httpRequest = httpHelper.buildRequest("photos", method: "GET",
                authType: HTTPRequestAuthType.HTTPTokenAuth)

            httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
                // Display error
                if error != nil {
                    let errorMessage = error.description
                    self.displayAlertMessage("Error", alertDescription: errorMessage)

                    return
                }

                var jsonerror:NSError?
                let responseDict = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as NSArray
                var stopBool : Bool

                for (index,imageDict) in enumerate(responseDict){
                    self.imageUrl.addObject(imageDict["image_url"] as String);
                }

                self .setImages(self.imageUrl)


            })

        }

    }

    func setImages(imageUrls:NSArray){
        for(var i = 0 ; i<imageUrls.count;i++){
            receivedImages[i] = 0;
            dataArray[i] = UIImage(named: "missing")!
            galleryView.reloadData()

            let httpRequest = httpHelper.buildRequest("photos/pic?id=\(imageUrls[i])", method: "GET",
                authType: HTTPRequestAuthType.HTTPTokenAuth)

            // Send HTTP request to load existing selfie
            httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
                // Display error
                if error != nil {
                    let errorMessage = self.httpHelper.getErrorMessage(error)
                    let errorAlert = UIAlertView(title:"Error", message:errorMessage, delegate:nil,
                        cancelButtonTitle:"OK")
                    errorAlert.show()

                    return
                }
                var jsonerror:NSError?
                var  respData = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.allZeros, error:&jsonerror) as NSDictionary
                var stopBool : Bool

                var imageData  = NSData(base64EncodedString: respData["data"] as String, options: NSDataBase64DecodingOptions.allZeros)
                
                var image = UIImage(data: imageData!)

                self.updateImage(image!, index: self.countOfRecieved++)
            })


        }
    }


    func displayAlertMessage(alertTitle:NSString, alertDescription:NSString) -> Void {
        // hide activityIndicator view and display alert message
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }

}

