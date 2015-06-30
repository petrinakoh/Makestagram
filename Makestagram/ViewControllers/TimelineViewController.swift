//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Petrina Koh on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photoTakingHelper: PhotoTakingHelper?
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1 create query that fetches Follow relationships for current user
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo: PFUser.currentUser()!)
        
        // 2 use that query to fetch any posts created by users that current user is following
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        // 3 create another query to retrieve all posts that current user has posted
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        //4 create a combined query of 2 and 3 - the query generated this way will return any Post that meets either of the constraints of the queries in 2 or 3
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        
        // 5 the combined query should fetch the PFUser associated with a post
        // using the includeKey method tells Parse to resolve the pointer to user object in the user column of each post, and download all info about the user along with the post
        query.includeKey("user")
        
        // 6 results should be ordered by they createdAt field - make posts on timeline appear in chronological order
        query.orderByDescending("createdAt")
        
        // 7 kick off the network request
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            // 8 we receive all posts that meet our requirement
            // The Parse framework hands us an array of type [AnyObject]? but we want to store the posts in an array of type [Post]
            self.posts = result as? [Post] ?? []
            
            // 1 loop over all posts returned from the timeline query
            for post in self.posts {
                // 2 calling getData() to download the actual image file
                let data = post.imageFile?.getData()
                // 3 once we have retrieved and stored the data, we turn it into a UIImage instance and store that in the image property of the post
                post.image = UIImage(data: data!, scale:1.0)
            }
            
            // 9 once we have stored the new posts, we refresh tableView
            self.tableView.reloadData()
        }
    }
    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            let post = Post()
            post.image = image
            post.uploadPost()
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

extension TimelineViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1 our Table View needs to have as many rows as we have posts stored in the posts property
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1 add cast to PostTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        // 2 using the postImageView property of our custom cell we can now decide which image should be displayed in the cell
        // we grab the image property of the post
        cell.postImageView.image = posts[indexPath.row].image
        
        return cell
    }
}
