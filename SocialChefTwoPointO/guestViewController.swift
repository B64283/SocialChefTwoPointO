//
//  guestViewController.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 9/19/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse

var guestName = [String]()
var picArry = [PFFile]()



class guestViewController: UICollectionViewController {

    var refresh : UIRefreshControl!
    //number of posts visible
    var page : Int = 10
    var uuidArry = [String]()
    
    
   


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // allows to scroll vertically
        self.collectionView?.alwaysBounceVertical = true
        
        
        //background color
        collectionView?.backgroundColor = UIColor.white
        
        //username title in nav bar top
        self.navigationItem.title = guestName.last
        
        
        
        //swipe to go back
        self.navigationItem.hidesBackButton = true
        
        let backBtn = UIBarButtonItem(title: "back", style:UIBarButtonItemStyle.plain, target: self, action: Selector(("back")))
        
        self.navigationItem.leftBarButtonItem = backBtn
        
        
        
        
        let swipeBack = UISwipeGestureRecognizer(target: self, action:Selector(("back")))
        
        swipeBack.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeBack)
        
    
        
        //pull to refresh
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(HomeViewController.refresher), for: UIControlEvents.valueChanged)
        
        
        collectionView?.addSubview(refresh)
        
        reloadPosts()

      
    }

  
    
  //back funct
    func back(sender: UIBarButtonItem){
        
        //push back
       self.navigationController?.popViewController(animated: true)

        //clean guest username
        if !guestName.isEmpty {
            
            guestName.removeLast()
            
        }
        
        
    }
    
    
    
