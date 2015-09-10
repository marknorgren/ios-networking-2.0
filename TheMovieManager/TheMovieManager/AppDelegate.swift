//
//  AppDelegate.swift
//  TheMovieManager
//
//  Created by Jarrod Parkes on 2/11/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    
    var window: UIWindow?
    
    /* Constants for TheMovieDB */
    let apiKey = "ENTER_YOUR_API_KEY_HERE"
    let baseURLString = "http://api.themoviedb.org/3/"
    let baseURLSecureString = "https://api.themoviedb.org/3/"
    
    /* Need these for login */
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    /* Configuration for TheMovieDB, we'll take care of this for you =)... */
    var config = TMDBConfig()
    
    // MARK: UIApplicationDelegate
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /* If necessary, update the configuration */
        config.updateIfDaysSinceUpdateExceeds(7)
        
        return true
    }
}

// MARK: - Escape HTML Parameters

extension AppDelegate {
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
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