//
//  PostSectionHeaderView.swift
//  Makestagram
//
//  Created by Petrina Koh on 7/8/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class PostSectionHeaderView: UITableViewCell {
    
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var post: Post? {
        didSet {
            if let post = post {
                usernameLabel.text = post.user?.username
                
                // add timestamp that shows how long ago post was created
                postTimeLabel.text = post.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
            }
        }
    }

}
