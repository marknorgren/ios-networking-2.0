//
//  Movie.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - Movie

struct Movie {
    
    // MARK: Properties
    
    var title = ""
    var id = 0
    var posterPath: String? = nil
    
    // MARK: Initializers
    
    init(dictionary: [String : AnyObject]) {
        title = dictionary["title"] as! String
        id = dictionary["id"] as! Int
        posterPath = dictionary["poster_path"] as? String
    }
    
    static func moviesFromResults(results: [[String : AnyObject]]) -> [Movie] {
        
        var movies = [Movie]()
        
        /* Iterate through array of dictionaries; each Movie is a dictionary */
        for result in results {
            movies.append(Movie(dictionary: result))
        }
        
        return movies
    }
    
}