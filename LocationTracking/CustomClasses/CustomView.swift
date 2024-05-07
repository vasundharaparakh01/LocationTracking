//
//  CustomView.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/27/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit

class CustomView: UIView {

    @IBInspectable  var color:UIColor = .white {
        didSet {
            self.backgroundColor = self.color
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    func initialize() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
   
