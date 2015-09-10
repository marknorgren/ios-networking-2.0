//
//  MovieDetailViewController.swift
//  MyFavoriteMovies
//
//  Created by Jarrod Parkes on 1/23/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - MovieDetailViewController: UIViewController

class MovieDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var toggleFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var toggleWatchlistButton: UIBarButtonItem!
    
    var movie: TMDBMovie?
    var isFavorite = false
    var isWatchlist = false
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.translucent = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
        
        /* Set the UI, then check if the movie is a favorite/watchlist and update the buttons! */
        if let movie = movie {
            
            /* Set the title */
            if let releaseYear = movie.releaseYear {
                self.navigationItem.title = "\(movie.title) (\(releaseYear))"
            } else {
                self.navigationItem.title = "\(movie.title)"
            }
            
            /* Setting some default UI ... */
            posterImageView.image = UIImage(named: "MissingPoster")
            isFavorite = false
            
            /* Is the movie a favorite? */
            TMDBClient.sharedInstance().getFavoriteMovies { movies, error in
                if let movies = movies {
                    
                    for movie in movies {
                        if movie.id == self.movie!.id {
                            self.isFavorite = true
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if self.isFavorite {
                            self.toggleFavoriteButton.tintColor = nil
                        } else {
                            self.toggleFavoriteButton.tintColor = UIColor.blackColor()
                        }
                    }
                } else {
                    print(error)
                }
            }
            
            /* Is the movie on the watchlist? */
            TMDBClient.sharedInstance().getWatchlistMovies { movies, error in
                if let movies = movies {
                    
                    for movie in movies {
                        if movie.id == self.movie!.id {
                            self.isWatchlist = true
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if self.isWatchlist {
                            self.toggleWatchlistButton.tintColor = nil
                        } else {
                            self.toggleWatchlistButton.tintColor = UIColor.blackColor()
                        }
                    }
                } else {
                    print(error)
                }
            }
            
            /* Set the poster image */
            if let posterPath = movie.posterPath {
                TMDBClient.sharedInstance().taskForGETImage(TMDBClient.PosterSizes.DetailPoster, filePath: posterPath, completionHandler: { (imageData, error) in
                    if let image = UIImage(data: imageData!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.activityIndicator.alpha = 0.0
                            self.activityIndicator.stopAnimating()
                            self.posterImageView.image = image
                        }
                    }
                })
            } else {
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func toggleFavoriteButtonTouchUp(sender: AnyObject) {
        if isFavorite {
            TMDBClient.sharedInstance().postToFavorites(movie!, favorite: false) { status_code, error in
                if let err = error {
                    print(err)
                } else {
                    if status_code == 13 {
                        self.isFavorite = false
                        dispatch_async(dispatch_get_main_queue()) {
                            self.toggleFavoriteButton.tintColor = UIColor.blackColor()
                        }
                    } else {
                        print("Unexpected status code \(status_code)")
                    }
                }
            }
        } else {
            TMDBClient.sharedInstance().postToFavorites(movie!, favorite: true) { status_code, error in
                if let err = error {
                    print(err)
                } else {
                    if status_code == 1 || status_code == 12 {
                        self.isFavorite = true
                        dispatch_async(dispatch_get_main_queue()) {
                            self.toggleFavoriteButton.tintColor = nil
                        }
                    } else {
                        print("Unexpected status code \(status_code)")
                    }
                }
            }
        }
    }
    
    @IBAction func toggleWatchlistButtonTouchUp(sender: AnyObject) {
        if isWatchlist {
            TMDBClient.sharedInstance().postToWatchlist(movie!, watchlist: false) { status_code, error in
                if let err = error {
                    print(err)
                } else {
                    if status_code == 13 {
                        self.isWatchlist = false
                        dispatch_async(dispatch_get_main_queue()) {
                            self.toggleWatchlistButton.tintColor = UIColor.blackColor()
                        }
                    } else {
                        print("Unexpected status code \(status_code)")
                    }
                }
            }
        } else {
            TMDBClient.sharedInstance().postToWatchlist(movie!, watchlist: true) { status_code, error in
                if let err = error {
                    print(err)
                } else {
                    if status_code == 1 || status_code == 12 {
                        self.isWatchlist = true
                        dispatch_async(dispatch_get_main_queue()) {
                            self.toggleWatchlistButton.tintColor = nil
                        }
                    } else {
                        print("Unexpected status code \(status_code)")
                    }
                }
            }
        }
    }
}