//
//  History.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/24/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit
import Polyline

class History: NSObject {

    public var jobId            : String?
    public var totalkm          : String?
    public var noofstops        : String?
    public var duration         : String?
    public var startlocation    : String?
    public var endlocation      : String?
    public var comment          : String?
    public var startdate        : String?
    public var enddate          : String?
    public var kmlfile          : String?
    public var coordinates      : String?
    public var trackid          : String?
    public var count            : String?
    public var firstname        : String?
    public var lastname         : String?
    public var tIdAssociate     : String?


    public var startDate: String {
        let localDate   = TimeUtils.UTCToLocal(startdate)
        let date        = TimeUtils.dateFromString(localDate, with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let datestring  = TimeUtils.stringFromdate(date, with: "dd MMM yyyy")
        return datestring
    }
    
    public var starttime: String {
        let localDate   = TimeUtils.UTCToLocal(startdate)
        let date        = TimeUtils.dateFromString(localDate, with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let timestring  = TimeUtils.stringFromdate(date, with: "hh:mm")
        return timestring
    }
    
    public var endtime:String {
        let localDate   = TimeUtils.UTCToLocal(enddate)
        let date        = TimeUtils.dateFromString(localDate, with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let timestring  = TimeUtils.stringFromdate(date, with: "hh:mm")
        return timestring
    }
    
    public var starttime24HourFormat: String {
        let localDate   = TimeUtils.UTCToLocal(startdate)
        let date        = TimeUtils.dateFromString(localDate, with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let timestring  = TimeUtils.stringFromdate(date, with: "HH:mm")
        return timestring
    }
    
    public var endtime24HourFormat:String {
        let localDate   = TimeUtils.UTCToLocal(enddate)
        let date        = TimeUtils.dateFromString(localDate, with: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        let timestring  = TimeUtils.stringFromdate(date, with: "HH:mm")
        return timestring
    }
    
    public var coordinatearray:[CLLocationCoordinate2D] {
        let polyline = Polyline(encodedPolyline: coordinates ?? "")
        let decodedCoordinates : Array<CLLocationCoordinate2D> = polyline.coordinates!
        return decodedCoordinates
    }

    public class func modelsFromDictionaryArray(array:Array<Dictionary<String,Any>>) -> [History]
    {
        var models:[History] = []
        for item in array
        {
            let model = History(dictionary: item)
            models.append(model!)
        }
        return models
    }
    
    public override init() {
        jobId               = ""
        totalkm             = ""
        noofstops           = ""
        duration            = ""
        startlocation       = ""
        endlocation         = ""
        comment             = ""
        startdate           = ""
        enddate             = ""
        kmlfile             = ""
        coordinates         = ""
        trackid             = ""
        firstname           = ""
        lastname            = ""
        tIdAssociate        = ""
    }
    
    required public init?(dictionary: Dictionary<String,Any>) {
        jobId               = dictionary["jobId"]               as? String ?? ""
        totalkm             = dictionary["totalKM"]             as? String ?? ""
        noofstops           = dictionary["noOfStops"]           as? String ?? ""
        duration            = dictionary["duration"]            as? String ?? ""
        startlocation       = dictionary["startLocationName"]   as? String ?? ""
        endlocation         = dictionary["endLocationName"]     as? String ?? ""
        comment             = dictionary["comment"]             as? String ?? ""
        startdate           = dictionary["startDateTime"]       as? String ?? ""
        enddate             = dictionary["endDateTime"]         as? String ?? ""
        kmlfile             = dictionary["kmlURl"]              as? String ?? ""
        coordinates         = dictionary["coordinatencoded"]    as? String ?? ""
        trackid             = dictionary["_id"]                 as? String ?? ""
        count               = dictionary["count"]               as? String ?? ""
        firstname           = dictionary["firstname"]           as? String ?? ""
        tIdAssociate        = dictionary["trackid"]             as? String ?? ""
        lastname            = dictionary["lastname"]            as? String ?? ""
    }
    
    public func dictionaryRepresentation() -> Dictionary<String,Any> {
        var dictionary = Dictionary<String,Any>()
        dictionary["jobId"]                 =  jobId
        dictionary["totalKM"]               = totalkm
        dictionary["noOfStops"]             = noofstops
        dictionary["duration"]              = duration
        dictionary["startLocationName"]     = startlocation
        dictionary["endLocationName"]       = endlocation
        dictionary["comment"]               = comment
        dictionary["startDateTime"]         = startdate
        dictionary["endDateTime"]           = enddate
        dictionary["kmlURl"]                = kmlfile
        dictionary["coordinatencoded"]      = coordinates
        dictionary["_id"]                   = trackid
        dictionary["firstname"]             = firstname
        dictionary["lastname"]              = lastname
        dictionary["count"]                 = count
        dictionary["tIdAssociate"]          = tIdAssociate
        return dictionary
    }
   
}

//MARK:- to convert coordinates into lat lon
struct CoordinatesHelper {
    static func getCoordinates(coordinates:String?)->[CLLocationCoordinate2D]  {
        let polyline = Polyline(encodedPolyline: coordinates ?? "")
        let decodedCoordinates : Array<CLLocationCoordinate2D> = polyline.coordinates!
        return decodedCoordinates
    }
}
