import UIKit
import Snap
class SignupViewController:UIViewController {


    var emailLabel :UILabel!
    var passwordLabel :UILabel!
    var email :UITextField!
    var password :UITextField!
    var nameLabel :UILabel!
    var name :UITextField!

    var signUpButton :UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel = UILabel();
        nameLabel.text = "Name :"
        emailLabel = UILabel();
        emailLabel.text = "Email :"
        passwordLabel = UILabel();
        passwordLabel.text="Password :"

        name = UITextField();
        name.layer.borderColor=UIColor.blackColor().CGColor
        name.layer.borderWidth=3.0;

        email = UITextField();
        email.layer.borderColor=UIColor.blackColor().CGColor
        email.layer.borderWidth=3.0;
        password = UITextField();
        password.layer.borderColor=UIColor.blackColor().CGColor
        password.layer.borderWidth=3.0;
        signUpButton = UIButton()
        signUpButton.titleLabel?.textColor=UIColor.blackColor()
        signUpButton.setTitle("Signup", forState: UIControlState.Normal)
        signUpButton.backgroundColor=UIColor.grayColor()
        signUpButton.tintColor=UIColor.blackColor()
        signUpButton.addTarget(self, action: "makeSignUpRequest", forControlEvents: UIControlEvents.TouchUpInside)

        signUpButton.layer.borderColor=UIColor.blackColor().CGColor
        signUpButton.layer.borderWidth=3.0

        self.view .addSubview(nameLabel)
        self.view .addSubview(name)
        self.view .addSubview(emailLabel)
        self.view .addSubview(email)
        self.view .addSubview(password)
        self.view .addSubview(passwordLabel)
        self.view .addSubview(signUpButton)

        let padding = UIEdgeInsetsMake(30, 30, 30, 30)

        nameLabel.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).with.offset(padding.top*3) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(100)

        }
        name.snp_makeConstraints { make in
            make.top.equalTo(self.view.snp_top).with.offset(padding.top*3) // with is an optional semantic filler
            make.left.equalTo(self.emailLabel.snp_right).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(150)

        }


        emailLabel.snp_makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(100)

        }
        email.snp_makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.emailLabel.snp_right).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(150)

        }

        passwordLabel.snp_makeConstraints { make in
            make.top.equalTo(self.emailLabel.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }

        password.snp_makeConstraints { make in
            make.top.equalTo(self.emailLabel.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.passwordLabel.snp_right).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }

        signUpButton.snp_makeConstraints { make in
            make.top.equalTo(self.passwordLabel.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
            make.left.equalTo(self.view.snp_left).with.offset(padding.left)
            make.height.equalTo(50)
            make.width.equalTo(70)
        }
    }

    let httpHelper = HTTPHelper()

    func makeSignUpRequest() {

        var user = User()
        user.name = name.text
        user.email = email.text
        user.password = password.text
        user.password_confirmation = password.text

        var jsonData :NSData = NSJSONSerialization.dataWithJSONObject(self.createPostdata(user), options: NSJSONWritingOptions.PrettyPrinted, error:nil)!

        let httpRequest = httpHelper.buildRequest("users/sign_up", method: "POST",authType: HTTPRequestAuthType.HTTPBasicAuth)

        httpRequest.HTTPBody = jsonData

        // 4. Send the request
        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
        if error != nil {
        let errorMessage = self.httpHelper.getErrorMessage(error)
        self.displayAlertMessage("Error", alertDescription: errorMessage)

        return
        }

        self.displayAlertMessage("Success", alertDescription: "Account has been created")
        })

    }

    func createPostdata(user:User) -> NSDictionary{
        var userDict :NSMutableDictionary! = NSMutableDictionary();
        var postData :NSMutableDictionary! = NSMutableDictionary();
        userDict.setValue(name.text, forKey: "name")
        userDict.setValue(email.text, forKey: "email")
        userDict.setValue(password.text, forKey: "password")
        userDict.setValue(password.text, forKey: "password_confirmation")
        postData.setValue(userDict, forKey: "user")

        return postData
    }

    func displayAlertMessage(alertTitle:NSString, alertDescription:NSString) -> Void {
        // hide activityIndicator view and display alert message
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }


}

