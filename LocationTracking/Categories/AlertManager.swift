//
//  AlertManager.swift
//  Test_Rest_Library
//
//  Created by Sumeet Jain on 26/08/16.
//  Copyright © 2016 Sumit Jain. All rights reserved.
//

import UIKit

public typealias BlankBlock = () -> Void

open class AlertButton: Any {
    fileprivate(set) var style = UIAlertAction.Style.default
    fileprivate(set) var title = "OK"
    fileprivate(set) var buttonClicked: BlankBlock? = nil
    
    init(style: UIAlertAction.Style = .default, title: String = "OK", buttonClicked: BlankBlock? = nil) {
        self.style = style
        self.title = title
        self.buttonClicked = buttonClicked
    }
}

open class AlertManager: Any {
    
    public typealias ButtonClickedResponse = (_ clickedIndex: Int) -> Void
    
    //MARK: ALERT VIEW
    open class func showOKAlert(_ type: UIAlertAction.Style = .default, withTitle title: String?, withMessage message: String?, onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: BlankBlock? = nil, returnBlock: ButtonClickedResponse? = nil) -> UIAlertController {
        return showAlertWithSimilarButtonsType(type, withTitle: title, withMessage: message, buttonsTitles: ["OK"], onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    open class func showAlertWithSimilarButtonsType(_ type: UIAlertAction.Style = .default, withTitle title: String?, withMessage message: String?, buttonsTitles:[String], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: BlankBlock? = nil, returnBlock: ButtonClickedResponse? = nil) -> UIAlertController {
        var actions = [AlertButton]()
        for title in buttonsTitles {
            actions.append(AlertButton(style: type, title: title))
        }
        
        return showAlert(withTitle: title, withMessage: message, buttons: actions, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    open class func showAlert(withTitle title: String?, withMessage message: String?, buttons:[AlertButton], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: (() -> Void)? = nil, returnBlock:ButtonClickedResponse? = nil) -> UIAlertController {
        return _presentWithStyle(.alert, withTitle: title, withMessage: message, buttons: buttons, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    //MARK: IMPLEMENTATION
    fileprivate class func _presentWithStyle(_ style: UIAlertController.Style, withTitle title: String?, withMessage message: String?, buttons:[AlertButton], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: (() -> Void)? = nil, returnBlock:ButtonClickedResponse? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for (index, button) in buttons.enumerated() {
            let action = UIAlertAction(title: button.title, style: button.style, handler: { (action) in
                if let buttonButtonClicked = button.buttonClicked {
                    buttonButtonClicked()
                }
                if let returnBlock = returnBlock {
                    returnBlock(index)
                }
            })
            
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            
            if (UIDevice.current.userInterfaceIdiom == .pad){
                if alert.responds(to: #selector(getter: vc.popoverPresentationController)) {
                    alert.popoverPresentationController?.sourceView = vc.view
                    
                    alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: Device.height, width: Device.width, height: 320)
                    vc.present(alert, animated: true, completion: presentationCompletionHandler)
                }
            }else{
                alert.modalPresentationStyle = .popover
                vc.present(alert, animated: true, completion: presentationCompletionHandler)
            }
            
            // vc.present(alert, animated: animatedly, completion: presentationCompletionHandler)
        }
        
        return alert
    }
    
    //MARK: ACTION SHEET
    open class func showActionSheet(withTitle title: String?, withMessage message: String?, buttons:[AlertButton], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: (() -> Void)? = nil, returnBlock:ButtonClickedResponse? = nil) -> UIAlertController {
        return _presentWithStyle(.actionSheet, withTitle: title, withMessage: message, buttons: buttons, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    open class func showActionSheetWithSimilarButtonsType(_ type: UIAlertAction.Style = .default, withTitle title: String?, withMessage message: String?, buttonsTitles:[String], onViewController vc: UIViewController, animatedly: Bool = true, presentationCompletionHandler: BlankBlock? = nil, returnBlock:@escaping ButtonClickedResponse) -> UIAlertController {
        var actions = [AlertButton]()
        for title in buttonsTitles {
            actions.append(AlertButton(style: type, title: title))
        }
        
        return showActionSheet(withTitle: title, withMessage: message, buttons: actions, onViewController: vc, animatedly: animatedly, presentationCompletionHandler: presentationCompletionHandler, returnBlock: returnBlock)
    }
    
    static  func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    static func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^[0-9]*$"
        let phoneTest   = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result      =  phoneTest.evaluate(with: value)
        return result
    }
    static func getLblHeightWithWidth(lblWidth:CGFloat, withFontSize size:CGFloat, andWithText text : String) -> CGFloat
    {
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: lblWidth, height: 0))
        lbl.text            = text
        lbl.font            = UIFont(name: "BrandonText-Regular", size: size)
        lbl.numberOfLines   = 0
        lbl.lineBreakMode   = .byWordWrapping
        lbl.sizeToFit()
        return lbl.frame.size.height
    }
 
}
