//
//  CustomSegmentedButton.swift
//  InchoraApp
//
//  Created by Shubash Kumar on 11/16/18.
//  Copyright © 2018 Subhash Kumar. All rights reserved.
//
import Foundation
import UIKit

class CustomSegmentedButton: UIButton {

    let border = UIView()
        
    //MARK: Overriden Functions
    override func draw(_ rect: CGRect) {
        self.border.frame = CGRect(x:self.frame.minX, y: self.frame.maxY+1.0, width : self.frame.size.width, height: 0.5)
        if self.isSelected {
            self.border.backgroundColor = UIColor(red: 46/255, green: 58/255, blue: 61/255, alpha: 1.0)
        } else {
            self.border.backgroundColor = UIColor(red: 234/255, green: 235/255, blue: 236/255, alpha: 1.0)
        }
        self.superview?.addSubview(self.border)
        self.tintColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
    }
}
