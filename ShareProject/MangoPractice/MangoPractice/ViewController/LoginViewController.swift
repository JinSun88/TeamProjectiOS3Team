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
//    static let myToken = "60491dacbde0ced0de7d15a8bc797c2e20900ae6"
    
    
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
            let userDefaultAuthFBid = UserDefaults.standard
            userDefaultAuthFBid.set(FBid, forKey: "authFBid")
            userDefaultAuthFBid.synchronize()
            let token = result.token.tokenString!
            let userDefaultAuthToken = UserDefaults.standard
            userDefaultAuthToken.set(token, forKey: "authToken")
            userDefaultAuthToken.synchronize()
            
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

                        
                    
                        
                        // 유저 디폴트 구축
//                        let userDefaultesToken = UserDefaults.standard
//                        userDefaultesToken.set(result.token, forKey: "userToken")
//                        userDefaultesToken.synchronize()
                        
                        // 유저 디폴트 사용
//                        let something = UserDefaults.standard.string(forKey: "userToken")
//                        print(something)
                        

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

