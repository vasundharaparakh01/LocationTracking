//
//  Extensions.swift
//  NomadAviation
//
//  Created by Subhash Kumar on 27/06/18.
//  Copyright © 2018 Subhash Kumar. All rights reserved.
//


import UIKit
import AVFoundation


//MARK:-- UIScrollView Extension:----
extension UIScrollView {
    
    func resizeScrollViewContentSize() {
        var contentRect = CGRect.zero
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}
//MARK:-- UIColor Extension:----
extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String  = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex       = String(hex[..<index])//hex.substring(from: index)
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            //print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
//MARK:-- UIImageView Extension:----
    
        extension UIImageView {
            func setRandomDownloadImage(_ width: Int, height: Int) {
                if self.image != nil {
                    self.alpha = 1
                    return
                }
                self.alpha = 0
                let url = URL(string: "http://lorempixel.com/\(width)/\(height)/")!
                let configuration = URLSessionConfiguration.default
                configuration.timeoutIntervalForRequest = 15
                configuration.timeoutIntervalForResource = 15
                configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
                let session = URLSession(configuration: configuration)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode / 100 != 2 {
                            return
                        }
                        if let data = data, let image = UIImage(data: data) {
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.image = image
                                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                    self.alpha = 1
                                }, completion: { (finished: Bool) -> Void in
                                })
                            })
                        }
                    }
                }
                task.resume()
            }
            
            func clipParallaxEffect(_ baseImage: UIImage?, screenSize: CGSize, displayHeight: CGFloat) {
                if let baseImage = baseImage {
                    if displayHeight < 0 {
                        return
                    }
                    let aspect: CGFloat = screenSize.width / screenSize.height
                    let imageSize = baseImage.size
                    let imageScale: CGFloat = imageSize.height / screenSize.height
                    
                    let cropWidth: CGFloat = floor(aspect < 1.0 ? imageSize.width * aspect : imageSize.width)
                    let cropHeight: CGFloat = floor(displayHeight * imageScale)
                    
                    let left: CGFloat = (imageSize.width - cropWidth) / 2
                    let top: CGFloat = (imageSize.height - cropHeight) / 2
                    
                    let trimRect : CGRect = CGRect(x: left, y: top, width: cropWidth, height: cropHeight)
                    self.image = baseImage.trim(trimRect: trimRect)
                    self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: displayHeight)
                }
            }
            
            public func setCornerRound() {
                self.layer.cornerRadius = self.frame.size.width / 2.0
                self.clipsToBounds = true
            }
            
            public func setCorner(_ radius:CGFloat) {
                self.layer.cornerRadius = radius
                self.clipsToBounds = true
            }
            
            func setShadow(shadowColor: UIColor) {
                self.layer.masksToBounds = false;
                self.layer.shadowColor = shadowColor.cgColor;
                self.layer.shadowOpacity = 0.8;
                self.layer.shadowRadius = 6;
                self.layer.shadowOffset = CGSize(width: 6, height: 6);
            }
            
            public func setBarder(borderColor: UIColor, borderWidth:CGFloat) {
                self.layer.borderWidth = borderWidth
                self.layer.borderColor = borderColor.cgColor
                self.clipsToBounds = true
            }
        }
    

extension UIImage {
  
        func resizeWithPercent(percentage: CGFloat) -> UIImage? {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
            imageView.contentMode = .scaleAspectFit
            imageView.image = self
            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            imageView.layer.render(in: context)
            guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return result
    }

        func resizeWithWidth(width: CGFloat) -> UIImage? {
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
            imageView.contentMode = .scaleAspectFit
            imageView.image = self
            UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            imageView.layer.render(in: context)
            guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
            UIGraphicsEndImageContext()
            return result
        }
    
    func trim(trimRect :CGRect) -> UIImage {
        if CGRect(origin: CGPoint.zero, size: self.size).contains(trimRect) {
            if let imageRef = self.cgImage?.cropping(to: trimRect) {
                return UIImage(cgImage: imageRef)
            }
        }
        UIGraphicsBeginImageContextWithOptions(trimRect.size, true, self.scale)
        self.draw(in: CGRect(x: -trimRect.minX, y: -trimRect.minY, width: self.size.width, height: self.size.height))
        let trimmedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = trimmedImage else { return self }
        
        return image
    }
    func resizedImage(newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /// Resize image, keep the aspect ratio
    func resizedImageWithAspectFit(newSize:CGSize) -> UIImage {
        // Resize with aspect
        var resizeFactor = size.width / newSize.width
        if size.height > size.width {
            // But if height is bigger
            resizeFactor = size.height / newSize.height
        }
        let newSizeFixedAspect = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSizeFixedAspect)
        return resized
    }
}

//MARK:-- UITableView Extension:----
 extension UITableView {
    
    func registerCellClass(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = String.className(cellClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewClass(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        self.register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderFooterViewNib(_ viewClass: AnyClass) {
        let identifier = String.className(viewClass)
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
//MARK:-- UILabel Extension:----
extension UILabel {
    public func setCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))// 10 padding
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

@IBDesignable
class DesignableLabel: UILabel {
}

//MARK:-- FileManager Extension:----
extension FileManager {
    
    class func documentsDirectory() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    class func cachesDirectory() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        return paths[0]
    }
}

