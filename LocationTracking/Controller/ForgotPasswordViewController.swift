//
//  ForgotPasswordViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/14/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewControler,UINavigationControllerDelegate {

    @IBOutlet weak var txtemail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func popViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Btn Action
    @IBAction func btnsubmit(_ sender: Any) {
          guard let email = txtemail.text, !email.isEmpty else {
             return self.showAlertmsg(with: "EMAIL_ALERT".localized)
        }
        guard email.isValidEmail else {
            return self.showAlertmsg(with: "EMAIL_NOT_CORRECT".localized)
        }
        frogotpassword(with: email)
    }
    
    //MARK: API Call

    func frogotpassword(with email:String)  {
        let service = UserService()
        service.forgotPassword(with: email, target: self, complition:{ (response) in
            DispatchQueue.main.async {
                if let message = response {
                        UIAlertController.show(with: "APP_NAME".localized, message: message, preferredStyle: .alert, target: self, actions: [.Ok]) { (action) in
                            switch action {
                            case .Ok:
                                self.navigationController?.popViewController(animated: true)
                            default:
                                print("No Action")
                            }
                        }
                    }
            }
        })
    }
    
}
    
    

