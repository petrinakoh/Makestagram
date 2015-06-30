//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Petrina Koh on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {
    
    var photoTakingHelper: PhotoTakingHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            println("received a callback")
        }
    }

}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
    }
    
}
