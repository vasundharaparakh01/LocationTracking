//
//  Extention+NevigationItem.swift
//  Intervallo
//
//  Created by amrut waghmare on 23/08/18.
//  Copyright © 2018 smartData. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    func setBackgroundImage(imageName:String){
            let navView = UIView()
           let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.sizeToFit()
        imageView.center = navView.center
        //imageView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        navView.addSubview(imageView)
        navView.sizeToFit()
        self.titleView = navView
    }
    
    
    func setImageWithTitle(imageName:String, title:String){
        let navView = UIView()

        // Create the label
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.white
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center

        // Create the image view
        let imageview = UIImageView()
        imageview.image = UIImage(named: imageName)

        // To maintain the image's aspect ratio:
        let imageAspect = imageview.image!.size.width/imageview.image!.size.height

        // Setting the image's frame so that it's immediately before the text:
        imageview.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        imageview.contentMode = UIView.ContentMode.scaleAspectFit

        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(imageview)
        navView.sizeToFit()
        // Set the navigation bar's navigation item's titleView to the navView
        self.titleView = navView


    }
}
