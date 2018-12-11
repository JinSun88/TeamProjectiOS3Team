//
//  LoginViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 10/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    let backGroundImageViw = UIImageView()
    let FBLoginButton = FBSDKLoginButton()


    override func viewDidLoad() {
        super.viewDidLoad()
//        FBLoginButton.delegate = self as FBSDKLoginButtonDelegate
        FBLoginButton.center = self.view.center
        FBLoginButton.readPermissions = ["public_profile"]
        view.addSubview(FBLoginButton)
        
        print("LoginView viewdidload")
//        FBLoginButton.addTarget(self, action: #selector(loginFaceBook), for: .touchUpInside)
        
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
        print("LoginView viewdidappear")
        if FBSDKAccessToken.current() != nil{
            performSegue(withIdentifier: "showVC",sender:self)
        }
    }
    
//    @objc func loginFaceBook(_ sender: UIButton) {
//        let FBLoginManager = FBSDKLoginManager()
//        FBLoginManager.logIn(withReadPermissions: ["public_profile"], from: self) { (result, error) in
//            if (error == nil) {
//                let FBLoginResult: FBSDKLoginManagerLoginResult = result!
//                if (FBLoginResult.grantedPermissions.contains("public_profile")) {
//                    self.getFBUserData()
//                }
//            }
//        }
//
//    }
//
//    private func getFBUserData() {
//        if((FBSDKAccessToken.current()) != nil) {
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large) "])?.start(completionHandler: { (connection, result, error) -> Void in
//                if (error == nil) {
//                    print(result ?? "")
//                    self.performSegue(withIdentifier: "showVC", sender: self)
//                }
//            })
//        }
//    }
    
    
    deinit {
        print("Deinit")
    }
}

