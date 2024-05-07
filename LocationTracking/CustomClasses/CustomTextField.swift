//
//  CustomTextField.swift
//  Intervallo
//
//  Created by Subhash Kumar on 8/20/18.
//  Copyright © 2018 smartData. All rights reserved.
//

import UIKit

class CustomTextField: UITextField ,UITextFieldDelegate{

   
    override func draw(_ rect: CGRect) {
        self.delegate               = self
        self.cornerRadius           = 8
        self.layer.masksToBounds    = true
        self.layer.borderWidth      = 1
        self.layer.borderColor      = UIColor.gray.cgColor
    }
    
  public  func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return true
    }

 public   func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
 public   func textFieldDidBeginEditing(_ textField: UITextField) {
   //self.perform(#selector(updateColor), with: nil, afterDelay: 0.1)
    }
 
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
      //  self.perform(#selector(updateColor), with: nil, afterDelay: 0.1)
    }
    @objc func updateColor(){
//        self.layer.borderColor = self.isEditing ?  colorCode.LayerActiveBorderColor : colorCode.LayerBorderColor
//        self.textColor = self.isEditing ? colorCode.textActiveColor : colorCode.textColor
//        self.placeholderColor(self.isEditing ?  colorCode.textActiveColor : colorCode.textColor)
    }
}
extension UITextField {
    func placeholderColor(_ color: UIColor){
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
