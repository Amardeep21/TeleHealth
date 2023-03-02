//
//  BSLoader.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 07.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

let loaderSpinnerMarginSideForTransactio : CGFloat = 35.0
let loaderSpinnerMarginTopForTransactio : CGFloat = 20.0
let loaderTitleMarginForTransactio : CGFloat = 5.0

public class SwiftLoaderForTransaction: UIView {
    
    private var coverVieww : UIView?
    private var titleLabell : UILabel?
    private var loadingViewForTransaction : SwiftLoadingView?
    private var animatedForTansaction : Bool = true
    private var canUpdated = false
    private var title: String?
    private var speed = 1
    
    private var config : Config = Config() {
        didSet {
            self.loadingViewForTransaction?.config = config
            
        }
    }
    
    @objc func rotated(notification: NSNotification) {
        
        let loader = SwiftLoaderForTransaction.sharedInstance
        
        let height : CGFloat = UIScreen.main.bounds.size.height
        let width : CGFloat = UIScreen.main.bounds.size.width
        let center : CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        loader.coverVieww?.frame = UIScreen.main.bounds
    }
    
    override public var frame : CGRect {
        didSet {
            self.update()
        }
    }
    
    class var sharedInstance: SwiftLoaderForTransaction {
        struct Singleton {
            static let instance = SwiftLoaderForTransaction(frame: CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: Config().size,height: Config().size)))
        }
        return Singleton.instance
    }
    
    public class func show(animated: Bool) {
        self.show(title: nil, animated: animated)
    }
    
    public class func show(title: String?, animated : Bool) {
        
        let currentWindow : UIWindow = UIApplication.shared.keyWindow!
        
        let loader = SwiftLoaderForTransaction.sharedInstance
        loader.canUpdated = true
        loader.animatedForTansaction = animated
        loader.title = title
        loader.update()
        
        NotificationCenter.default.addObserver(loader, selector: #selector(loader.rotated(notification: )),
                                               name: UIDevice.orientationDidChangeNotification,
                                                object: nil)
        
        let height : CGFloat = UIScreen.main.bounds.size.height
        let width : CGFloat = UIScreen.main.bounds.size.width
        let center : CGPoint = CGPoint(x: width / 2.0, y: height / 2.0)
        
        loader.center = center
        
        if (loader.superview == nil) {
            loader.coverVieww = UIView(frame: currentWindow.bounds)
            loader.coverVieww?.backgroundColor = loader.config.foregroundColor.withAlphaComponent(loader.config.foregroundAlpha)
            
            currentWindow.addSubview(loader.coverVieww!)
            currentWindow.addSubview(loader)
            loader.start()
        }
    }
    
    public class func hide() {
        
        let loader = SwiftLoaderForTransaction.sharedInstance
        NotificationCenter.default.removeObserver(loader)
        
        loader.stop()
    }
    
    public class func setConfig(config : Config) {
        let loader = SwiftLoaderForTransaction.sharedInstance
        loader.config = config
        loader.frame = CGRect(origin: CGPoint(x: 0, y: 0),size: CGSize(width: loader.config.size, height: loader.config.size))
        
    }
    
    /**
     Private methods
     */
    
    private func setup() {
        self.alpha = 0
        self.update()
    }
    
    private func start() {
        self.loadingViewForTransaction?.start()
        
        if (self.animatedForTansaction) {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.alpha = 1
                }, completion: { (finished) -> Void in
                    
            });
        } else {
            self.alpha = 1
        }
    }
    
    private func stop() {

        if (self.animatedForTansaction) {
            DispatchQueue.main.async {
                self.removeFromSuperview()
                self.coverVieww?.removeFromSuperview()
                self.loadingViewForTransaction?.stop()
            }

//            UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                self.alpha = 0
//                }, completion: { (finished) -> Void in
//                    self.removeFromSuperview()
//                    self.coverView?.removeFromSuperview()
//                    self.loadingView?.stop()
//            });
        } else {
            self.alpha = 0
            self.removeFromSuperview()
            self.coverVieww?.removeFromSuperview()
            self.loadingViewForTransaction?.stop()
        }
    }
