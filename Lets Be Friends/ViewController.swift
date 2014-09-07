//
//  ViewController.swift
//  Lets Be Friends
//
//  Created by Katlyn Schwaebe on 8/27/14.
//  Copyright (c) 2014 Katlyn Schwaebe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var loginHolder = UIView()
    var signupHolder = UIView()
    var buttonsHolder = UIView()
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        Parse.setApplicationId("Vs7IjCMSjlbHErBCJHF2TOLCbMfmsqDmOcO2FLwr", clientKey: "wc9zzH2gzTrftpHvjs5tRM9Syn64DVt8uG08ssJM")
        var signupButton = UIButton(frame: CGRectMake(10, 10, 145, 40))
        signupButton.setTitle("signup", forState: .Normal)
        signupButton.backgroundColor = UIColor(red: 1, green: 0.3, blue: 0, alpha: 1)
        signupButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.addTarget(self, action: Selector("showSignup"), forControlEvents: .TouchUpInside)
        self.view.addSubview(signupButton)
        
        var loginButton = UIButton(frame: CGRectMake(165, 10, 145, 40))
        loginButton.setTitle("login", forState: .Normal)
        loginButton.backgroundColor = UIColor(red: 0, green: 0.4, blue: 1, alpha: 1)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.addTarget(self,action: Selector("showLogin"), forControlEvents: .TouchUpInside)
        self.view.addSubview(loginButton)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func showLogin(){
        signupHolder.removeFromSuperview()
        
        loginHolder.frame = self.view.frame
        var usernameField = UITextField(frame: CGRectMake(10, 200, 300, 40))
        usernameField.placeholder = "Username"
        loginHolder.addSubview(usernameField)
        
        var passwordField = UITextField(frame: CGRectMake(10, 250, 300, 40))
        passwordField.secureTextEntry = true
        passwordField.placeholder = "Password"
        loginHolder.addSubview(passwordField)
        
        var submitLogin = UIButton(frame: CGRectMake(10, 300, 300, 40))
        submitLogin.setTitle("Submit", forState: .Normal)
        loginHolder.addSubview(submitLogin)
        submitLogin.backgroundColor = UIColor.lightGrayColor()
        submitLogin.addTarget(self, action: Selector("showLogin"),forControlEvents: .TouchUpInside)
        fieldData = [
            "Username":usernameField,
            "Password":passwordField
        ]
        self.view.addSubview(loginHolder)
    
    }
    func showSignup(){
        loginHolder.removeFromSuperview()
        loginHolder = UIView()
        
        signupHolder.frame = self.view.frame
        var emailField = UITextField(frame:CGRectMake(10, 150, 300, 40))
        emailField.placeholder = "Email"
        signupHolder.addSubview(emailField)
        
        var usernameField = UITextField(frame: CGRectMake(10, 200, 300, 40))
        usernameField.placeholder = "Username"
        signupHolder.addSubview(usernameField)
        
        var passwordField = UITextField(frame: CGRectMake(10, 250, 300, 40))
        passwordField.secureTextEntry = true
        passwordField.placeholder = "Password"
        signupHolder.addSubview(passwordField)
        
        var submitSignup = UIButton(frame: CGRectMake(10, 300, 300, 40))
        submitSignup.setTitle("Signup", forState: .Normal)
        signupHolder.addSubview(submitSignup)
        submitSignup.backgroundColor = UIColor.lightGrayColor()
        submitSignup.addTarget(self, action: Selector("signup"),forControlEvents: .TouchUpInside)
        fieldData = [
            "Email":emailField,
            "Username":usernameField,
            "Password":passwordField
        ]
        self.view.addSubview(signupHolder)
 
    }
    var fieldData: [String:UITextField]!
    func login(){
       
        PFUser.logInWithUsernameInBackground(fieldData["Username"]!.text, password: fieldData["Password"]!.text, block: { (user:PFUser!, error:NSError!) -> Void in
            self.loginHolder.removeFromSuperview()
            if user != nil {
                println(user.objectForKey("team"))
                if user.objectForKey("team") == nil {
                    self.showTeams()
                
            } else {
                self.attackMode()
            }
            
            }else{
                println(error)
            }
        })
    }
    func signup(){
        var user = PFUser()
        user.email = fieldData["Email"]!.text
        user.password = fieldData["Password"]!.text
        user.username = fieldData["Username"]!.text
        user.signUpInBackgroundWithBlock { (succeeded: Bool, error:NSError!) -> Void in
            
            if succeeded {
                print("you are logged in")
                self.signupHolder.removeFromSuperview()
            }else{
                println(error)
            }
            
        }
        
    }
    var teamHolder = UIView()
    let halfHeight = UIScreen.mainScreen().bounds.size.height
    
    func showTeams(){
        var redTeam = UIButton(frame: CGRectMake(0, 0, 320, UIScreen.mainScreen().bounds.size.height/2.0))
        redTeam.backgroundColor = UIColor.redColor()
        redTeam.tag = 1
 //you didn't have the : after "chooseTeam" in the line below and it wont work
        redTeam.addTarget(self, action: Selector("chooseTeam:"), forControlEvents: .TouchUpInside)
        teamHolder.addSubview(redTeam)
 //don't need to tag blue with a number since there must always be a default in switch statements(it's next statement down)
        var blueTeam = UIButton(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height/2.0, 320, UIScreen.mainScreen().bounds.size.height/2.0))
        blueTeam.backgroundColor = UIColor.blueColor()
        blueTeam.addTarget(self, action: Selector("chooseTeam:"), forControlEvents: .TouchUpInside)
 //       blueTeam.addTarget(self, action: Selector("chooseTeam:"), forControlEvents: .TouchUpInside)
        teamHolder.addSubview(blueTeam)
        self.view.addSubview(teamHolder)
        
        
    }
    func chooseTeam(teamButton:UIButton){
        var user = PFUser.currentUser()
      
        
        switch teamButton.tag{
        
  //also when we made the redbutton to choose team we tagged it with "1" so we changed this to case 1 instead of "UIColor red"
        case 1:
            user.setObject("red", forKey: "team")
        default :
            user.setObject("blue", forKey: "team")
            
        }
        user.saveInBackground()
        teamHolder.removeFromSuperview()
        attackMode()
    }
    func attackMode(){
        var installation = PFInstallation.currentInstallation()
        installation.setObject(PFUser.currentUser(), forKey: "user")
        installation.saveInBackground()
        
        var attackButton = UIButton(frame: CGRectMake(10, 200, 300, 40))
        attackButton.setTitle("Attack", forState: .Normal)
        attackButton.backgroundColor = UIColor.blackColor()
        attackButton.addTarget(self, action: Selector("attack"), forControlEvents: .TouchUpInside)
        self.view.addSubview(attackButton)
        
    }
    
    func attack() {
        var user = PFUser.currentUser()
        var otherteam = (user.objectForKey("team") as String == "red") ? "blue" : "red"
        var userQuery = PFQuery(className: "User")
        userQuery.whereKey("team", equalTo: otherteam)
        
        userQuery.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
            println("users \(objects)")
        }
        
        var deviceQuery = PFInstallation.query()
        deviceQuery.whereKey("user", matchesQuery: userQuery)
        var push = PFPush()
        
        push.setQuery(deviceQuery)
        push.setMessage("You have been attacked")
        push.sendPushInBackground()
        
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