//    //reloads view when view appears
//    override func viewDidAppear(animated: Bool) {
//        //
//        collectionView?.reloadData()
//        
//        refresh.endRefreshing()
//        
//        
//        
//        
//        
//    }
    
    
    
    
    func refresher(){
        
        collectionView?.reloadData()
        
        refresh.endRefreshing()
        
        
        
    }
    
    
    func reloadPosts(){
        
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestName.last!)
        
        query.limit = page
        
        query.findObjectsInBackground { (objects: [PFObject]?, error:Error?) in
          
        if error == nil{
                
                //clean up
                self.uuidArry.removeAll(keepingCapacity: false)
                //picArry.removeAll(keepingCapacity: false)
                
                // gathers objects for query
                for object in objects! {
                    
                    //holds values depending on current username
                    //adds data from uuid and pic colomn
                  self.uuidArry.append(object.value(forKey: "uuid")as! String)
                  picArry.append(object.value(forKey: "pic")as! PFFile)
                }
                
                self.collectionView?.reloadData()
                
                
            } else {
                
                print(error!.localizedDescription)
                
            }
        }
    }
    
    
    
    //num of cells
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return uuidArry.count
    }
    
    
    
    //cell configure
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)as! RecipeImageCell
        
        //get pic from picArray [indexPath.row]
        picArry[indexPath.row].getDataInBackground (block:{ (data:Data?, error:Error?) in
           
            if error == nil {
                
                
                cell.recipeImg.image = UIImage(data: data!)
                
                
                
            }else{
                
                print(error! .localizedDescription)
            }
        
            })
  
        
        return cell
       
    
    }
            
            
    
    
    
    }
    
    
    
    
    
    //header configuer
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        //header set up
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath as IndexPath)as! HeaderView
        
        
        
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: guestName.last!)
        
        infoQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            
            if error == nil {
                
                //shown wrong user
                if objects!.isEmpty{
                    
                    print("wrong user")
                   
                }
                    
               
                
                for object in objects! {
                    
                    
                    //find related data for user
                    //grabs users data from server collumns in PFUser class (ObjectForKey)
                    header.nameLbl.text = (object.value(forKey: "fullName")as? String)
                    
                    header.webTxt.text = (object.value(forKey: "webSite") as? String)
                    header.webTxt.sizeToFit()
                    
                        
                    header.bioTxt.text = (object.value(forKey: "bio") as? String)
                    
                    header.bioTxt.sizeToFit()

                    let profImgQuery = (object.value(forKey:"profileImg")as? PFFile)
                    profImgQuery?.getDataInBackground(block: { (data:Data?, error:Error?) in
                   
                        header.profImg.image = UIImage(data: data!)
                        //round image for profile
                        header.profImg.layer.cornerRadius = header.profImg.frame.size.width / 2
                        header.profImg.clipsToBounds = true
                        
                        
                    })
                    
                    
                }
                
                
            }else{
                
                print(error?.localizedDescription)
                
            }
        }
                    
    
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: PFUser.current()!.username!)
        followQuery.whereKey("following", equalTo: guestName.last!)
        followQuery.countObjectsInBackground { (count:Int32, error:Error?) in
        
            
            if error == nil {
                if count == 0 {
                    
                    header.button.setTitle("FOLLOW", for: .normal)
                    header.button.backgroundColor = UIColor .lightGray
                    
                    
                }else{
                
                    header.button.setTitle("FOLLOWING", for: .normal)
                   header.button.backgroundColor = UIColor .green
                    
                    
                }
            
            
            }else{
                
                
                print(error?.localizedDescription)
                
            }
            
        }
        
        
        //counts posts
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestName.last!)
        posts.countObjectsInBackground { (count:Int32, error: Error?) in
        
            
            if error == nil {
                
                header.postsLbl.text = "\(count)"
                
            }
            
        }

        
        
        
        //counts user followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: guestName.last!)
        
        followers.countObjectsInBackground { (count:Int32, error:Error?) in
         
            
            if error == nil {
                
                header.followersLbl.text = "\(count)"
                
            }
            
            
            
        }
        
        
        //counts users following
        let following = PFQuery(className: "follow")
        following.whereKey("follower", equalTo: guestName.last!)
        following.countObjectsInBackground { (count:Int32, error:Error?) in
         
            
            if error == nil {
                
                header.followingLbl.text = "\(count)"
                
            }
            
            
            
        }

        
        //step 3 implament tap gestures
        
        //tap posts
        let postsTap = UITapGestureRecognizer(target:HomeViewController(), action: #selector(HomeViewController.postTap))
        postsTap.numberOfTapsRequired = 1
        
        header.postsLbl.isUserInteractionEnabled = true
        header.postsLbl.addGestureRecognizer(postsTap)
        
        //tap followers
        let followersTap = UITapGestureRecognizer(target: HomeViewController(), action: #selector(HomeViewController.followersTap))
        postsTap.numberOfTapsRequired = 1
        
        header.followersLbl.isUserInteractionEnabled = true
        header.followersLbl.addGestureRecognizer(followersTap)
        
        //tap followings
        let followingsTap = UITapGestureRecognizer(target: HomeViewController(), action: #selector(HomeViewController.followingsTap))
        followingsTap.numberOfTapsRequired = 1
        
        header.followingLbl.isUserInteractionEnabled = true
        header.followingLbl.addGestureRecognizer(followingsTap)
        
        
        return header
        
    }
   
                
                
   //post lable tapped
    func postTap(){
        
        if picArry.isEmpty{
            
            let indexNum = IndexPath(row: 0, section: 0)
            
            HomeViewController().collectionView?.scrollToItem(at: indexNum, at: UICollectionViewScrollPosition.top, animated: true)
        }
        
        
    }
    
    
    //followers lable tapped
    func followersTap(){
        
        user = guestName.last!
        shows = "followers"
        //initialize view for followers vc
        let followers = HomeViewController().storyboard?.instantiateViewController(withIdentifier: "followersViewController")as! followersViewController
        
        //presents view controller
        HomeViewController().navigationController?.pushViewController(followers, animated: true)
        
    }
    
    
    
    //followings lable tapped
    func followingsTap(){
        user = guestName.last!
        shows = "following"
        
        
        let followings = HomeViewController().storyboard?.instantiateViewController(withIdentifier: "followersViewController")as! followersViewController
        
        //presents view controller
        HomeViewController().navigationController?.pushViewController(followings, animated: true)
        
        
    }


    
    

    
    
    

