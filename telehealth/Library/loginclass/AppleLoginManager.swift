//
//  AppleLoginManager.swift
//  LTS-App
//
//  Created by iroid on 29/04/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import UIKit
import AuthenticationServices

//MARK:AppleLoginManagerDelegate
@available(iOS 13.0, *)
protocol AppleLoginManagerDelegate {
    func onSuccess(result:NSDictionary)
    func onFailure(error:NSError)
}

@available(iOS 13.0, *)
class AppleLoginManager:NSObject,ASAuthorizationControllerPresentationContextProviding{
    
    var mainView:UIView?
    var delegate: AppleLoginManagerDelegate?
    static var sharedInstace : AppleLoginManager?;
    
    //MARK: Handle Apple Login button tap
    @objc func handleAuthorizationAppleIDButtonPress() {
        AppleLoginManager.sharedInstace = self;
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return (mainView?.window!)!
    }
}

//MARK: ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension AppleLoginManager:ASAuthorizationControllerDelegate
{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            var fullName = appleIDCredential.fullName?.givenName
            var email = appleIDCredential.email
            if(email == nil)
            {
                email = "";
            }
            if(fullName == nil)
            {
                fullName = "";
            }
            
            let userDetailDictionary = NSMutableDictionary()
            userDetailDictionary.setValue(email, forKey: EMAIL)
            userDetailDictionary.setValue(userIdentifier, forKey: USER_IDD)
            userDetailDictionary.setValue(fullName, forKey: USERNAME)
            userDetailDictionary.setValue("apple", forKey: SOCIAL_PROVIDER)
            delegate?.onSuccess(result: userDetailDictionary)
            print("\(userIdentifier) name :\(fullName!)")
            
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                // self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        delegate?.onFailure(error: error as NSError)
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                        ASAuthorizationPasswordProvider().createRequest()]
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}
