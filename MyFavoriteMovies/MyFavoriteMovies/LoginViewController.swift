//
//  LoginViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var headerTextLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var backgroundGradient: CAGradientLayer? = nil
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    /* Based on student comments, this was added to help with smaller resolution devices */
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure the UI */
        self.configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Login
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        if usernameTextField.text!.isEmpty {
            debugTextLabel.text = "Username Empty."
        } else if passwordTextField.text!.isEmpty {
            debugTextLabel.text = "Password Empty."
        } else {
            
            /*
                Steps for Authentication...
                https://www.themoviedb.org/documentation/api/sessions
                
                Step 1: Create a new request token
                Step 2: Ask the user for permission via the API ("login")
                Step 3: Create a session ID
                
                Extra Steps...
                Step 4: Go ahead and get the user id ;)
                Step 5: Got everything we need, go to the next view!
            
            */
            self.getRequestToken()
        }
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.debugTextLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MoviesTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    // MARK: TheMovieDB
    
    func getRequestToken() {
        
        /* TASK: Get a request token, then store it (appDelegate.requestToken) and login with the token */
        
        /* 1. Set the parameters */
        let methodParameters = [
            "key": "value"
        ]
        
        /* 2. Build the URL */
        let urlString = "BUILD_THE_URL" + appDelegate.escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("getRequestToken: Print an error message")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            /* 5. Parse the data */
            print("getRequestToken: Parse the data \(data)")
            
            /* 6. Use the data! */
            print("getRequestToken: Use the data")
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    func loginWithToken(requestToken: String) {
        
        /* TASK: Login, then get a session id */
        /* 1. Set the parameters */
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
    }
    
    func getSessionID(requestToken: String) {
        
        /* TASK: Get a session ID, then store it (appDelegate.sessionID) and get the user's id */
        /* 1. Set the parameters */
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
    }
    
    func getUserID(session_id : String) {
        
        /* TASK: Get the user's ID, then store it (appDelegate.userID) for future use and go to next view! */
        /* 1. Set the parameters */
        /* 2. Build the URL */
        /* 3. Configure the request */
        /* 4. Make the request */
        /* 5. Parse the data */
        /* 6. Use the data! */
        /* 7. Start the request */
    }
}

// MARK: - LoginViewController (Configure UI)

extension LoginViewController {
    
    func configureUI() {
        
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).CGColor
        self.backgroundGradient = CAGradientLayer()
        self.backgroundGradient!.colors = [colorTop, colorBottom]
        self.backgroundGradient!.locations = [0.0, 1.0]
        self.backgroundGradient!.frame = view.frame
        self.view.layer.insertSublayer(self.backgroundGradient!, atIndex: 0)
        
        /* Configure header text label */
        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        headerTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure email textfield */
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        usernameTextField.leftView = emailTextFieldPaddingView
        usernameTextField.leftViewMode = .Always
        usernameTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        usernameTextField.backgroundColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        usernameTextField.textColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernameTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* Configure password textfield */
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always
        passwordTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        passwordTextField.backgroundColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        passwordTextField.textColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* Configure debug text label */
        headerTextLabel.font = UIFont(name: "AvenirNext-Medium", size: 20)
        headerTextLabel.textColor = UIColor.whiteColor()
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
}

// MARK: - LoginViewController (Show/Hide Keyboard)

/* This code has been added in response to student comments */
extension LoginViewController {
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}
