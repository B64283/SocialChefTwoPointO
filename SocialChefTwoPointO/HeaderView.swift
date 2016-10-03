//
//  HeaderView.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 9/8/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse

class HeaderView: UICollectionReusableView {
    
    
    @IBOutlet weak var postsTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followersLbl: UILabel!
    @IBOutlet weak var postsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var profImg: UIImageView!
    
    @IBOutlet weak var webTxt: UITextView!

    @IBOutlet weak var bioTxt: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //alignment
    
        let width = UIScreen.main.bounds.width
        profImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
        
        postsLbl.frame = CGRect(x: width / 2.5 ,y: profImg.frame.origin.y,width: 50, height: 30)
        
        followersLbl.frame = CGRect(x: width / 1.7, y: profImg.frame.origin.y,width: 50, height: 30)
        followingLbl.frame = CGRect(x: width / 1.25, y: profImg.frame.origin.y, width: 50, height: 30)
        
        postsTitle.center = CGPoint(x: postsLbl.center.x, y: postsLbl.center.y + 20)
        
        followersTitle.center = CGPoint(x: followersLbl.center.x, y: followersLbl.center.y + 20)
        
        followingsTitle.center = CGPoint(x: followingLbl.center.x, y: followingLbl.center.y + 20)
        
        
        
        button.frame = CGRect(x: postsTitle.frame.origin.x, y: postsTitle.center.y + 20, width: width - postsTitle.frame.origin.x - 10, height: 30)
        
        
        nameLbl.frame = CGRect(x:profImg.frame.origin.x, y: profImg.frame.origin.y + profImg.frame.size.height, width: width - 20, height: 30)
        
        webTxt.frame = CGRect(x: profImg.frame.origin.x - 5,y: nameLbl.frame.origin.y + 15,width: width - 30,height: 30)
        
        bioTxt.frame = CGRect(x: profImg.frame.origin.x,y: webTxt.frame.origin.y + 30,width: width - 30, height: 30)
        
    
        
   
        
        

        
        
        
    }
    
    @IBAction func click_FollowBtn(sender: AnyObject) {
        
        let title = button.title(for: .normal)
        
        if title == "FOLLOW" {
            
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object ["following"] = guestName.last!
            object.saveInBackground(block: { (success: Bool, error: Error?) in
                
            
                if success {
                    
                    self.button.setTitle("FOLLOWING", for: UIControlState.normal)
                    self.button.backgroundColor = UIColor.green
                    
                    
                    
                }else{
                    
                    print(error?.localizedDescription)
                    
                }
            })
            
        }else{
            
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: guestName.last!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                
       if error == nil{
                    
                    for object in objects! {
                        
                        object.deleteInBackground(block: { (success: Bool, error:Error?) in
                           
                            if success {
                                
                                self.button.setTitle("FOLLOW", for: UIControlState.normal)
                                
                                self.button.backgroundColor = UIColor.lightGray
                                
                            }else{
                                
                                print(error?.localizedDescription)
                                
                                
                            }
                        })
                    }
                    
                    
                }else{
                    
                    print(error?.localizedDescription)
                    
                }
            })
        }
    }
    
    
}










