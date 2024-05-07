//
//  CustomAssessmentTextField.swift
//  InchoraApp
//
//  Created by Shubash Kumar on 10/24/18.
//  Copyright © 2018 Subhash Kumar. All rights reserved.
//

import UIKit

class CustomAssessmentTextField: UITextField,UITextFieldDelegate {

    override func draw(_ rect: CGRect) {
        self.delegate               = self
        self.layer.masksToBounds    = true
        self.layer.borderWidth      = 2
        self.textColor              = (UIColor.init(red: 210.0/255.0, green: 224.0/255.0, blue: 225.0/255.0, alpha: 1.0))
        self.tintColor              = (UIColor.init(red: 210.0/255.0, green: 224.0/255.0, blue: 225.0/255.0, alpha: 1.0))
        self.placeholderColor(UIColor.init(red: 210.0/255.0, green: 224.0/255.0, blue: 225.0/255.0, alpha: 1.0))
        self.textAlignment          = .center
        if self.tag == 12345 {
            self.textAlignment = .left
        }
        
    }
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         var maxLength = 2
        if self.tag == 12345 {
            maxLength = 4
        }
        let aSet                = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet  = string.components(separatedBy: aSet)
        let numberFiltered      = compSepByCharInSet.joined(separator: "")
        //  var string = numberFiltered
        
        let currentText = self.text ?? ""
        guard let stringRange   = Range(range, in: currentText) else { return false }
        let updatedText         = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count <= maxLength {
            return string == numberFiltered
        }
        return false
    }
    
}
