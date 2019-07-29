//
//  ViewController.swift
//  jsontest
//
//  Created by Alex Asher on 23/07/2019.
//  Copyright © 2019 Appsher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var allLocations = Locations()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationParser.getLocations() { (response) in
            if response.count > 0 {
                self.allLocations = response
            } else {
                //error
            }
        }
        
        print(allLocations)
    }
    
    func attemptLocationsFetch() {
        LocationParser.getLocations() { (response) in
            if response.count > 0 {
                self.allLocations = response
            } else {
                //error
            }
        }
    }
}

