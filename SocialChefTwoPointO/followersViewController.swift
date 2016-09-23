//
//  followersViewController.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 9/14/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse
//import homeViewController

var shows = String()
var user = String()



class followersViewController: UITableViewController {

   //array holds data from server
    var usernameArray = [String]()
    var profArray = [PFFile]()
   
    //shows who is following or who user follows
    var followArray = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //shows which Title at top (followers or following) declared in home vc
        self.navigationItem.title = shows
        
        
       //loads followers when tapped on followers
        if shows == "followers"{ //declaired in homeViewController
            
            loadFollowers()
        
        }
       
        //loads followings when tapped on following  //declaired in homeViewController
        if shows == "following"{
        loadFollowings()
        
        }
        
    }
    
    
    func loadFollowers(){
        
        //request followers
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
         
            
            if error == nil{
                
                //clean up 
                self.followArray.removeAll(keepingCapacity: false)
                
               //for loop finds follow related objects from follow class by query
                for object in objects! {
                    
                    self.followArray.append(object.value(forKey: "follower") as! String)
                    
                }
                //find users following user
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                 
                    
                    if error == nil{
                      
                        //clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.profArray.removeAll(keepingCapacity: false)
                        
                        
                        //find objects related to query in user class
                        
                        for object in objects! {
                          self.usernameArray.append(object.object(forKey: "username")as! String)
                            
                           //gets profile image from array
                            self.profArray.append(object.object(forKey: "profileImg")as! PFFile)
                            
                            self.tableView.reloadData()
                            
                            
                        }
                    
                    
                    }else{
                        
                       //print(error!.localizedDescription)
                        //ALERT MESSAGE with localized error description
                        let alertMessage = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alertMessage.addAction(ok)
                        self.present(alertMessage, animated: true, completion: nil)

                        
                    }
                    
                    
                })
            
            
            }else{
                
                //print(error!.localizedDescription)
                //ALERT MESSAGE with localized error description
                let alertMessage = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertMessage.addAction(ok)
                self.present(alertMessage, animated: true, completion: nil)

            }
        };
        
        
    }
    
    
    func loadFollowings(){
        
        //request followers
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackground { (objects:[PFObject]?, error: Error?) in
            
        
            
            if error == nil{
                
                //clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                //for loop finds follow related objects from follow class by query
                for object in objects! {
                    
                    self.followArray.append(object.value(forKey: "following") as! String)
                    
                }
                
                //find users following user
                let query = PFUser.query()
                query?.whereKey("username", containedIn: self.followArray)
                
                query?.addDescendingOrder("createdAt")
                query?.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                
                if error == nil{
                        
                        //clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.profArray.removeAll(keepingCapacity: false)
                        
                        
                        //find objects related to query in user class
                        
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username")as! String)
                            
                            //gets profile image from array
                            self.profArray.append(object.object(forKey: "profileImg")as! PFFile)
                            
                            self.tableView.reloadData()
                            
                        }
                        
                        
                    }else{
                        
                        print(error!.localizedDescription)
                        //ALERT MESSAGE with localized error description
                        let alertMessage = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                        alertMessage.addAction(ok)
                        self.present(alertMessage, animated: true, completion: nil)

                        
                    }
                    
                    
                })
                
                
            }else{
                
                print(error!.localizedDescription)
                //ALERT MESSAGE with localized error description
                let alertMessage = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertMessage.addAction(ok)
                self.present(alertMessage, animated: true, completion: nil)

            }
        };

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
        
    }

    
     func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell

        
        // get data from server and relate to objects
        cell.usernameLbl.text = usernameArray[indexPath.row]
        profArray[indexPath.row].getDataInBackground { (data:Data?, error:Error?) in
            
        
            if error == nil{
                
                
                cell.profileImg.image = UIImage(data: data!)
                
                //round image for profile
               cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width / 2
            cell.profileImg.clipsToBounds = true
                
                
                
            
            }else{
                
                print(error!.localizedDescription)
                
                
            }
            
            
            
        }
        
        //follow button shows if user is following or not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.current()!.username!)
        query.whereKey("following", equalTo: cell.usernameLbl.text!)
        query.countObjectsInBackground { (count:Int32, error:Error?) in
            
        
            
            if error == nil {
                if count == 0 {
                   cell.followingBtn.setTitle("FOLLOW", for: UIControlState.normal)
                    cell.followingBtn.backgroundColor = UIColor.lightGray
                    
                    
                }else{
                    
                    cell.followingBtn.setTitle("FOLLOWING", for: UIControlState.normal)
                    cell.followingBtn.backgroundColor = UIColor.green
                    
                    

                    
                }
                
            }
        }
        if cell.usernameLbl.text == PFUser.current()?.username {
            
            cell.followingBtn.isHidden = true
            
        }
        
        
        return cell
    }
    
    
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! followersCell
        
        
        //if user taps on his self, go home else go to guest
        
        if cell.usernameLbl.text! == PFUser.current()!.username! {
            
let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(home, animated: true)
   
        
        }else{
           
            //declare username before presenting view controller
           // appends the usernametext
            guestName.append(cell.usernameLbl.text!)
            
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestViewController") as! guestViewController
            self.navigationController?.pushViewController(guest, animated: true)
            
        }
    
    
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
