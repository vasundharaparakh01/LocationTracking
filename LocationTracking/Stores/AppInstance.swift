//
//  AppInstance.swift
//  Docsink
//
//  Created by Amit Kumar Shukla on 9/6/16.
//  Copyright (c) 2016 Docsink. All rights reserved.
//
// Use this class for storing shared instances

import Foundation
import UIKit
import Polyline

class AppInstance: NSObject {
   
    static let shared                       = AppInstance()
    let kUserDefault                        = UserDefaults.standard
    var user                : User?
    var deviceToken         : String? {
        return UserDefaults.standard.value(forKey: "device_token") as? String
    }
    var token:String? {
        return user?.token ?? ""
    }
    var userid: String {
        return AppInstance.shared.user?.userid ?? ""
    }
    
    var getTypeOfUser: UserType {
        return (AppInstance.shared.user?.role?.lowercased() ?? "") == "primary" ? .primary : .associate
    }
    
    override init() {
        super.init()
    }
    
    func saveObject(_ obj: AnyObject, key: NSString){
        UserDefaults.standard.set(obj, forKey: key as String)
        UserDefaults.standard.synchronize()
    }
    
    func retriveObjectForKey(_ key: NSString) -> AnyObject{
        return (((UserDefaults.standard.object(forKey: key as String)) as AnyObject))
    }
    
    func getDateFromString(dateString:Date) -> String {
        let dateFormatterGet            = DateFormatter()
        dateFormatterGet.dateFormat     = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint          = DateFormatter()
        dateFormatterPrint.dateFormat   = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        let dateStr:String              = dateFormatterGet.string(from: dateString)
        var dateConverted               : String?
        if let date = dateFormatterGet.date(from: dateStr)  {
            let dateStrConverted:String = dateFormatterPrint.string(from: date)
            if let date1 = dateFormatterPrint.date(from: dateStrConverted)  {
                dateConverted = dateFormatterPrint.string(from: date1)
            }
        }
        if let dateValue = dateConverted  {
           return dateValue
        }
        return ""
    }
    
    func getDateFetchDataFromString(dateString:String) -> Date {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        let dateConverted           = dateFormatter.date(from: dateString)
        if let dateValue = dateConverted {
            return dateValue
        }
        return Date()
    }
}

enum UserType {
    case associate
    case primary
}