//    private func stop() {
//           
//           if (self.animatedForTansaction) {
//               UIView.animate(withDuration: 0.3, animations: { () -> Void in
//                   self.alpha = 0
//                   }, completion: { (finished) -> Void in
//                       self.removeFromSuperview()
//                       self.coverVieww?.removeFromSuperview()
//                       self.loadingViewForTransaction?.stop()
//               });
//           } else {
//               self.alpha = 0
//               self.removeFromSuperview()
//               self.coverVieww?.removeFromSuperview()
//               self.loadingViewForTransaction?.stop()
//           }
//       }
    
    private func update() {
//        self.backgroundColor = self.config.backgroundColor
        self.backgroundColor = self.config.foregroundColor
        self.layer.cornerRadius = self.config.cornerRadius
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSideForTransactio * 2)
        
        if (self.loadingViewForTransaction == nil) {
            self.loadingViewForTransaction = SwiftLoadingView(frame: self.frameForSpinner())
            self.addSubview(self.loadingViewForTransaction!)
        } else {
            self.loadingViewForTransaction?.frame = self.frameForSpinner()
        }
        
        if (self.titleLabell == nil) {
            self.titleLabell = UILabel(frame: CGRect(origin: CGPoint(x: loaderTitleMarginForTransactio, y: loaderSpinnerMarginTopForTransactio + loadingViewSize), size: CGSize(width: self.frame.width - loaderTitleMarginForTransactio*2, height:  42.0)))
            self.addSubview(self.titleLabell!)
            self.titleLabell?.numberOfLines = 1
            self.titleLabell?.textAlignment = NSTextAlignment.center
            self.titleLabell?.adjustsFontSizeToFitWidth = true
        } else {
            self.titleLabell?.frame = CGRect(origin: CGPoint(x: loaderTitleMarginForTransactio, y: loaderSpinnerMarginTopForTransactio + loadingViewSize), size: CGSize(width: self.frame.width - loaderTitleMarginForTransactio*2, height: 42.0))
        }
        
        self.titleLabell?.font = self.config.titleTextFont
        self.titleLabell?.textColor = self.config.titleTextColor
        self.titleLabell?.text = self.title
        
        self.titleLabell?.isHidden = self.title == nil
    }
    
    func frameForSpinner() -> CGRect {
        let loadingViewSize = self.frame.size.width - (loaderSpinnerMarginSideForTransactio * 2)
        
        if (self.title == nil) {
            let yOffset = (self.frame.size.height - loadingViewSize) / 2
            return CGRect(origin: CGPoint(x: loaderSpinnerMarginSideForTransactio, y: yOffset), size: CGSize(width: loadingViewSize, height: loadingViewSize))
        }
        return CGRect(origin: CGPoint(x: loaderSpinnerMarginSideForTransactio, y: loaderSpinnerMarginTopForTransactio), size: CGSize(width: loadingViewSize, height: loadingViewSize))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     *  Loader View
     */
    class SwiftLoadingView : UIView {
        
        private var speed : Int?
        private var lineWidth : Float?
        private var lineTintColor : UIColor?
        private var backgroundLayer : CAShapeLayer?
        private var isSpinning : Bool?
        
        var config : Config = Config() {
            didSet {
                self.update()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        /**
         Setup loading view
         */
        
        func setup() {
            self.backgroundColor = UIColor.clear
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
            
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.cgColor
            self.backgroundLayer?.lineCap = CAShapeLayerLineCap.round
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        func update() {
            self.lineWidth = self.config.spinnerLineWidth
            self.speed = self.config.speed
            
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.backgroundLayer?.strokeColor = self.config.spinnerColor.cgColor
        }
        
        /**
         Draw Circle
         */
        
        override func draw(_ rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        func drawBackgroundCircle(partial : Bool) {
            let startAngle : CGFloat = CGFloat.pi / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat.pi) + startAngle
            
            let center : CGPoint = CGPoint(x: self.bounds.size.width / 2,y: self.bounds.size.height / 2)
            let radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            let processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat.pi) + startAngle
            }
            
            processBackgroundPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.cgPath;
        }
        
        /**
         Start and stop spinning
         */
        
        func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(partial: true)
            
            let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
            rotationAnimation.duration = 1;
            rotationAnimation.isCumulative = true;
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.add(rotationAnimation, forKey: "rotationAnimation")
        }
        
        func stop() {
            self.drawBackgroundCircle(partial: false)
            
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
    
    
    /**
     * Loader config
     */
    public struct Config {
        
        /**
         *  Size of loader
         */
        public var size : CGFloat = 120.0
        
        /**
         *  Color of spinner view
         */
        public var spinnerColor = UIColor.black
        
        /**
         *  S
         */
        public var spinnerLineWidth :Float = 1.0
        
        /**
         *  Color of title text
         */
        public var titleTextColor = UIColor.black
        
        /**
         *  Speed of the spinner
         */
        public var speed :Int = 1
        
        /**
         *  Font for title text in loader
         */
        public var titleTextFont : UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        
        /**
         *  Background color for loader
         */
        public var backgroundColor = UIColor.white
        
        /**
         *  Foreground color
         */
        public var foregroundColor = UIColor.lightGray //dimple
        
        /**
         *  Foreground alpha CGFloat, between 0.0 and 1.0
         */
        public var foregroundAlpha:CGFloat = 0.0
        
        /**
         *  Corner radius for loader
         */
        public var cornerRadius : CGFloat = 10.0
        
        public init() {}
        
    }
}

