//
//  TrackID.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 1/9/19.
//  Copyright © 2019 sdnmacmini32. All rights reserved.
//

import UIKit

class TrackID: NSObject {
    public var jobId                : String?
    public var trackingid           : String?
    public var lat                  : Double?
    public var long                 : Double?
    public var polyline             : String?
    public var stopStatus           : Bool?
    public var incidentStatus       : Bool?
    public var distance             : Double?
    public var noOfStops            : String?
   
    public override init() {
        jobId                       = ""
        trackingid                  = ""
        lat                         = 0.0
        long                        = 0.0
        polyline                    = ""
        stopStatus                  = false
        incidentStatus              = false
        distance                    = 0.0
        noOfStops                   = "0"
    }
    
    public class func modelsFromDictionaryArray(array:Array<Dictionary<String,Any>>) -> [TrackID] {
        var models:[TrackID] = []
        for item in array {
            let model = TrackID(dictionary: item)
            models.append(model!)
        }
        return models
    }
    
    required public init?(dictionary: Dictionary<String,Any>) {
        jobId               = dictionary["jobid"]           as? String ?? ""
        trackingid          = dictionary["trackingId"]      as? String ?? ""
        lat                 = dictionary["lat"]             as? Double ?? 0.0
        long                = dictionary["long"]            as? Double ?? 0.0
        polyline            = dictionary["polyline"]        as? String ?? ""
        stopStatus          = false
        incidentStatus      = false
        distance            = dictionary["distance"]        as? Double ?? 0.0
        noOfStops           = dictionary["noOfStops"]       as? String ?? "0"
    }
    
    public func dictionaryRepresentation() -> Dictionary<String,Any> {
        var dictionary = Dictionary<String,Any>()
        dictionary["jobid"]                 = jobId
        dictionary["trackingId"]            = trackingid
        dictionary["lat"]                   = lat
        dictionary["long"]                  = long
        dictionary["polyline"]              = polyline
        dictionary["stopStatus"]            = false
        dictionary["incidentStatus"]        = false
        dictionary["distance"]              = distance
        dictionary["noOfStops"]             = noOfStops
        return dictionary
    }
    
    func save() {
        CoreDataStackManager.sharedManager.saveCurrentTrackData(with: self, lat: lat ?? 0.0, long: long ?? 0.0, polyline: polyline ?? "")
    }
    
    func delete() {
        CoreDataStackManager.sharedManager.deleteCurrentTrack(trackingid: self.trackingid ?? "")
    }
    
}
