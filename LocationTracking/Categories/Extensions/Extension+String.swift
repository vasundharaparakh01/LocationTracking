//
//  String+RUI.swift
//  FarmX
//
//  Created by Office on 4/23/18.
//  Copyright © 2018 Sumit Jain. All rights reserved.
//

import UIKit

extension String {
    func length() -> Int{
        return self.count
    }
        
    func removeWhiteSpaceAndNewLine() -> String {
        if self.length() > 0 {
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        return self
    }
    
    func sizeOfString (width: CGFloat = CGFloat.greatestFiniteMagnitude, font : UIFont, height: CGFloat = CGFloat.greatestFiniteMagnitude, drawingOption: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin) -> CGSize {
        return (self as NSString).boundingRect(with: CGSize(width: width, height: height), options: drawingOption, attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    func numberOfLinesForString(size: CGSize, font: UIFont) -> Int {
        let textStorage = NSTextStorage(string: self, attributes: [NSAttributedString.Key.font: font])
        
        let textContainer = NSTextContainer(size: size)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0
        
        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)
        
        var numberOfLines = 0
        var index = 0
        var lineRange : NSRange = NSMakeRange(0, 0)
        
        while index < layoutManager.numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        
        return numberOfLines
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with:self)
    }
    
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    
    func trimSpaces() -> String{
        if(self.length() > 0){
            return self.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        return self
    }
    
    func toBool() -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return false
        }
    }
    
    public static func isValidEmailID(checkString : String) -> Bool {
        let stricterFilterString : String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return emailTest.evaluate(with: checkString)
    }
    
    public static func isValidPincode(checkString : String) -> Bool{
        let stricterFilterString : String = "[1-9][0-9]{5}"
        let pincodeTest : NSPredicate = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        return pincodeTest.evaluate(with: checkString)
    }
    
    public static func appDateStringFormat(date: Date, dateFormat: String = "dd MMM, yyyy", locale: String = "en_US_POSIX") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: locale)
        formatter.dateFormat = dateFormat
        
        return formatter.string(from:date)
    }
    
    func dateFromFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func formatted() -> String {
        let array = self.components(separatedBy: ".")
        let str  = array[0]
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        formatter.currencySymbol = ""
        let int98: Int = Int(str)!
        var last = array.count == 1 ? "" : ".\(array[1])"
        var new = "\(formatter.string(from: NSNumber(integerLiteral: int98))!)"
        if last.count > 0{
            let array = new.components(separatedBy: ".")
            let str  = array.first
            new = str!
            if last.count == 2{
                last = last + "0"
            }
        }
        return new + last
    }
    
    public var trimmedTextCount: Int {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).count
    }
    
    func formatetedPrice() -> String {
        
        let array = self.components(separatedBy: ".")
        let str  = array[0]
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = NSLocale.current
        formatter.currencySymbol = ""
        if array.count > 1, Int(array[1])! > 0{
            return str + ".\(array[1])"
        } else {
            return str
        }
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        let newStr = String(self[..<self.index(self.startIndex, offsetBy: from)])
        return newStr
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
