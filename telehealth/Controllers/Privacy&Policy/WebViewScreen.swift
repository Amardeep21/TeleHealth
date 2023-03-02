//
//  WebViewScreen.swift
//  telehealth
//
//  Created by Apple on 02/10/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import WebKit

class WebViewScreen: UIViewController,WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var url:String = ""
    var titleType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        initalizedDetails()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
    }
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func initalizedDetails(){
        titleLabel.text = titleType
        webView.navigationDelegate = self
        guard let newUrl = URL(string: self.url) else { return }
        let request = URLRequest(url: newUrl)
        webView.load(request)
        Utility.showIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.hideIndicator()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
         Utility.hideIndicator()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
