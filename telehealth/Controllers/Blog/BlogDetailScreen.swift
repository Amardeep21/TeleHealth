//
//  BlogDetailScreen.swift
//  telehealth
//
//  Created by iroid on 03/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class BlogDetailScreen: UIViewController {
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var blogImageView: dateSportImageView!
    @IBOutlet weak var textviewHtmlString: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: ExpandableLabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationView: dateSportView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var blogId:Int?
    var blogDetailData:BlogsModel?
    var isFromPushNotification : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializedDetails()
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
    func initializedDetails(){
        getBlogDetail()
    }
    
    @IBAction func onBack(_ sender: UIButton) {
      
            self.navigationController?.popViewController(animated: true)
       
    }
    
    
    @IBAction func onPlayVideo(_ sender: UIButton) {
        if(blogDetailData?.mediaType == 1){
            let storyboard = UIStoryboard(name: "Blog", bundle: nil)
                   let confirmAlertController = storyboard.instantiateViewController(withIdentifier: "ImageDisplayScreen") as! ImageDisplayScreen
            confirmAlertController.imageUrl = blogDetailData?.image_large ?? ""
                   confirmAlertController.modalPresentationStyle = .overFullScreen
                   self.present(confirmAlertController, animated: true, completion: nil)
        }else{
            let videoURL = URL(string: (blogDetailData?.video)!)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    func getBlogDetail(){
        if Utility.isInternetAvailable(){
            Utility.showIndicator()
            let url = "\(BLOGS_DETAIL)\(blogId ?? 0)"
            BlogServices.shared.getBlogDetail(url: url, success: { (statusCode, BlogDetailModel) in
                Utility.hideIndicator()
                self.blogDetailData =  BlogDetailModel.data
                self.setDetails()
            }) { (error) in
                Utility.hideIndicator()
                Utility.showAlert(vc: self, message: error)
            }
        }else{
            Utility.hideIndicator()
            Utility.showNoInternetConnectionAlertDialog(vc: self)
        }
    }
    
    func setDetails(){
       
        titleLabel.text = blogDetailData?.title
        headerTitleLabel.text = blogDetailData?.title
        dateLabel.text = "\(Utility.UTCToLocal(date: (blogDetailData?.publishAt)!, fromFormat: YYYY_MM_DDHHMM, toFormat: MMMM_DD_YYYY))"
        Utility.setImage(blogDetailData?.image_large, imageView: blogImageView)
        
        if blogDetailData?.mediaType == 1{
            durationView.isHidden = true
            playImageView.isHidden = true
        }else{
            durationView.isHidden = false
            playImageView.isHidden = false
            durationLabel.text = blogDetailData?.duration
        }

        var replaced = blogDetailData?.description!.replacingOccurrences(of: "<p>", with: "<p style=color:blue;font-size:18px;line-height:20px;>")
        replaced = replaced?.replacingOccurrences(of:  "\n\t<li>", with: "<li style=color:blue;font-size:18px;line-height:20px;>")
        replaced = replaced?.replacingOccurrences(of:  "\n</ul>", with: "</ul>")
        replaced = replaced!.replacingOccurrences(of: "\n", with: "<br>")
       
        detailLabel.setAttributedHtmlText((replaced)!)
        
        detailLabel.textColor = #colorLiteral(red: 0.231372549, green: 0.337254902, blue: 0.6470588235, alpha: 1)
        if(Utility.getCurrentLanguage() == ENGLISH_LANG_CODE){
            detailLabel.textAlignment = .left
            authorName.text = "By \(blogDetailData?.authorname ?? "")"
            authorName.textAlignment = .left
            titleLabel.textAlignment = .left
        }else{
            detailLabel.textAlignment = .right
            titleLabel.textAlignment = .right

            authorName.text = "بواسطة \(blogDetailData?.authorname ?? "")"
            authorName.textAlignment = .right
            
        }
      //  textviewHtmlString.attributedText = blogDetailData?.description?.htmlToAttributedString

    }
    
    
    
}
extension String {

    var utfData: Data {
        return Data(utf8)
    }

    var attributedHtmlString: NSAttributedString? {

        do {
            return try NSAttributedString(data: utfData,
            options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue
                     ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UILabel {
   func setAttributedHtmlText(_ html: String) {
      if let attributedText = html.attributedHtmlString {
         self.attributedText = attributedText
      }
   }
}
