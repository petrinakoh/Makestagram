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
                
                // bind the likeBond to update like label and button when likes change
                post.likes ->> likeBond
            }
        }
    }
    

    var likeBond: Bond<[PFUser]?>!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 1 create a new bond that takes a trailing closure when it is initialized
        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
            
            // 2 check if we have received a value for likeList or if we received nil
            if let likeList = likeList {
                // 3 update likesLabel to display list of usernames of users that liked post
                self.likesLabel.text = self.stringFromUserList(likeList)
                //4 set state of like button (the heart)
                self.likeButton.selected = contains(likeList, PFUser.currentUser()!)
                //5 if no one likes current post, hide the small heart icon displayed on left
                self.likesIconImageView.hidden = (likeList.count == 0)
            } else {
                //6 if value in likeList is nil, set label text to be empty, hide small heart
                // if there is no list of users that like this post, reset everything
                self.likesLabel.text = ""
                self.likeButton.selected = false
                self.likesIconImageView.hidden = true
            }
        }
    }
    
    // generate comma-separated list of usernames from an array
    func stringFromUserList(userList: [PFUser]) -> String {
        // map from PFUser objects to their usernames
        let usernameList = userList.map { user in user.username! }
        // use array to create one joint string, define delimiter
        let commaSeparatedUserList = ", ".join(usernameList)
        
        return commaSeparatedUserList
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
