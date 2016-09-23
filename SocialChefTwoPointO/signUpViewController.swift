//
//  signUpViewController.swift
//  SocialChefTwoPointO
//
//  Created by Matthew Darke on 8/10/16.
//  Copyright © 2016 Matthew Darke. All rights reserved.
//

import UIKit
import Parse

class signUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    //UI outlets
    
     @IBOutlet weak var addLable: UILabel!
   
    
     weak var profImg: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var reEntrPasswordTxt: UITextField!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //button outlets
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    var scrollViewHeight : CGFloat = 0
    
    //keyboard frame size
    var keyBoard = CGRect()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = CGRect(x: 0,y: 0,width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        
        
        //tells if keyboard is showing or not. Selector for function (showKeyboard)
        
NSNotification.addObserver(self, selector:"showKeyboar", name: UIKeyboardWillShowNotification, object: nil)
        
        //selector hideKeyBoard for function (hideKeyBoard)
        
        NotificationCenter.defaultCenter().addObserver(self, selector:"hideKeyboard", name: UIKeyboardWillHideNotification, object: nil)

        
       
        //selector hideKeyBoardTap for function (hideKeyBoardTap)
        let hideTap = UITapGestureRecognizer(target: self, action: "hideKeyBoardTap")
        
        hideTap.numberOfTapsRequired = 1
       
        //allows the user to interact with gesture rec
        self.view.isUserInteractionEnabled = true
        
    //gesture recognizer
        self.view.addGestureRecognizer(hideTap)
    
        
       
   //round image for profile
        profImg.layer.cornerRadius = profImg.frame.size.width / 2
        profImg.clipsToBounds = true
    
        
     //declairs selector for loadProfImage function
        let profileImageTap = UITapGestureRecognizer(target: self, action: "loadProfImage")
    
     profileImageTap.numberOfTapsRequired = 1
     profImg.isUserInteractionEnabled = true
     profImg.addGestureRecognizer(profileImageTap)
    
        //alignment
        //centering profile image by self.view.frame.size.width / 2 - 40
       
        addLable.frame = CGRect(x:self.view.frame.size.width / 2 - 40,y: 20,width: 80, height: 15)
        
        profImg.frame = CGRect(x:self.view.frame.size.width / 2 - 40,y: 40,width: 80, height:80)
        
        usernameTxt.frame = CGRect(x:10, y:profImg.frame.origin.y + 120,width: self.view.frame.size.width - 20,height: 30)
        
        passwordTxt.frame = CGRect(x:10, y: usernameTxt.frame.origin.y + 40 ,width: self.view.frame.size.width - 20, height: 30)
        
        reEntrPasswordTxt.frame = CGRect(x:10, y: passwordTxt.frame.origin.y + 40 , width:self.view.frame.size.width - 20,height: 30)
        
        emailTxt.frame = CGRect(x:10,y: reEntrPasswordTxt.frame.origin.y + 60 ,width: self.view.frame.size.width - 20,height: 30)
        
        fullNameTxt.frame = CGRect(x:10,y: emailTxt.frame.origin.y + 40 ,width: self.view.frame.size.width - 20, height: 30)
        
        bioTxt.frame = CGRect(x:10, y: fullNameTxt.frame.origin.y + 40 ,width: self.view.frame.size.width - 20,height: 30)
        
        webTxt.frame = CGRect(x:10,y: bioTxt.frame.origin.y + 40 ,width: self.view.frame.size.width - 20, height: 30)
    
    
        signUpButton.frame = CGRect(x: 20, y: webTxt.frame.origin.y + 50, width: self.view.frame.size.width / 4 , height: 30)
        
        cancelButton.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 4 - 20,y: signUpButton.frame.origin.y,width: self.view.frame.size.width / 4,height: 30)
        
        
        //background image
        let bg = UIImageView (frame: CGRect(x:0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
        
        bg.image = UIImage(named:"signUpBg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
        
    }

    
    //load profile image function calling picker
    func loadProfImage(recognizer: UITapGestureRecognizer){
        
///////// can enter code to choose to take a photo or choose a phot in album//////////////
        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
        
    }
    
    
    
    //adds users chosen image to UIImageView for profile image
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
    profImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
    self.dismiss(animated: true, completion: nil)
    
    }
    
    
    
    
 
    //func hideKeyBoardTap UITapGestureRecognizer
    func hideKeyBoardTap(recognizer: UITapGestureRecognizer){
        
        self.view.endEditing(true)
        
        
    }
    
    
   //func showKeyboard
    func showKeyboard(notification:NSNotification) {
        
        //defines size of the keyboard
        keyBoard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        //moves up the scrollview uI
        UIView.animate(withDuration: 0.5) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyBoard.height
        }
        
        }
    
//func hideKeyboard
    func hideKeyboard(notification:NSNotification) {
        
       //slides down scrollview UI
        UIView.animate(withDuration: 0.5) {
            self.scrollView.frame.size.height = self.view.frame.height
        }

        
    }
    

  //signup Button action
    @IBAction func signUpButton_click(sender: AnyObject) {
        
        //dismiss keyboard
        self.view.endEditing(true)
        
       //checks all fields to see if empty. I will change later to let user know more detail about which field is wrong
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || reEntrPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || fullNameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty) {
            
            
         //alert message
            let alert = UIAlertController(title:"Please", message: "Fill all text fields", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        if passwordTxt.text != reEntrPasswordTxt.text{
            
           //password alert message did not match
            let alert = UIAlertController(title:"Password fields", message: "Did not match", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
       //sends user data to server
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text
        user["fullName"] = fullNameTxt.text?.lowercaseString
        user["bio"] = bioTxt.text
        user["webSite"] = webTxt.text?.lowercaseString
      
        //in edit profile will be assigned
        user["tel"] = ""
        user["Gender"] = ""
        
        //creates and sends image to server
        let profImgData = UIImageJPEGRepresentation(profImg.image!, 0.5)
        let profImgFile = PFFile(name: "profIm.jpg", data: profImgData! )
        user["profileImg"] = profImgFile
        
        
        //SAVE DATA TO SERVER
        user .signUpInBackgroundWithBlock { (Sucsess: Bool, error: NSError?) in
            if (Sucsess){
                
                print("Regestration sucsess!")
                //add alert and dismiss controller
                
                
               //keeps user from haveing to sign after app closes saves username on device
                NSUserDefaults.standardUserDefaults().setObject(user.username, forKey: "username")
                //saves username
                NSUserDefaults.standardUserDefaults().synchronize()
                
                //calls login function from appdelegate
                let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
           
                //calls login function from appdelegate
            appDelegate.login()
                
            } else {
                
                //ALERT MESSAGE with localized error description
                let alertMessage = UIAlertController(title:"Error", message:error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alertMessage.addAction(ok)
                self.presentViewController(alertMessage, animated: true, completion: nil)

                //print(error?.localizedDescription)
            }
        }
        
        
    }
    
    
    
  //cancel Button action
    @IBAction func cancelButton_click(sender: AnyObject) {
    print("cancel tapped")
        self.dismissViewControllerAnimated(true, completion: nil)
        
       //closes keyboard
        self.view.endEditing(true)
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
