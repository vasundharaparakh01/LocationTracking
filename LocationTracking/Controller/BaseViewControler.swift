//
//  BaseViewControler.swift
//  iOSArchitecture
//
//  Created by Amit on 24/02/18.
//  Copyright © 2018 smartData. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class BaseViewControler: UIViewController,NVActivityIndicatorViewable {
    
    let animationType:NVActivityIndicatorType = NVActivityIndicatorType.lineScalePulseOut
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor              = .white
        self.navigationController?.navigationBar.barTintColor           = Color.navigationbartint
        self.navigationController?.navigationBar.titleTextAttributes    = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = Color.statusbarcolor
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             if let StatusbarView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                 StatusbarView.backgroundColor = Color.statusbarcolor
             }
        }

        
        /*
        if let StatusbarView = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            StatusbarView.backgroundColor = Color.statusbarcolor
        }*/
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // #Helper functions
    func showLoader() {
        startAnimating(CGSize(width: 50.0, height: 50.0), message: "", messageFont: nil, type: self.animationType, color:Color.indicatorcolor, padding: 0.0, displayTimeThreshold: 0, minimumDisplayTime: nil, backgroundColor: UIColor.lightText)
    }
    
    func hideLoader() {
        stopAnimating()
    }
    
    func showAlertmsg(with message: String) {
        UIAlertController.show(with: "APP_NAME".localized, message: message, preferredStyle:.alert, target: self, actions:[.Ok] , handler: nil)
    }
    
    func showAlert(with message:String) {
        AlertManager.showOKAlert(withTitle: "APP_NAME".localized, withMessage: message, onViewController: self).view.tintColor = Color.indicatorcolor
    }
    
    func openGoogleMap() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(Float(17.99)),\(Float(-22.99))&directionsmode=driving"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            if let url = URL(string: "https://maps.google.com/?q=@\(Float(17.99)),\(Float(-22.99))"), !url.absoluteString.isEmpty {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        switch(vc){
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        default:
            if let presentedViewController = vc.presentedViewController {
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                }
                else{
                    return vc;
                }
            }
            else{
                return vc;
            }
        }
    }
    
}

extension BaseViewControler {
    func convertImageToBase64(image: UIImage,with suffix:String) -> String {
        guard let imageData = image.pngData() else{
            return ""
        }
        let base64String = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        return "\(suffix)" + base64String
    }
}



extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}

