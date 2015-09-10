//
//  ViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 1/29/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!

    @IBAction func searchPhotosByPhraseButtonTouchUp(sender: AnyObject) {
        print("Implement this function...")
    }
    
    @IBAction func searchPhotosByLatLonButtonTouchUp(sender: AnyObject) {
        print("Will implement this function in a later step...")
    }
}