//
//  Extension+Button.swift
//  NomadAviation
//
//  Created by Subhash Kumar on 7/19/18.
//  Copyright © 2018 Ratnadeep Govande. All rights reserved.
//

import UIKit
import AVFoundation


public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    func setNormalTitle(_ str: String) {
        self.setTitle(str, for: .normal)
    }
    
    public func setCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds      = true
    }
    
    public func setBorderColor(_ borderColor: UIColor, borderWidth:CGFloat) {
        self.layer.borderWidth  = borderWidth
        self.layer.borderColor  = borderColor.cgColor
        self.clipsToBounds      = true
    }
   
    func leftImage(image: UIImage) {
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width+10)
    }
    
    func setShadow(shadowColor: UIColor) {
        self.layer.masksToBounds    = false;
        self.layer.shadowColor      = shadowColor.cgColor;
        self.layer.shadowOpacity    = 0.8;
        self.layer.shadowRadius     = 6;
        self.layer.shadowOffset     = CGSize(width: 6, height: 6);
    }
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        self.layer.addSublayer(border)
    }
    
    func set(_ image: UIImage?, title: String, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        positionLabelRespectToImage(title, position: titlePosition, spacing: additionalSpacing)
        titleLabel?.contentMode = .left
        setTitle(title, for: state)
    }
    
    private func positionLabelRespectToImage(_ title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key : titleFont])
        arrange(titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func arrange(_ titleSize: CGSize, imageRect:CGRect, atPosition position: UIView.ContentMode, withSpacing spacing: CGFloat) {
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        switch (position) {
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        titleEdgeInsets = titleInsets
        imageEdgeInsets = imageInsets
    }
}


@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable class GradientButton: UIButton {
    
    @IBInspectable var topColor: UIColor    = Color.buttonTopColor
    @IBInspectable var bottomColor: UIColor = Color.buttonBottomColor
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors          = [topColor.cgColor, bottomColor.cgColor]
          (layer as! CAGradientLayer).startPoint    = CGPoint(x: 0.0, y: 0.5)
          (layer as! CAGradientLayer).endPoint      = CGPoint(x: 1.0, y: 0.5)
    }
}


