//
//  LoginViewController.swift
//  MangoPractice
//
//  Created by jinsunkim on 10/12/2018.
//  Copyright © 2018 Bernard Hur. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire

class LoginViewController: UIViewController {
    let backGroundImageViw = UIImageView()
    let FBLoginButton = FBSDKLoginButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBLoginButton.delegate = self as FBSDKLoginButtonDelegate
        FBLoginButton.center = self.view.center
        FBLoginButton.readPermissions = ["public_profile"]
        view.addSubview(FBLoginButton)
        
        print(FBSDKAccessToken.current())
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("LoginView viewdidappear")
        if FBSDKAccessToken.current() != nil{
            performSegue(withIdentifier: "showVC",sender:self)
        }
    }
    
    //    deinit {
    //        print("Deinit")
    //    }
    
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name"])
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest) { (connection, result, error) -> Void in
            let data = result as! [String : AnyObject]
            let FBid = data["id"] as? String
            let url = "https://api.fastplate.xyz/api/auth-token/facebook/"
            let params: Parameters = [
                "access_token": FBSDKAccessToken.current() ?? "",
                "facebook_user_id": FBid ?? ""
            ]
            
            Alamofire.request(url, method: .post, parameters: params)
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        print(value)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
            
        }
        connection.start()
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logout")
    }
    
    
}

