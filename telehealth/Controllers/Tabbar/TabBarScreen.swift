//
//  TabbarScreen.swift
//  telehealth
//
//  Created by iroid on 31/07/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit

class TabBarScreen: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
//            if bottomPadding != 0.0{
//                setTabBarImage()
//            }else{
//                setBottomTabBar()
//            }
//        }else{
//            setBottomTabBar()
        }
        
        setTabBarControllers()
        //        self.tabBar.backgroundImage = UIImage(named: "bar_image")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            let bottomPadding = window?.safeAreaInsets.bottom
            if bottomPadding != 0.0{
                tabBar.frame.size.height = 100
                tabBar.frame.origin.y = view.frame.height - 100
            }
            
        }
        
    }
    
    func setBottomTabBar(){
     
//        view.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
//        tabBar.backgroundImage = UIImage.from(color: .clear)
//        tabBar.shadowImage = UIImage()
//
//        let tabbarBackgroundView = RoundShadowView(frame: tabBar.frame)
//        tabbarBackgroundView.layer.cornerRadius = 25
//        tabbarBackgroundView.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
//        tabbarBackgroundView.frame = tabBar.frame
//        view.addSubview(tabbarBackgroundView)
//
//        let fillerView = UIView()
//        fillerView.frame = tabBar.frame
//        // fillerView.frame.h
//        fillerView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
//        fillerView.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
////        view.addSubview(fillerView)
//
////        view.bringSubviewToFront(tabBar)
    }
    
    func setTabBarImage(){
        let image = UIImage(named: "bar_image")
        if let image = image {
            let centerImage: Bool = false
            var resizeImage: UIImage?
            let size = CGSize(width: UIScreen.main.bounds.size.width, height: 98)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            if centerImage {
                //if you want to center image, use this code
                image.draw(in: CGRect(origin: CGPoint(x: (size.width-image.size.width)/2, y: 0), size: image.size))
            }
            else {
                //stretch image
                image.draw(in: CGRect(origin: CGPoint.zero, size: size))
            }
            resizeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            tabBar.backgroundImage = resizeImage!.withRenderingMode(.alwaysOriginal)
        }
    }
    func setTabBarControllers() {
//        self.tabBar.layer.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
        //     self.tabBar.layer.cornerRadius = 25
        //        self.tabBar.layer.backgroundColor = #colorLiteral(red: 0.2941813767, green: 0.4239746034, blue: 0.7069228292, alpha: 1)
         self.tabBar.layer.cornerRadius = 32
        //        setTabBarImage()
        self.tabBar.layer.borderColor = UIColor.black.cgColor
        self.tabBar.clipsToBounds = true
        self.tabBar.barTintColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.navigationController?.isNavigationBarHidden = true
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.7)
        uesrRole = UserDefaults.standard.object(forKey: "UserType") as? Int ?? 0
        if uesrRole == 2{
            let PsychologistsHomeStoryboard = UIStoryboard(name: "PsychologistsHome", bundle: nil)
            let PsychologistsHomeScreen = PsychologistsHomeStoryboard.instantiateViewController(withIdentifier: "PsychologistsHomeScreen") as! PsychologistsHomeScreen
            let AppointmentsStoryboard = UIStoryboard(name: "Appointments", bundle: nil)
            let AppointmentsScreen = AppointmentsStoryboard.instantiateViewController(withIdentifier: "AppointmentsScreen") as! AppointmentsScreen
//            let CommunityStoryboard = UIStoryboard(name: "Community", bundle: nil)
//            let CommunityScreen = CommunityStoryboard.instantiateViewController(withIdentifier: "CommunityScreen") as! CommunityScreen
            let MyProfileStoryboard = UIStoryboard(name: "MyProfile", bundle: nil)
            let MyProfileScreen = MyProfileStoryboard.instantiateViewController(withIdentifier: "MyProfileScreen") as! MyProfileScreen
            let PsychologistsHomeNavigationController = UINavigationController(rootViewController: PsychologistsHomeScreen)
            let AppointmentsNavigationController = UINavigationController(rootViewController: AppointmentsScreen)
//            let CommunityNavigationController = UINavigationController(rootViewController: CommunityScreen)
            let MyProfileNavigationController = UINavigationController(rootViewController: MyProfileScreen)
            PsychologistsHomeNavigationController.isNavigationBarHidden = true
            AppointmentsNavigationController.isNavigationBarHidden = true
            MyProfileNavigationController.isNavigationBarHidden = true
//            CommunityNavigationController.isNavigationBarHidden = true
//            viewControllers = [PsychologistsHomeNavigationController, AppointmentsNavigationController, CommunityNavigationController, MyProfileNavigationController]
             viewControllers = [PsychologistsHomeNavigationController, AppointmentsNavigationController, MyProfileNavigationController]
        }else{
            let HomeScreenStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let HomeScreenScreen = HomeScreenStoryboard.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
            let AppointmentsStoryboard = UIStoryboard(name: "Appointments", bundle: nil)
            let AppointmentsScreen = AppointmentsStoryboard.instantiateViewController(withIdentifier: "AppointmentsScreen") as! AppointmentsScreen
//            let CommunityStoryboard = UIStoryboard(name: "Community", bundle: nil)
//            let CommunityScreen = CommunityStoryboard.instantiateViewController(withIdentifier: "CommunityScreen") as! CommunityScreen
            let MyProfileStoryboard = UIStoryboard(name: "MyProfile", bundle: nil)
            let MyProfileScreen = MyProfileStoryboard.instantiateViewController(withIdentifier: "MyProfileScreen") as! MyProfileScreen
            let HomeNavigationController = UINavigationController(rootViewController: HomeScreenScreen)
            let AppointmentsNavigationController = UINavigationController(rootViewController: AppointmentsScreen)
//            let CommunityNavigationController = UINavigationController(rootViewController: CommunityScreen)
            let MyProfileNavigationController = UINavigationController(rootViewController: MyProfileScreen)
            HomeNavigationController.isNavigationBarHidden = true
            AppointmentsNavigationController.isNavigationBarHidden = true
            MyProfileNavigationController.isNavigationBarHidden = true
//            CommunityNavigationController.isNavigationBarHidden = true
//            viewControllers = [HomeNavigationController, AppointmentsNavigationController, CommunityNavigationController, MyProfileNavigationController]
                viewControllers = [HomeNavigationController, AppointmentsNavigationController, MyProfileNavigationController]
            
        }
        self.tabBar.items![0].image = UIImage(named: "home_icon")
         self.tabBar.items![0].selectedImage = UIImage(named: "home_selected_icon")
        self.tabBar.items![1].image = UIImage(named: "appointments_icon")
         self.tabBar.items![1].selectedImage = UIImage(named: "session_selected_icon")
//        self.tabBar.items![2].image = UIImage(named: "community_icon")
        self.tabBar.items![2].image = UIImage(named: "my_profile")
          self.tabBar.items![2].selectedImage = UIImage(named: "profile_selected_icon")
        self.tabBar.items![0].title = Utility.getLocalizdString(value: "HOME")
        self.tabBar.items![1].title = Utility.getLocalizdString(value: "APPOINTMENTS")
//        self.tabBar.items![2].title = "Community"
        self.tabBar.items![2].title = Utility.getLocalizdString(value: "MY_PROFILE")
        selectedViewController = viewControllers![0]
    }
}
class RoundShadowView: UIView {
    
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -8.0)
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 10.0
        containerView.layer.cornerRadius = 20
        containerView.layer.masksToBounds = true
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
