import UIKit
import Snap
class LoginViewController:UIViewController {

    var emailLabel :UILabel!
    var passwordLabel :UILabel!
    var email :UITextField!
    var password :UITextField!
    var loginButton :UIButton!
    var signUpButton :UIButton!
    var loginViewModel :LoginViewModel!

override func viewDidLoad() {
    super.viewDidLoad()
    loginViewModel = LoginViewModel()

    emailLabel = UILabel();
    emailLabel.text = "Email :"
    passwordLabel = UILabel();
    passwordLabel.text="Password :"
    email = UITextField();
    email.layer.borderColor=UIColor.blackColor().CGColor
    email.layer.borderWidth=3.0;
    password = UITextField();
    password.layer.borderColor=UIColor.blackColor().CGColor
    password.layer.borderWidth=3.0;


    loginButton = UIButton()
    loginButton.titleLabel?.textColor=UIColor.blackColor()
    loginButton.setTitle("Login", forState: UIControlState.Normal)
    loginButton.backgroundColor=UIColor.grayColor()
    loginButton.tintColor=UIColor.blackColor()
    loginButton.addTarget(self, action: "makeSignInRequest", forControlEvents: UIControlEvents.TouchUpInside)

    signUpButton = UIButton()
    signUpButton.titleLabel?.textColor=UIColor.blackColor()
    signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
    signUpButton.backgroundColor=UIColor.grayColor()
    signUpButton.tintColor=UIColor.blackColor()
    signUpButton.addTarget(self, action: "makeSignUpRequest", forControlEvents: UIControlEvents.TouchUpInside)


    loginButton.layer.borderColor=UIColor.blackColor().CGColor
    loginButton.layer.borderWidth=3.0

    signUpButton.layer.borderColor=UIColor.blackColor().CGColor
    signUpButton.layer.borderWidth=3.0


    self.view .addSubview(emailLabel)
    self.view .addSubview(email)
    self.view .addSubview(password)
    self.view .addSubview(passwordLabel)
    self.view .addSubview(loginButton)
    self.view .addSubview(signUpButton)

    let padding = UIEdgeInsetsMake(30, 30, 30, 30)

    emailLabel.snp_makeConstraints { make in
        make.top.equalTo(self.view.snp_top).with.offset(padding.top*3) // with is an optional semantic filler
        make.left.equalTo(self.view.snp_left).with.offset(padding.left)
        make.height.equalTo(50)
        make.width.equalTo(100)

    }
    email.snp_makeConstraints { make in
        make.top.equalTo(self.view.snp_top).with.offset(padding.top*3) // with is an optional semantic filler
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

    loginButton.snp_makeConstraints { make in
        make.top.equalTo(self.passwordLabel.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
        make.left.equalTo(self.view.snp_left).with.offset(padding.left)
        make.height.equalTo(50)
        make.width.equalTo(70)
    }

    signUpButton.snp_makeConstraints { make in
        make.top.equalTo(self.passwordLabel.snp_bottom).with.offset(padding.top) // with is an optional semantic filler
        make.left.equalTo(self.loginButton.snp_right).with.offset(padding.left)
        make.height.equalTo(50)
        make.width.equalTo(70)
    }




}

    let httpHelper = HTTPHelper()

    func makeSignInRequest() {
        // Create HTTP request and set request Body
        let httpRequest = httpHelper.buildRequest("users/sign_in?email="+self.email.text+"&password="+self.password.text, method: "GET",
            authType: HTTPRequestAuthType.HTTPBasicAuth)
//        httpRequest.HTTPBody = "{\"email\":\"\(self.email.text)\",\"password\":\"\(self.password.text)\"}".dataUsingEncoding(NSUTF8StringEncoding);

        httpHelper.sendRequest(httpRequest, completion: {(data:NSData!, error:NSError!) in
            // Display error
            if error != nil {
                let errorMessage = error.description
                self.displayAlertMessage("Error", alertDescription: errorMessage)

                return
            }

            self.updateUserLoggedInFlag()

            var jsonerror:NSError?
            let responseDict = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments, error:&jsonerror) as NSDictionary
            var stopBool : Bool

            // save API AuthToken and ExpiryDate in Keychain
            self.saveApiTokenInKeychain(responseDict)
        })
    }

    func makeSignUpRequest()
    {
        self.navigationController?.pushViewController(SignupViewController(), animated: false)

    }

    func updateUserLoggedInFlag() {
        // Update the NSUserDefaults flag
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("loggedIn", forKey: "userLoggedIn")
        defaults.synchronize()
    }



    func displayAlertMessage(alertTitle:NSString, alertDescription:NSString) -> Void {
        // hide activityIndicator view and display alert message
        let errorAlert = UIAlertView(title:alertTitle, message:alertDescription, delegate:nil, cancelButtonTitle:"OK")
        errorAlert.show()
    }

    func saveApiTokenInKeychain(tokenDict:NSDictionary) {
        // Store API AuthToken and AuthToken expiry date in KeyChain

        for (key, value) in tokenDict {
            if key as NSString == "id" {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(value, forKey: "Id")
                defaults.synchronize()
            }

           if key as NSString == "auth_token" {
               KeychainAccess.setPassword(value as String, account: "Auth_Token", service: "KeyChainService")
           }
           
           if key as NSString == "token_expiry" {
               KeychainAccess.setPassword(value as String, account: "Auth_Token_Expiry", service: "KeyChainService")
           }
        }

        var controller = ProfileViewController()


        self.navigationController?.viewControllers = [controller]

    }

}

