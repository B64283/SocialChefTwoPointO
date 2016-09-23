//
//  resetPasswordViewController.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 8/10/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse

class resetPasswordViewController: UIViewController {

   //email textfield
    @IBOutlet weak var emailTxt: UITextField!
    
    
   //buttons
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    
   //reset button function
    
    @IBAction func resetBtnClick(sender: AnyObject) {
        
        
        self.view.endEditing(true)
        
        if emailTxt.text!.isEmpty{
            
          //show alert email is empty
            let alert = UIAlertController(title:"email field", message: "is empty", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
            
        }
        
       
       //request for reset password
       /* PFUser.requestPasswordResetForEmailInBackground(emailTxt.text!) { (sucsess: Bool, error:NSError?) in
            
            if sucsess {
                
              //show alert message
                let alert = UIAlertController(title:"instructions for resetting your password", message: " has been set to your email adress", preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    
                self.dismissViewControllerAnimated(true, completion:nil)
                
                })
                alert.addAction(ok)
                self.presentViewController(alert, animated: true, completion: nil)

        
                
            }else{
                
                print(error?.localizedDescription)
                
                
            }
            
          }
       */
    }
    
    
   //cancel button function
    @IBAction func cancelBtnClick(sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //alignment of ui
        emailTxt.frame = CGRect(x: 10, y: 120, width: self.view.frame.size.width - 20,height: 30)
        
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4, height: 30)
        
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20, y: resetBtn.frame.origin.y, width:self.view.frame.size.width / 4, height: 30)
        
        
        //background image
        let bg = UIImageView (frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        
        bg.image = UIImage(named:"signUpBg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
