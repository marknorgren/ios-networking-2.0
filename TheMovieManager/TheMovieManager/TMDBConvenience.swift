//
//  TMDBConvenience.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit
import Foundation

// MARK: - TMDBClient (Convenient Resource Methods)

extension TMDBClient {
    
    // MARK: Authentication (GET) Methods
    /*
    Steps for Authentication...
    https://www.themoviedb.org/documentation/api/sessions
    
    Step 1: Create a new request token
    Step 2a: Ask the user for permission via the website
    Step 3: Create a session ID
    Bonus Step: Go ahead and get the user id 😎!
    */
    func authenticateWithViewController(hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        /* Chain completion handlers for each request so that they run one after the other */
        self.getRequestToken() { (success, requestToken, errorString) in
            
            if success {
                print("requestToken: \(requestToken)")
            } else {
                completionHandler(success: success, errorString: errorString)
            }
        }
    }
    
    func getRequestToken(completionHandler: (success: Bool, requestToken: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [String: AnyObject]()
        
        /* 2. Make the request */
        taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (JSONResult, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
            } else {
                if let requestToken = JSONResult[TMDBClient.JSONResponseKeys.RequestToken] as? String {
                    completionHandler(success: true, requestToken: requestToken, errorString: nil)
                } else {
                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(JSONResult)")
                    completionHandler(success: false, requestToken: nil, errorString: "Login Failed (Request Token).")
                }
            }
        }
    }
    
    // TODO: Make the following methods into convenience functions!
    
//    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
//    func loginWithToken(requestToken: String?, hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
//        
//        let authorizationURL = NSURL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
//        let request = NSURLRequest(URL: authorizationURL!)
//        let webAuthViewController = hostViewController.storyboard!.instantiateViewControllerWithIdentifier("TMDBAuthViewController") as! TMDBAuthViewController
//        webAuthViewController.urlRequest = request
//        webAuthViewController.requestToken = requestToken
//        webAuthViewController.completionHandler = completionHandler
//        
//        let webAuthNavigationController = UINavigationController()
//        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
//        
//        dispatch_async(dispatch_get_main_queue(), {
//            hostViewController.presentViewController(webAuthNavigationController, animated: true, completion: nil)
//        })
//    }
    
//    func getSessionID(requestToken: String) {
//        
//        /* TASK: Get a session ID, then store it (appDelegate.sessionID) and get the user's id */
//        
//        /* 1. Set the parameters */
//        let methodParameters = [
//            "api_key": appDelegate.apiKey,
//            "request_token": requestToken
//        ]
//        
//        /* 2. Build the URL */
//        let urlString = appDelegate.baseURLSecureString + "authentication/session/new" + appDelegate.escapedParameters(methodParameters)
//        let url = NSURL(string: urlString)!
//        
//        /* 3. Configure the request */
//        let request = NSMutableURLRequest(URL: url)
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        /* 4. Make the request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.debugTextLabel.text = "Login Failed (Session ID)."
//                }
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
//                } else if let response = response {
//                    print("Your request returned an invalid response! Response: \(response)!")
//                } else {
//                    print("Your request returned an invalid response!")
//                }
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//            
//            /* 5. Parse the data */
//            let parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            } catch {
//                parsedResult = nil
//                print("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            /* GUARD: Did TheMovieDB return an error? */
//            guard (parsedResult.objectForKey("status_code") == nil) else {
//                print("TheMovieDB returned an error. See the status_code and status_message in \(parsedResult)")
//                return
//            }
//            
//            /* GUARD: Is the "sessionID" key in parsedResult? */
//            guard let sessionID = parsedResult["session_id"] as? String else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.debugTextLabel.text = "Login Failed (Session ID)."
//                }
//                print("Cannot find key 'sessionID' in \(parsedResult)")
//                return
//            }
//            
//            /* 6. Use the data! */
//            self.appDelegate.sessionID = sessionID
//            self.getUserID(self.appDelegate.sessionID!)
//        }
//        
//        /* 7. Start the request */
//        task.resume()
//    }
    
//    func getUserID(session_id : String) {
//        
//        /* TASK: Get the user's ID, then store it (appDelegate.userID) for future use and go to next view! */
//        
//        /* 1. Set the parameters */
//        let methodParameters = [
//            "api_key": appDelegate.apiKey,
//            "session_id": session_id
//        ]
//        
//        /* 2. Build the URL */
//        let urlString = appDelegate.baseURLSecureString + "account" + appDelegate.escapedParameters(methodParameters)
//        let url = NSURL(string: urlString)!
//        
//        /* 3. Configure the request */
//        let request = NSMutableURLRequest(URL: url)
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        /* 4. Make the request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.debugTextLabel.text = "Login Failed (User ID)."
//                }
//                print("There was an error with your request: \(error)")
//                return
//            }
//            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
//                } else if let response = response {
//                    print("Your request returned an invalid response! Response: \(response)!")
//                } else {
//                    print("Your request returned an invalid response!")
//                }
//                return
//            }
//            
//            /* GUARD: Was there any data returned? */
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//            
//            /* 5. Parse the data */
//            let parsedResult: AnyObject!
//            do {
//                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
//            } catch {
//                parsedResult = nil
//                print("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//            
//            /* GUARD: Did TheMovieDB return an error? */
//            guard (parsedResult.objectForKey("status_code") == nil) else {
//                print("TheMovieDB returned an error. See the status_code and status_message in \(parsedResult)")
//                return
//            }
//            
//            /* GUARD: Is the "sessionID" key in parsedResult? */
//            guard let userID = parsedResult!["id"] as? Int else {
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.debugTextLabel.text = "Login Failed (User ID)."
//                }
//                print("Cannot find key 'id' in \(parsedResult)")
//                return
//            }
//            
//            /* 6. Use the data! */
//            self.appDelegate.userID = userID
//            self.completeLogin()
//        }
//        
//        /* 7. Start the request */
//        task.resume()
//    }
}