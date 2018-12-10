//
//  LoginViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 10/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    let backGroundImageViw = UIImageView()
    let FBLoginButton = FBSDKLoginButton()


    override func viewDidLoad() {
        super.viewDidLoad()
        FBLoginButton.delegate = self as FBSDKLoginButtonDelegate
        FBLoginButton.center = self.view.center
        FBLoginButton.readPermissions = ["public_profile"]
        view.addSubview(FBLoginButton)
        
//        if FBSDKAccessToken.current() != nil && FBLoginSuccess == true {
//            print("Logged In")
//            performSegue(withIdentifier: "showVC", sender: nil)
//
//        } else {
//            print("Not Logged In")
//        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FBSDKAccessToken.current() != nil{
            performSegue(withIdentifier: "showVC",sender:self)
        }
    // 로그인은 되지만 재 로그인시에 오류 발생 수정 필요
    }
    
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Log Out")
    }
    
  

    
    


}

