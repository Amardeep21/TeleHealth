//
//  SceneDelegate.swift
//  telehealth
//
//  Created by iroid on 28/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import FacebookCore
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let windowScene = (scene as? UIWindowScene) else { return }

//           window = UIWindow(windowScene: windowScene)
 
//        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController! {

        if rootViewController is UITabBarController {
            let tabbarController =  rootViewController as! UITabBarController
            return self.topViewControllerWithRootViewController(rootViewController: tabbarController.selectedViewController)
        } else if rootViewController is UINavigationController {
            let navigationController = rootViewController as! UINavigationController
            return self.topViewControllerWithRootViewController(rootViewController: navigationController.visibleViewController)
        } else if ((rootViewController.presentedViewController) != nil){
            let controller = rootViewController.presentedViewController
            return self.topViewControllerWithRootViewController(rootViewController: controller)
        } else {
            return rootViewController
        }

    }
    
    func scene( _ scene: UIScene,openURLContexts URLContexts: Set<UIOpenURLContext>) {
          guard let context = URLContexts.first else {
              return
          }
          ApplicationDelegate.shared.application(
              UIApplication.shared,
              open: context.url,
              sourceApplication: context.options.sourceApplication,
              annotation: context.options.annotation
          )
      }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    
        
        if(Utility.isUserAlreadyLogin()){
            if(!isFromAppdelegatePushNotifcation){
                if((UserDefaults.standard.object(forKey: PIN_SET)) != nil && (UserDefaults.standard.object(forKey: CONFIRM_PIN_SET)) != nil && (UserDefaults.standard.object(forKey: APP_SECURITY) != nil) && (UserDefaults.standard.object(forKey: APP_SECURITY) as? Bool) != false){
                    let storyBoard = UIStoryboard(name: "Pin", bundle: nil)
                    let control = storyBoard.instantiateViewController(withIdentifier: "PinScreen") as! PinScreen
                    control.isFromAppdelegate = true
                    control.modalPresentationStyle = .fullScreen
                    let navi: UINavigationController = self.window?.rootViewController as! UINavigationController
                    if ((navi.presentedViewController) != nil) {
                        navi.dismiss(animated: true) {
                            
                            navi.present(control, animated: false, completion: nil)
                        }
                    } else {
                        navi.present(control, animated: false, completion: nil)
                    }
                    guard let _ = (scene as? UIWindowScene) else { return }
                }
            }else{
                isFromAppdelegatePushNotifcation = true
            }
            if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                do{
                    if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                        token = (loginDetails.data?.auth?.accessToken ?? "") as String
                    }
                }catch{
                }
            }
            SocketHelper.shared.connectSocket(completion: { val in
                if(val){
                    print("socket connected")
                    if let data = UserDefaults.standard.value(forKey: USER_DETAILS) as? Data {
                        do{
                            if let loginDetails = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? LoginModel {
                                token = (loginDetails.data?.auth?.accessToken ?? "") as String
                                var parameter = [String: Any]()
                                parameter = ["senderId": loginDetails.data?.id ?? 0,
                                    ] as [String:Any]
                                SocketHelper.Events.UpdateStatusToOnline.emit(params: parameter)
                            }
                        }catch{}
                    }
                }
            })
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        if(Utility.isUserAlreadyLogin()){
       
        SocketHelper.shared.disconnectSocket()
            SocketHelper.shared.socket.off( "newMessage")
            SocketHelper.shared.socket.off( "userAdded")
            SocketHelper.shared.socket.off("newMessage")
            SocketHelper.shared.socket.off( "DisplayTyping")
            SocketHelper.shared.socket.off("statusOnline")
            SocketHelper.shared.socket.off("chatDeactivated")
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

