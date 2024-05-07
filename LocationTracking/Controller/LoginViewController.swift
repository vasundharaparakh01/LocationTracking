//
//  ViewController.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/14/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewControler {
    
    @IBOutlet weak var txtusername      : UITextField!
    @IBOutlet weak var txtpassword      : UITextField!
    @IBOutlet weak var btnrememberme    : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let num = ["aaaa"]
//        self.txtusername.text = num[1]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (AppInstance.shared.kUserDefault.value(forKey: "krememberMe") as? Bool) == true {
            self.txtusername.text           = AppInstance.shared.kUserDefault.value(forKey: "kusername") as? String
            self.txtpassword.text           = AppInstance.shared.kUserDefault.value(forKey: "kpassword") as? String
            self.btnrememberme.isSelected   = (AppInstance.shared.kUserDefault.value(forKey: "krememberMe") as? Bool) ?? false
        } else {
            self.txtusername.text           = ""
            self.txtpassword.text           = ""
            self.btnrememberme.isSelected   = false
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: Btn Action
    @IBAction func btnforgotpasswordtapped(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: Identifiers.Controler.frogotpass) as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnremembermetapped(_ sender: Any) {
        btnrememberme.isSelected = !btnrememberme.isSelected
    }
    
    @IBAction func btnlogintapped(_ sender: Any) {
        guard let username = txtusername.text, !username.isEmpty else {
            return self.showAlertmsg(with: "USERNAME_ALERT".localized)
        }
        
        guard let password = txtpassword.text, !password.isEmpty else {
            return self.showAlertmsg(with: "PASSWORD_ALERT".localized)
        }
        loginAPI(with: username, password: password)
    }
    
    func setUserCredentials() {
        AppInstance.shared.kUserDefault.setValue(self.txtusername.text!, forKeyPath: "kusername")
        AppInstance.shared.kUserDefault.setValue(self.txtpassword.text!, forKeyPath: "kpassword")
        AppInstance.shared.kUserDefault.setValue(self.btnrememberme.isSelected, forKey: "krememberMe")
    }
    
    //MARK: API Call
    
    func loginAPI(with username:String,password:String)  {
        txtpassword.resignFirstResponder()
        txtusername.resignFirstResponder()
        let service = UserService()
        service.doLogin(with: username, password: password, platform_name: "iOS", UUID: UIDevice.current.identifierForVendor!.uuidString, device_token: AppInstance.shared.deviceToken ?? "" , target: self, complition:{ (response) in
            DispatchQueue.main.async {
                if response != nil{
                    AppInstance.shared.user = response
                    UserDefaults.standard.set(response?.dictionaryRepresentation(), forKey: "userObj")
                    self.setUserCredentials()
                    UIUtility.addDashboardTabBarController()
                }
            }
        })
    }
    
    
}

