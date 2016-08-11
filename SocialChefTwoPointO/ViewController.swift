//
//  ViewController.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 8/9/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {

    
    @IBOutlet var picture: UIImageView!
    
    @IBOutlet weak var receiverLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var SenderLbl: UILabel!
    
    
    
    
//    let message = String()
//    let receiver = String()
//    let sender = String()
//    let pictureFile = [PFFile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //unwrap image file / get image file data from uiimageview
//        let picData = UIImageJPEGRepresentation(picture.image!, 0.5)
//        
//        //convert taken image to file
//        let file = PFFile(name: "picture.jpg", data: picData!)
//        
//        //create a class / collecton/ table in Heroku
//        
//        let table = PFObject(className: "messages")
//        table["sender"] = "Jesus"
//        table["reciever"] = "Matthew"
//        table["message"] = "This is nice"
//        table["pitcure"] =  file
//        
//        table.saveInBackgroundWithBlock { (sucsess:Bool, error:NSError?) in
//            if sucsess{
//                
//                print("Saved Image in server")
//                
//            }else{
//                print(error)
//            }
//        }
//    
//    
//    //retreve data from server
        let iformation = PFQuery(className: "messages")
        iformation.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) in
            if(error == nil){
                
                for object in objects!{
                    
                let message = object["message"] as! String
                let receiver = object["reciever"] as! String
                let Sender = object["sender"] as! String
                   
                  self.messageLbl.text = "Message: \(message)"
                   self.receiverLbl.text = "Receiver: \(receiver)"
                    self.SenderLbl.text = "Sender: \(Sender)"
                    
                    object["pitcure"].getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) in
                        
                        if error == nil{
                            
                            if data != nil{
                                self.picture.image = UIImage(data: data!)
                            }
                                
                            }else{
                            
                            print(error)
                           
                        }
                    })
                
                }
                
            }else{
               
                print(error)
            }
        }
    
    
    
    }
        
    //let object = PFObject(className: "testObject")
//        object["name"] = "Matt"
//        object["LastName"] = "Darke"
//        object.saveInBackgroundWithBlock { (done:Bool, error:NSError?) in
//            
//            
//            if(done){
//                
//                print("Saved in server")
//            }else{
//                print(error)
//                
//            }
    
       //}
        
    //}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

