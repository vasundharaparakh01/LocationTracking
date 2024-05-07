//
//  UIAlertController.swift
//  Patient
//
//  Created by Amit Kumar Shukla on 5/14/18.
//  Copyright © 2018 Amit Kumar Shukla. All rights reserved.
//

import Foundation
import UIKit

enum AlertAction:String {
    case Ok
    case Cancel
    case Yes
    case No
    case Delete
    case Add
    case Setting
    
    var title:String {
        switch self {
        case .Ok:
            return NSLocalizedString("OK", comment: "Ok")
        case .Cancel:
            return NSLocalizedString("CANCEL", comment: "Cancel")
        case .Yes:
            return NSLocalizedString("YES", comment: "Yes")
        case .No:
            return NSLocalizedString("NO", comment: "No")
        case .Delete:
            return NSLocalizedString("DELETE", comment: "Delete")
        case .Setting:
            return NSLocalizedString("SETTINGS", comment: "Setting")
        default:
            return NSLocalizedString("ADD", comment: "Add")
        }
    }
    
    var style:UIAlertAction.Style {
        switch self {
        case .Cancel:
            return .cancel
        case .Delete:
            return .destructive
        default:
            return .default
        }
    }
    
}

typealias AlertHandler = (_ action:AlertAction) -> Void

extension UIAlertController {
    
    class func show(with title:String?,message:String?,preferredStyle:UIAlertController.Style,target:UIViewController?,actions:[AlertAction],handler:AlertHandler?){

        let alertControler = UIAlertController(title: title ?? Bundle.main.displayName, message: message, preferredStyle: preferredStyle)
        for arg in actions {
            let action = UIAlertAction(title: arg.title, style: arg.style, handler: { (action) in
                handler?(arg)
            })
            alertControler.addAction(action)
        }
        
        if let popoverController = alertControler.popoverPresentationController {
            popoverController.sourceView = target?.view
            popoverController.permittedArrowDirections = []
            if let sourceView = target?.view {
                popoverController.sourceRect = CGRect(x: sourceView.bounds.midX, y: sourceView.bounds.midY, width: 0, height: 0)
            } else {
                popoverController.sourceRect = CGRect.zero
            }
        }
        let presenter = target ?? UIApplication.topViewController()
        presenter?.present(alertControler, animated: true, completion: nil)
    }
}
