//
//  LoginAPIManager.swift
//  iOSArchitecture
//
//  Created by Amit on 23/02/18.
//  Copyright © 2018 smartData. All rights reserved.
//

import Foundation
import UIKit

public class UserService:APIService {
    
    // #show and hide loader in this class depending on your needs.
    // #you can make service class according to module
    // #show errors in this class, if you have any need where you want to show in controller class, then just by-pass error method.
 
    func doLogin(with username: String, password: String, platform_name: String, UUID: String, device_token: String, target: BaseViewControler? = nil, complition: @escaping (User?) -> Void){
        let param = ["username": username, "password": password, "deviceType": "iOS", "deviceId": UIDevice.current.identifierForVendor!.uuidString, "deviceToken":  AppInstance.shared.deviceToken ?? "bcvhgcghk"]
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.login, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    // #parse response here
                    if let data = response["data"] as? Dictionary<String,Any> {
                        let user = User(dictionary: data)
                        complition(user)
                    } else {
                        complition(nil)
                    }
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition(nil)
                }
            }
        }
    }
    
    func forgotPassword(with email: String, target: BaseViewControler? = nil, complition:@escaping (String?) -> Void){
        let param : [String: Any] = ["email": email]
        target?.showLoader()
        super.startService(with: .POST, path: Config.forgotpassword, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    // #parse response here
                   complition(response["message"] as? String)
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition(nil)
                }
            }
        }
    }
    
    func logOut(with userid: String, target: BaseViewControler? = nil, complition: @escaping (String?) -> Void){
        let param = ["userId": userid, "deviceToken": AppInstance.shared.deviceToken ?? "bcvhgcghk"]
        target?.showLoader()
        super.startService(with: .POST, path: Config.logout, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                    switch result {
                    case .Success(let response):
                        complition(response["message"] as? String)
                    case .Error(let error):
                        target?.showAlert(with: error)
                        complition(nil)
                    }
            }
        }
    }
    
    func getTerms(target: BaseViewControler? = nil, complition: @escaping (String?) -> Void){
        let params = [
          "code": 0,
          "status": "string",
          "message": "string"
            ] as [String : Any]
        target?.showLoader()
        super.startService(with: .GET, path: Config.getTerms, parameters: nil, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                    switch result {
                    case .Success(let response):
                        if let data = response["data"] as? Dictionary<String,Any> {
                            let termsString = data["termData"] as? String ?? ""
                            complition(termsString)
                        } else {
                            complition(nil)
                        }
                    case .Error(let error):
                        target?.showAlert(with: error)
                        complition(nil)
                    }
            }
        }
    }
}
