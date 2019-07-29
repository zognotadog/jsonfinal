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
    
        allLocations = LocationParser.getLocations()
        print(allLocations)
    }

}

