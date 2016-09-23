//
//  HomeViewController.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 9/8/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse

//private let reuseIdentifier = "Cell"

class HomeViewController: UICollectionViewController {

   
    var refresh : UIRefreshControl!
    //number of posts visible
    var page : Int = 10
    
    var uuidArray = [String]()
    var picArray = [PFFile]()
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // allows to scroll vertically
        self.collectionView?.alwaysBounceVertical = true
        
        
        //background color
        collectionView?.backgroundColor = UIColor.white
        
        //username title in nav bar top
        self.navigationItem.title = PFUser.current()?.username
        
       
        
        //pull to refresh
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(HomeViewController.refresher), for: UIControlEvents.valueChanged)
        
        
        collectionView?.addSubview(refresh)
        
        reloadPosts()
        
        
            }

   
   //reloads view when view appears
    override func viewDidAppear(_ animated: Bool) {
        //
        collectionView?.reloadData()
        
        refresh.endRefreshing()
        

        
        
        
    }

    
    
    
    func refresher(){
        
        collectionView?.reloadData()
        
        refresh.endRefreshing()
        
        
        
    }
    
    
    func reloadPosts(){
        
        let query1 = PFQuery(className: "posts")
        
        query1.whereKey("username", equalTo: (PFUser.current()!.username)!)
        
        query1.limit = page
        
        query1.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
        
            if error == nil{
                
               //clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
               // gathers objects for query
                for object in objects! {
                    
                    //holds values depending on current username
                    //adds data from uuid and pic colomn
                    self.uuidArray.append(object.value(forKey: "uuid")as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
                
                self.collectionView?.reloadData()
                
                
            } else {
                
                print(error!.localizedDescription)
                
            }
        }
    }
    
    
    
   //num of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return picArray.count
    }

   
    
    //cell configure
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)as! RecipeImageCell
        
        //get pic from picArray [indexPath.row]
        picArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            
        
        if error == nil {
              
                
                cell.recipeImg.image = UIImage(data: data!)
                
                
                
            }else{
                print(error! .localizedDescription)
            }
        }
        return cell
    }
    
    
    
    
    
  //header configuer
    
 func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
       //header set up
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath as IndexPath)as! HeaderView
       
        //grabs users data from server collumns in PFUser class (ObjectForKey)
        header.nameLbl.text = (PFUser.current()?.object(forKey: "fullName") as? String)
    
        header.webTxt.text = PFUser.current()?.object(forKey: "webSite") as? String
        header.webTxt.sizeToFit()
        header.bioTxt.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioTxt.sizeToFit()
        
        let profImgQuery = PFUser.current()?.object(forKey: "profileImg")as? PFFile
        profImgQuery?.getDataInBackground(block: { (data:Data?, error:Error?) in
            header.profImg.image = UIImage(data: data!)
            //round image for profile
            header.profImg.layer.cornerRadius = header.profImg.frame.size.width / 2
            header.profImg.clipsToBounds = true
        })
        
        header.button.setTitle("Edit Profile", for: UIControlState.normal)
        
        
        //counts posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: PFUser.current()!.username!)
    posts.countObjectsInBackground { (count:Int32, error: Error?) in
        
    
            
            if error == nil {
                
                header.postsLbl.text = "\(count)"
                
            }
            
        };
        
        
        //counts user followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: PFUser.current()!.username!)
        
    followers.countObjectsInBackground { (count:Int32, error:Error?) in
        
    
            
            if error == nil {
                
                header.followersLbl.text = "\(count)"
                
            }
            
            
            
        }
        
        
        //counts users following
        let following = PFQuery(className: "follow")
        following.whereKey("follower", equalTo: PFUser.current()!.username!)
    following.countObjectsInBackground { (count:Int32, error:Error?) in
        
    
            
            if error == nil {
                
                header.followingLbl.text = "\(count)"
                
            }
            
            
            
        }

        //step 3 implament tap gestures
        
        //tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.postTap))
        postsTap.numberOfTapsRequired = 1
        
        header.postsLbl.isUserInteractionEnabled = true
        header.postsLbl.addGestureRecognizer(postsTap)
        
        //tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.followersTap))
        postsTap.numberOfTapsRequired = 1
        
        header.followersLbl.isUserInteractionEnabled = true
        header.followersLbl.addGestureRecognizer(followersTap)

        //tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.followingsTap))
        followingsTap.numberOfTapsRequired = 1
        
        header.followingLbl.isUserInteractionEnabled = true
        header.followingLbl.addGestureRecognizer(followingsTap)
        
        
        return header
        
    }
    
    
    //post lable tapped
    func postTap(){
        
        if !picArray.isEmpty{
            
            let indexNum = IndexPath(row: 0, section: 0)
            
            self.collectionView?.scrollToItem(at: indexNum, at: UICollectionViewScrollPosition.top, animated: true)
        }
        
        
    }
    
    
   //followers lable tapped
    func followersTap(){
        
        user = PFUser.current()!.username!
        shows = "followers"
        //initialize view for followers vc
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersViewController")as! followersViewController
       
        //presents view controller
        self.navigationController?.pushViewController(followers, animated: true)
        
    }
    

    
    //followings lable tapped
    func followingsTap(){
        user = PFUser.current()!.username!
        shows = "following"
        
        
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersViewController")as! followersViewController
        
        //presents view controller
        self.navigationController?.pushViewController(followings, animated: true)
        
        
    }
    
    
    @IBAction func logOut(_ sender: AnyObject) {
            
        PFUser .logOutInBackground { (error:Error?) in
            
        
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.synchronize()
            
            let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInViewController") as! signInViewController
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = signIn
            
            
            
            
            
            
            
            
        }
        
        
        
    }
    
    
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
