//
//  Extension+Date.swift
//  IntervalloPatient
//
//  Created by Subhash Kumar on 8/27/18.
//  Copyright © 2018 Subhash Kumar. All rights reserved.
//

import Foundation

extension Date{
    func dateString(withFormat format: String = "yyyy-MM-dd") -> String {
        let formatter           = DateFormatter()
        formatter.dateFormat    = format
        return formatter.string(from: self)
    }
}
