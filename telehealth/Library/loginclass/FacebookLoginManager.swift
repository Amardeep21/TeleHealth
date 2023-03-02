//
//  FacebookLoginManager.swift
//  LTS-App
//
//  Created by iroid on 01/05/20.
//  Copyright © 2020 iroid. All rights reserved.
//

//================Important Notes========================//
//Set LSApplicationQueriesSchemes in Info plist file
//Set URL Types below Info plist file
//Set Open Url method in AppDelegate and openURLContexts method in SceneDelegate
//======================================================//

import Foundation
import FacebookLogin
import FacebookCore

protocol FacebookLoginManagerDelegate {
    func onFacebookLoginSuccess(user:FacebookUserDetail)
    func onFacebookLoginFailure(error:NSError)
}

class FacebookLoginManager:NSObject{
    var delegate: FacebookLoginManagerDelegate?

    func handleFacebookLoginButtonTap(viewController:UIViewController){
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.email,.publicProfile], viewController: viewController) { (loginResult) in
            print(loginResult)
            //  Utility.hideIndicator()
            switch loginResult{
            case .cancelled:
                print("User cancalled Login.")
            case .failed(let error):
                print(error.localizedDescription)
            case .success(granted: let granted, declined:let declined, token: let token):
                print(token.userID as Any)
                print(declined)
                print(granted)
                GraphRequest(graphPath: "me", parameters: ["fields": "id,email,gender, name,birthday, first_name,last_name, relationship_status,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        print(fbDetails)
                        //    Utility.showAlert(vc: self, message: "Facebook login done successfully")
                        let userDetail:FacebookUserDetail = FacebookUserDetail(userDataDictionary: fbDetails)
                        self.delegate?.onFacebookLoginSuccess(user: userDetail)
                    }
                    else{
                        print(error?.localizedDescription)
                        self.delegate?.onFacebookLoginFailure(error: error! as NSError)
                    }
                })
            }
        }
    }
}
