//
//  AppDelegate.swift
//  telehealth
//
//  Created by iroid on 28/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FacebookLogin
import FacebookCore
import SDWebImage
import Firebase
import UserNotifications
import FirebaseMessaging
import AVFoundation
import AVKit
import Firebase
import FirebaseCore

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
     var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        //        do {
        //                  try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        //              }
        //              catch {
        //                  // report for an error
        //                  print(error)
        //              }
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            self.window?.makeKeyAndVisible()
        }
        
        IQKeyboardManager.shared.enable = true
        //        Utility.setLanguage(langStr: ARABIC_LANG_CODE)
        let language = Bundle.main.preferredLocalizations.first! as NSString
        print(language)
        let language1 = Locale.preferredLanguages[0] as String
        print (language1)
        let langStr = Locale.autoupdatingCurrent.languageCode
        print(langStr!)
        //        UserDefaults.standard.set(ENGLISH_LANG_CODE, forKey: LANGUAGE)
        //        Utility.setLanguage(langStr: ENGLISH_LANG_CODE)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        if language1 == "ar" {
            UserDefaults.standard.set(ARABIC_LANG_CODE, forKey: LANGUAGE)
            Utility.setLanguage(langStr: ARABIC_LANG_CODE)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            UserDefaults.standard.set(ENGLISH_LANG_CODE, forKey: LANGUAGE)
            Utility.setLanguage(langStr: ENGLISH_LANG_CODE)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        GIDSignIn.sharedInstance().clientID = CLIENT_ID
        if let option = launchOptions {
            let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
            if (info != nil) {
                isFromAppdelegatePushNotifcation = true
            }
        }else{
            isFromAppdelegatePushNotifcation = false
        }
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 10
        //
        //        switch AVAudioSession.sharedInstance().recordPermission {
        //        case AVAudioSessionRecordPermission.granted:
        //            print("Permission granted")
        //        case AVAudioSessionRecordPermission.denied:
        //            print("Pemission denied")
        //        case AVAudioSessionRecordPermission.undetermined:
        //            print("Request permission here")
        //            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
        //                // Handle granted
        //            })
        //        @unknown default:
        //            print("default")
        //        }
        
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (videoGranted: Bool) -> Void in
            if (videoGranted) {
                AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (audioGranted: Bool) -> Void in
                    if (audioGranted) {
                        
                    } else {
                        // Rejected audio
                    }
                })
            } else {
                // Rejected video
            }
        })
