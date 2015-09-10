//
//  TMDBClient.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import Foundation

// MARK: - TMDBClient: NSObject

class TMDBClient : NSObject {
    
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession
    
    /* Configuration object */
    var config = TMDBConfig()
    
    /* Authentication state */
    var sessionID : String? = nil
    var userID : Int? = nil
    
    // MARK: Initializers
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    // MARK: GET
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var mutableParameters = parameters
        mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey
        
        /* 2/3. Build the URL and configure the request */
        let urlString = Constants.BaseURLSecure + method + TMDBClient.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        /* 4. Make the request */
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
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            TMDBClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGETImage(size: String, filePath: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        
        /* 1. Set the parameters */
        // There are none...
        
        /* 2/3. Build the URL and configure the request */
        let baseURL = NSURL(string: config.baseImageURLString)!
        let url = baseURL.URLByAppendingPathComponent(size).URLByAppendingPathComponent(filePath)
        let request = NSURLRequest(URL: url)
        
        /* 4. Make the request */
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
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandler(imageData: data, error: nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    // MARK: POST
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        /* 1. Set the parameters */
        /* 2/3. Build the URL and configure the request */
        /* 4. Make the request */
        /* 5/6. Parse the data and use the data (happens in completion handler) */
        /* 7. Start the request */
        
        return NSURLSessionDataTask()
    }
    
    /* Use this unFavoriteButtonTouchUpInside as a reference if you need it 😄 */
    
//    func unFavoriteButtonTouchUpInside(sender: AnyObject) {
//        
//        /* TASK: Remove movie as favorite, then update favorite buttons */
//        
//        /* 1. Set the parameters */
//        let methodParameters = [
//            "api_key": appDelegate.apiKey,
//            "session_id": appDelegate.sessionID!
//        ]
//        
//        /* 2. Build the URL */
//        let urlString = appDelegate.baseURLSecureString + "account/\(appDelegate.userID!)/favorite" + appDelegate.escapedParameters(methodParameters)
//        let url = NSURL(string: urlString)!
//        
//        /* 3. Configure the request */
//        let request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.HTTPBody = "{\"media_type\": \"movie\",\"media_id\": \(self.movie!.id),\"favorite\":false}".dataUsingEncoding(NSUTF8StringEncoding)
//        
//        /* 4. Make the request */
//        let task = session.dataTaskWithRequest(request) { (data, response, error) in
//            
//            /* GUARD: Was there an error? */
//            guard (error == nil) else {
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
//            /* GUARD: Did we receive the correct status_code? */
//            guard let status_code = parsedResult["status_code"] as? Int where status_code == 13 else {
//                print("Could not find key 'status_code' or unrecognized 'status_code' in  \(parsedResult)")
//                return
//            }
//            
//            /* 6. Use the data! */
//            dispatch_async(dispatch_get_main_queue()) {
//                self.unFavoriteButton.hidden = true
//                self.favoriteButton.hidden = false
//            }
//        }
//        
//        /* 7. Start the request */
//        task.resume()
//    }
    
    // MARK: Helpers
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
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
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> TMDBClient {
        
        struct Singleton {
            static var sharedInstance = TMDBClient()
        }
        
        return Singleton.sharedInstance
    }
}