//
//  signInViewController.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 8/10/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse

class signInViewController: UIViewController {
    
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    @IBOutlet weak var forgotButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
       //style of font
        lable.font = UIFont(name: "Pacifico", size: 28)
        
        
        //setting manual constraints for different screen sizes
        lable.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20,height: 50)
        
        userNameTxt.frame = CGRect(x:10,y: lable.frame.origin.y + 70,width: self.view.frame.size.width - 20,height: 30)
        
        passwordTxt.frame = CGRect(x:10,y: userNameTxt.frame.origin.y + 40,width: self.view.frame.size.width - 20,height: 30)
        
    
        
        
        signInButton.frame = CGRect(x:20,y: forgotButton.frame.origin.y + 40,width: self.view.frame.size.width / 4,height: 30)
        
        signUpButton.frame = CGRect(x:self.view.frame.size.width - self.view.frame.size.width / 4 - 20,y: signInButton.frame.origin.y,width: self.view.frame.size.width / 4,height: 30)
        
        
        
        forgotButton.frame = CGRect(x:10,y: passwordTxt.frame.origin.y + 30,width: self.view.frame.size.width - 20,height: 30)
        
        
        //tap hides keyboard
    let tapHideKeyboard = UITapGestureRecognizer(target: self, action: Selector(("hideKeyBoardTap")))
        
        tapHideKeyboard.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapHideKeyboard)
        
        //background image
        let background = UIImageView(frame: CGRect(x:0,y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height))
        background.image = UIImage(named: "signUpBg.jpg")
        background.layer.zPosition = -1
        self.view.addSubview(background)
        
    }

    //func hideKeyBoardTap UITapGestureRecognizer
    func hideKeyBoardTap(recognizer: UITapGestureRecognizer){
        
        self.view.endEditing(true)
        
        
    }
    
    
    
    
   //sign in button
    @IBAction func signInBtn_click(sender: AnyObject) {
    
    print("sign in button clicked")
        
      //hide keyboard
        self.view.endEditing(true)
        
        if (userNameTxt.text!.isEmpty || passwordTxt.text!.isEmpty){
            
          //ALERT MESSAGE
            let alertMessage = UIAlertController(title:"Please", message:"Fill out all text fields", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alertMessage.addAction(ok)
            self.present(alertMessage, animated: true, completion: nil)
            
        }
        //login function  ()
        PFUser.logInWithUsername(inBackground: userNameTxt.text!, password:passwordTxt.text!, block: { (user: PFUser?, error: Error?) in
            
            
            if error == nil {
                
                //saves username in app memory
                UserDefaults.standard.set(user!.username, forKey:"username")
                UserDefaults.standard.synchronize()
                
               //calls login function from appDelegate
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
                
                
                
            }else {
                
                //ALERT MESSAGE with localized error description
                let alertMessage = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alertMessage.addAction(ok)
                self.present(alertMessage, animated: true, completion: nil)
                
            }
        })
    
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