//        if(Utility.isUserAlreadyLogin()){
//            uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
//            if(uesrRole == 2){
//            }
//        }
        showPromptToTherapist = true
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if (GIDSignIn.sharedInstance()?.handle(url))!{
            return true
        }
        
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func registerForPushNotification(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let parameters = ["token" :UserDefaults.standard.object(forKey: FCM_TOKEN) ?? "",
                              "type" : "iOS",
                              DEVICE_ID:DEVICE_UNIQUE_IDETIFICATION,
                ] as [String : Any]
            LoginServices.shared.registerForPush(parameters: parameters, success: { (statusCode, commanModel) in
                Utility.hideIndicator()
                print(commanModel.message)
    //            self.navigateFurtherScreen(loginModel: loginModel)
            }) { (error) in
                Utility.hideIndicator()
    //            Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
    //        Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }

}

// [START ios_10_message_handling]
@available(iOS 13, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)
    // Print message ID.
    if let messageID = userInfo["gcmMessageIDKey"] {
      print("Message ID: \(messageID)")
    }
    if(!isOnCallScreen){
        if((userInfo["type"] as? String ?? "")  != "6" || (userInfo["type"] as? String ?? "")  != "8"){
            let alert = UIAlertController(title: Utility.getLocalizdString(value: "TELEHEALTH"), message: userInfo["message"] as? String ?? "", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "\(Utility.getLocalizdString(value: "OK"))", style: .cancel, handler: nil)
            alert.addAction(okButton)
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        }
    }
  
    // Print full message.
    print(userInfo)
   
    // Change this to your preferred presentation option
    completionHandler([[.sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    
    if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
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
    let storyboard1 = UIStoryboard(name: "TabBar", bundle: nil)
    let vc1 = storyboard1.instantiateViewController(withIdentifier: "TabBarScreen") as! TabBarScreen
    isFromAppdelegatePushNotifcation = true
    if(userInfo["type"] != nil){
        if((userInfo["type"] as? String ?? "")  == "2" || (userInfo["type"] as? String ?? "")  == "1" || (userInfo["type"] as? String ?? "")  == "3" || (userInfo["type"] as? String ?? "")  == "4" || (userInfo["type"] as? String ?? "")  == "5" ){
            let storyboard = UIStoryboard(name: "Appointments", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MySessionScreen") as! MySessionScreen
            vc.sessionId = Int((userInfo["sessionId"] as! NSString).intValue)
            vc.isFromPushNotification = false
            vc.isFromUpcomingOrPast = 1
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.setViewControllers([vc1,vc], animated: false)
            }
        }else if((userInfo["type"] as? String ?? "")  == "6"){
            let userDictionary = userInfo as NSDictionary
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChatScreen") as! ChatScreen
            vc.userDataDictionary = userDictionary
            vc.isFromPushNotification = true
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.setViewControllers([vc1,vc], animated: false)
            }
        }
        else if((userInfo["type"] as? String ?? "")  == "7"){
            let userDictionary = userInfo as NSDictionary
            
            let storyboard = UIStoryboard(name: "Blog", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BlogDetailScreen") as! BlogDetailScreen
            vc.blogId = Int((userInfo["blogId"] as! NSString).intValue)
            vc.isFromPushNotification = false
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.setViewControllers([vc1,vc], animated: false)
            }

        }else if((userInfo["type"] as? String ?? "")  == "9"){
            let storyboard = UIStoryboard(name: "Request", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "RequestScreen") as! RequestScreen
          
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.setViewControllers([vc1,vc], animated: false)
            }
        }else if((userInfo["type"] as? String ?? "")  == "10"){
            let storyboard = UIStoryboard(name: "Notification", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NotificationListScreen") as! NotificationListScreen
          
            if let topVC = UIApplication.topViewController() {
                topVC.navigationController?.setViewControllers([vc1,vc], animated: false)
            }
        }
    }
    print(userInfo)
    
    //completionHandler()
  }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
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
//                    guard let _ = (scene as? UIWindowScene) else { return }
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
    
    func applicationWillResignActive(_ application: UIApplication) {
        if(Utility.isUserAlreadyLogin()){
        SocketHelper.shared.disconnectSocket()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo["gcmMessageIDKey"] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("APNs token retrieved: \(deviceToken)")
        Messaging.messaging().delegate = self
       let token = Messaging.messaging().fcmToken
       print("FCM token: \(token ?? "")")
        print(deviceToken)
      // With swizzling disabled you must set the APNs token here.
      // Messaging.messaging().apnsToken = deviceToken
    }
    
}

@available(iOS 13.0, *)
extension AppDelegate : MessagingDelegate {
  // [START refresh_token]
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Firebase registration token: \(fcmToken)")
    
    UserDefaults.standard.setValue(fcmToken, forKey: FCM_TOKEN)
    if(Utility.isUserAlreadyLogin()){
        self.registerForPushNotification()
    }
    let dataDict:[String: String] = ["token": fcmToken]
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
  }
  // [END refresh_token]
}
extension UIApplication {
class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
        return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
    }
    if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
    }
    return controller
} }
extension UINavigationController {
    open func pushViewControllers(_ inViewControllers: [UIViewController], animated: Bool) {
        var stack = self.viewControllers
        stack.append(contentsOf: inViewControllers)
        self.setViewControllers(stack, animated: animated)
    }
}
extension UIApplication {
    class func topNewViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topNewViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topNewViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topNewViewController(base: presented)
        }
        return base
    }
}
