//
//  Extensions+UIView.swift
//  NomadAviation
//
//  Created by Subhash Kumar on 7/19/18.
//  Copyright © 2018 Ratnadeep Govande. All rights reserved.
//

import UIKit
import AVFoundation


extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    public func setCorners(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds      = true
    }
    
    func setShadows(shadowColor: UIColor) {
        self.layer.masksToBounds    = false;
        self.layer.shadowColor      = shadowColor.cgColor;
        self.layer.shadowOpacity    = 0.4;
        self.layer.shadowRadius     = 3;
        self.layer.shadowOffset     = CGSize(width: 3, height: 3);
    }
    
    public func setBarderColor(borderColor: UIColor, borderWidth:CGFloat) {
        self.layer.borderWidth  = borderWidth
        self.layer.borderColor  = borderColor.cgColor
        self.clipsToBounds      = true
    }
    
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue               = toValue
        animation.duration              = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode              = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable class GradientView: UIView {
    
//    @IBInspectable var topColor: UIColor = UIColor.init(red: 25.0/255.0, green: 118.0/255.0, blue: 159.0/255.0, alpha: 1.0)
//    @IBInspectable var bottomColor: UIColor = UIColor.init(red: 53.0/255.0, green: 216.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [Color.buttonTopColor, Color.buttonBottomColor]
    }
}

@IBDesignable class GradientViewFromLeft: UIView {
    
    @IBInspectable var topColor: UIColor = UIColor.init(red: 25.0/255.0, green: 118.0/255.0, blue: 159.0/255.0, alpha: 1.0)
    @IBInspectable var bottomColor: UIColor = UIColor.init(red: 53.0/255.0, green: 216.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.0, y: 0.0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x: 1.0, y: 0.0)
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}


extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
   
//    @IBInspectable
//    var GradientLayer :CAGradientLayer?{
//        gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.view.bounds
//        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.white.cgColor]
//        self.view.layer.addSublayer(gradientLayer)
//    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
