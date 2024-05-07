//
//  TimeUtils.swift
//  Docsink
//
//  Created by Amit Kumar Shukla on 12/11/17.
//  Copyright © 2017 Docsink. All rights reserved.
//

import Foundation

extension Date {
    var startOfMonth:Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    var endOfMonth:Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    }
    
    var startOfQuarter: Date {
        var components = Calendar.current.dateComponents([.month, .year], from: self)
        let newMonth: Int
        switch components.month! {
        case 1,2,3: newMonth        = 1
        case 4,5,6: newMonth        = 4
        case 7,8,9: newMonth        = 7
        case 10,11,12: newMonth     = 10
        default: newMonth           = 1
        }
        components.month = newMonth
        return Calendar.current.date(from: components)!
    }
    
    var endOfQuarter: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 3, day: -1), to: startOfQuarter)!
    }
    
    var startOfYear: Date {
        var components      = Calendar.current.dateComponents([.month, .year], from: self)
        components.month    = 1
        return Calendar.current.date(from: components)!
    }
    
    var endOfYear: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 12, day: -1), to: startOfYear)!
    }
    
    var unixTimeStamp:String {
        return "\(self.timeIntervalSince1970 * 1000)"
    }
}

extension TimeInterval {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    private var seconds: Int {
        return Int(self) % 60
    }
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    private var hours: Int {
        return Int(self) / 3600
    }
    var stringTime: String {
        return "\(hours):\(minutes):\(seconds)"
    }
}

class TimeUtils {
   
    // Mark- Convert date from string
    class func dateFromString(_ strDate: String?, with format: String) -> Date? {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = format
        let result                  = dateFormatter.date(from: strDate ?? "")
        return result
    }
    
    // Mark- Convert string form date
    class func stringFromdate(_ date:Date?, with format:String) -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = format
        return dateFormatter.string(from: date ?? Date())
    }
    
    // Mark- Convert date to new formate
    class func convertDateFormater(_ strDate:String?, fromFormat:String, toFormat:String) -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = fromFormat
        let newDate                 = dateFormatter.date(from: strDate!)
        return self.stringFromdate(newDate, with: toFormat)
    }
    
    // Mark- Get time diff between dates
    class func timeIntervalBetweenDates(startDate strStartDate:String?, enddate strEndDate:String?, with format:String)->TimeInterval {
        let sDate = self.dateFromString(strStartDate, with: format)
        let edate = self.dateFromString(strEndDate, with: format)
        return edate!.timeIntervalSince(sDate!)
    }
    
    class func UTCToLocal(_ date: String?) -> String {
        if date != nil && date != ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let dt = dateFormatter.date(from: date ?? "")
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//29th Nov 2018
            return dateFormatter.string(from: dt ?? Date())
        }
        return ""
    }
  
}
