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
        if FBSDKAccessToken.current() != nil {
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
        
        connection.add(graphRequest) { (connection, response, error) -> Void in
            let data = response as! [String : AnyObject]
            let FBid = data["id"] as! String
            let token = result.token.tokenString!
            
//            print("id: ", FBid)
//            print("token :", token)
            
            let url = "https://api.fastplate.xyz/api/members/auth-token/facebook/"
            let params: Parameters = [
                "access_token": token,
                "facebook_user_id": FBid
            ]

            Alamofire.request(url, method: .post, parameters: params)
                .validate()
                .responseData { (response) in
                    switch response.result {
                    case .success(let value):
                        let result = try! JSONDecoder().decode(LoginData.self, from: value)
                        UserData.shared.userCellData = result
//                        print(UserData.shared.userCellData)
                        User.shared.token = result.token

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

