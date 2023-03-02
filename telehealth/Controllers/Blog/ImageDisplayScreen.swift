//
//  ImageDisplayScreen.swift
//  telehealth
//
//  Created by Apple on 07/09/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import UIKit
import ImageScrollView
import SDWebImage

class ImageDisplayScreen: UIViewController {

    
    var imageUrl = String()
    @IBOutlet weak var displayImageVZiew: ImageScrollView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        displayImageVZiew.imageContentMode = .aspectFit
        SDWebImageManager.shared.loadImage(with: NSURL.init(string: imageUrl ) as URL?, options: .continueInBackground, progress: { (recieved, expected, nil) in
            print(recieved,expected)
        }, completed: { (downloadedImage, data, error, SDImageCacheType, true, imageUrlString) in
            DispatchQueue.main.async { [self] in
                if downloadedImage != nil{
               
                    self.displayImageVZiew.display(image: downloadedImage!)
                }
            }
        })
        view.layoutIfNeeded()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
         Utility.setLocalizedValuesforView(parentview: self.view, isSubViews: true)
        if(Utility.getCurrentLanguage() == "ar"){
            backButton.setImage(#imageLiteral(resourceName: "back_icon_right"), for: .normal)
        }else{
            backButton.setImage(#imageLiteral(resourceName: "back_icon_black_color"), for: .normal)
        }
//        self.setupCollectionViewSelectMethod()
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }

  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
}
