//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Petrina Koh on 6/30/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        
        
    }
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    
    var post: Post? {
        didSet {
            // 1 whenever a new value is assigned to the post property, we use optional binding to check whether the new value is nil
            if let post = post {
                // 2 if the value is not nil
                // bind the image of the post to the 'postImage' view
                // whenever post.image updates, the displayed image of postImageView will update
                post.image ->> postImageView
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
