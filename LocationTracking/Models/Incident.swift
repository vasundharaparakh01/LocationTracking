//
//  Incident.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 1/11/19.
//  Copyright © 2019 sdnmacmini32. All rights reserved.
//

import UIKit

class Incident: NSObject {
    
    public var incidenttype         : String?
    public var incidentid           : String?
    
    public class func modelsFromDictionaryArray(array:Array<Dictionary<String,Any>>) -> [Incident] {
        var models:[Incident] = []
        for item in array {
            let model = Incident(dictionary: item)
            models.append(model!)
        }
        return models
    }
    
    public override init() {
        incidenttype                    = ""
        incidentid                      = ""
    }
    
    required public init?(dictionary: Dictionary<String,Any>) {
        incidenttype                    =  dictionary["IncidentType"] as? String
        incidentid                      =  dictionary["_id"] as? String
    }
    
    public func dictionaryRepresentation() -> Dictionary<String,Any> {
        var dictionary = Dictionary<String,Any>()
        dictionary["IncidentType"]      =  incidenttype
        dictionary["_id"]               = incidentid
        return dictionary
    }
    
    
}
