//
//  ViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 1/29/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - Globals

let BASE_URL = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY = "ENTER_YOUR_API_KEY_HERE"
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    // MARK: Actions
    
    @IBAction func searchPhotosByPhraseButtonTouchUp(sender: AnyObject) {
        
        /* Added from student request -- hides keyboard after searching */
        self.dismissAnyVisibleKeyboards()
        
        let methodArguments: [String: String!] = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": self.phraseTextField.text,
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        getImageFromFlickrBySearch(methodArguments)
    }
    
    @IBAction func searchPhotosByLatLonButtonTouchUp(sender: AnyObject) {
        
        /* Added from student request -- hides keyboard after searching */
        self.dismissAnyVisibleKeyboards()
        
        print("Will implement this function in a later step...")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Add tap recognizer to dismiss keyboard */
        self.addKeyboardDismissRecognizer()
        
        /* Subscribe to keyboard events so we can adjust the view to show hidden controls */
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Remove tap recognizer */
        self.removeKeyboardDismissRecognizer()
        
        /* Unsubscribe to all keyboard events */
        self.unsubscribeToKeyboardNotifications()
    }
    
    // MARK: Show/Hide Keyboard
    
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
        if self.photoImageView.image != nil {
            self.defaultLabel.alpha = 0.0
        }
        if self.view.frame.origin.y == 0.0 {
            self.view.frame.origin.y -= self.getKeyboardHeight(notification) / 2
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.photoImageView.image == nil {
            self.defaultLabel.alpha = 1.0
        }
        if self.view.frame.origin.y != 0.0 {
            self.view.frame.origin.y += self.getKeyboardHeight(notification) / 2
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: Flickr API
    
    func getImageFromFlickrBySearch(methodArguments: [String : AnyObject]) {
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
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
            
            /* Parse the data! */
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                parsedResult = nil
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error? */
            guard let stat = parsedResult["stat"] as? String where stat == "ok" else {
                print("Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Is "photos" key in our result? */
            guard let photosDictionary = parsedResult["photos"] as? NSDictionary else {
                print("Cannot find keys 'photos' in \(parsedResult)")
                return
            }
            
            /* GUARD: Is the "total" key in photosDictionary? */
            guard let totalPhotos = (photosDictionary["total"] as? NSString)?.integerValue else {
                print("Cannot find key 'total' in \(photosDictionary)")
                return
            }
            
            if totalPhotos > 0 {
                
                /* GUARD: Is the "photo" key in photosDictionary? */
                guard let photosArray = photosDictionary["photo"] as? [[String: AnyObject]] else {
                    print("Cannot find key 'photo' in \(photosDictionary)")
                    return
                }
                
                let randomPhotoIndex = Int(arc4random_uniform(UInt32(photosArray.count)))
                let photoDictionary = photosArray[randomPhotoIndex] as [String: AnyObject]
                let photoTitle = photoDictionary["title"] as? String /* non-fatal */
                
                /* GUARD: Does our photo have a key for 'url_m'? */
                guard let imageUrlString = photoDictionary["url_m"] as? String else {
                    print("Cannot find key 'url_m' in \(photoDictionary)")
                    return
                }
                
                let imageURL = NSURL(string: imageUrlString)
                
                if let imageData = NSData(contentsOfURL: imageURL!) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.defaultLabel.alpha = 0.0
                        self.photoImageView.image = UIImage(data: imageData)
                        self.photoTitleLabel.text = photoTitle ?? "(Untitled)"
                    })
                } else {
                    print("Image does not exist at \(imageURL)")
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.photoTitleLabel.text = "No Photos Found. Search Again."
                    self.defaultLabel.alpha = 1.0
                    self.photoImageView.image = nil
                })
            }
        }
        
        task.resume()
    }
    
    // MARK: Escape HTML Parameters
    
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
}

// MARK: - ViewController (Keyboard Fix)

/* This extension was added as a fix based on student comments */
extension ViewController {
    func dismissAnyVisibleKeyboards() {
        if phraseTextField.isFirstResponder() || latitudeTextField.isFirstResponder() || longitudeTextField.isFirstResponder() {
            self.view.endEditing(true)
        }
    }
}