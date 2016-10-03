//
//  followersCell.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 9/14/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var followingBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBAction func click_FollowBtn(_ sender: AnyObject) {
        
        let title = followingBtn.title(for: .normal)
        
        if title == "FOLLOW" {
            
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object ["following"] = usernameLbl.text
            
            object.saveInBackground(block: { (success:Bool, error: Error?) in
                if success {
                    
                    self.followingBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                    self.followingBtn.backgroundColor = UIColor.green
                    
                    
                    
                }else{
                    
                    print(error?.localizedDescription)
                    
                }
            })
            
        }else{
            
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: usernameLbl.text!)
            
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                
                if error == nil{
                    
                    for object in objects! {
                        
                        object.deleteInBackground(block: { (success: Bool, error: Error?) in
                            
                            if success {
                                
                                self.followingBtn.setTitle("FOLLOW", for:
                                    UIControlState.normal)
                                
                                self.followingBtn.backgroundColor = UIColor.lightGray
                                
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
    
   //fixed func
    func setSelected(selected: Bool, animated: Bool) {
        setSelected(selected: selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}



                            
                        

