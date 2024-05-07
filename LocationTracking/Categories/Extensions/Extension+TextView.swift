//
//  Extension+TextView.swift
//  NomadAviation
//
//  Created by Subhash Kumar on 7/19/18.
//  Copyright © 2018 Ratnadeep Govande. All rights reserved.
//

import UIKit
import AVFoundation


extension UITextView {
    
    public var isEmpty: Bool {
        return text?.isEmpty == true
    }
    
    public var trimmedTextCount: Int {
        return text!.trimmingCharacters(in: .whitespacesAndNewlines).count
    }
    
    public var hasValidEmail: Bool {
        return text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }
    
    public var hasValidMobile: Bool {
        let PHONE_REGEX = "^[0-9]*$"
        let phoneTest   = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result      =  phoneTest.evaluate(with: self.text)
        return result
    }
    
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    public func setCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
}


extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText     = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel     = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text   = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX      = self.textContainer.lineFragmentPadding
            let labelY      = self.textContainerInset.top - 2
            let labelWidth  = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font       = self.font
        placeholderLabel.textColor  = UIColor.darkGray
        placeholderLabel.tag        = 100
        
        placeholderLabel.isHidden   = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
