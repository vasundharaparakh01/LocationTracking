//
//  CustomButton.swift
//  Intervallo
//
//  Created by Subhash Kumar on 8/20/18.
//  Copyright © 2018 smartData. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
   @IBInspectable  var color:UIColor = .gray {
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
        self.setTitleColor(.white, for: .normal)
    }
}
