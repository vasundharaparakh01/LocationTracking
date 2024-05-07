//
//  TrackinService.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 1/17/19.
//  Copyright © 2019 sdnmacmini32. All rights reserved.
//

import UIKit
//import AVFoundation

class TrackinService: APIService {
    // #show and hide loader in this class depending on your needs.
    // #you can make service class according to module
    // #show errors in this class, if you have any need where you want to show in controller class, then just by-pass error method.
    
    func startTracking(with id: [String], startlat: String, startlon: String, encodedcord: String, starttime: String, startlocname: String, target: BaseViewControler? = nil, complition: @escaping ((Array<TrackID>?), String?) -> Void) {
        let param = ["userId": AppInstance.shared.userid, "jobId": id, "startlongitude": startlon, "startlatitude": startlat, "encodedCords": encodedcord, "startDateTime": starttime, "startLocationName": startlocname] as [String : Any]
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.startmultipletracking, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    print(response)
                    // #parse response here
                    if let data = response["data"] as? Array<Dictionary<String, Any>> {
                        let track = TrackID.modelsFromDictionaryArray(array: data)
                        complition(track, response["message"] as? String ?? "")
                    }else{
                        complition(nil, response["message"] as? String ?? "")
                    }
                case .Error(let error):
                    if error == "You have already started the tracking in another device." {
                        UIAlertController.show(with: "APP_NAME".localized, message: error, preferredStyle: .alert, target: target, actions: [.Ok], handler: { (action) in
                            switch action{
                            case .Ok:
                                UserDefaults.standard.removeObject(forKey: "userObj")
                                UIUtility.movetoLoginVC()
                            default:
                                break
                            }
                            
                        })
                    } else {
                        target?.showAlertmsg(with: error)
                        complition(nil, error)
                    }
                }
            }
        }
    }
    
    func startTrackingcoordinates(with trackid: [[String:String]], allcordinates: String, target: BaseViewControler? = nil, complition: @escaping ((Array<TrackID>?), String?) -> Void) {
        let param = ["userId": AppInstance.shared.userid, "encodedCords": allcordinates, "trackingIds":trackid] as [String : Any]
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.stoptrackingcoordinates, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    print(response)
                  //  AudioServicesPlaySystemSound(1054); // For testing of background location updates...
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition(nil, nil)
                }
            }
        }
    }
    
    func stopTracking(with id:[[String:String]], totalKM: String, duration: String, noOfStops: String, encodedCords: String, endlongitude: String, endlatitude: String, endDateTime: String, endLocationName: String, target: BaseViewControler? = nil, complition: @escaping (String) -> Void) {
        let param = ["userId": AppInstance.shared.userid, "totalKM": totalKM, "duration": duration, "noOfStops": noOfStops, "encodedCords": encodedCords, "endlongitude": endlongitude, "endlatitude": endlatitude, "endDateTime": endDateTime, "endLocationName": endLocationName, "trackingIds": id] as [String : Any]
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.stoptracking, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    print(response)
                    // #parse response here
                    if let message = response["message"] as? String {
                        complition(message)
                    }
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition("")
                }
            }
        }
    }
    
    func getincidentreport(target: BaseViewControler? = nil, complition: @escaping ((Array<Incident>?)) -> Void) {
        target?.showLoader()
        super.startService(with: .GET, path: Config.getincidenttype, parameters: [:], files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    print(response)
                    // #parse response here
                    if let data = response["data"] as? Array<Dictionary<String, Any>> {
                        let incidentarray = Incident.modelsFromDictionaryArray(array: data)
                        complition(incidentarray)
                    }
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition(nil)
                }
            }
        }
    }
    
    func sendincidentreport(with pic: [String], incidentdesc: String, incidenttyppe: String, trackingid:[[String:String]], target: BaseViewControler? = nil, complition: @escaping (String?) -> Void) {
        let param = ["userId": AppInstance.shared.userid, "incidentDescription": incidentdesc, "incidentPic": pic, "incidentType": incidenttyppe, "trackIds": trackingid] as [String : Any]
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.incidentreport, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    print(response)
                    // #parse response here
                    complition(response["message"] as? String ?? "")
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition(nil)
                }
            }
        }
    }
    
    func stopTrackingFromWeb(complition: @escaping (String?) -> Void) {
        let ongoingTrack        = CoreDataStackManager.sharedManager.getCurrentTrackData()
        var trackingid          : [Dictionary<String, String>]  = []
        var trackingdict        = Dictionary<String, String>()
        for index in (ongoingTrack.enumerated()) {
            trackingdict["id"]  = ongoingTrack[index.offset].trackingid ?? ""
            trackingid.append(trackingdict)
        }
        let param = ["userId": AppInstance.shared.userid, "trackingIds": trackingid] as [String : Any]
        print(param)
        super.startService(with: .POST, path: Config.stopFromWeb, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .Success(let response):
                    print(response)
                    complition(response["data"] as? String ?? "")
                case .Error( _):
                    print("")
                }
            }
        }
    }
    
}
//MARK - Get user list for filter

extension TrackinService {
    func getUsersListForFilter(target: BaseViewControler? = nil, complition:@escaping ([ActiveUserListModel.Datum]) -> Void){
        target?.showLoader()
        super.startService(with: .GET, path: Config.getAssociatedUsers, parameters: [:], files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    // #parse response here
                    let decoder = JSONDecoder()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),  let activeUserListModel = try? decoder.decode(ActiveUserListModel.self, from: jsonData) {
                        complition(activeUserListModel.data ?? [])
                    } else {
                        complition([])
                    }
                    
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition([])
                }
            }
        }
    }
    
    func getActiveUserList(target: BaseViewControler? = nil, complition:@escaping ([ActiveUserListModel.Datum]) -> Void){
        target?.showLoader()
        super.startService(with: .GET, path: Config.getActiveAssociates, parameters: [:], files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    // #parse response here
                    let decoder = JSONDecoder()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),  let activeUserListModel = try? decoder.decode(ActiveUserListModel.self, from: jsonData) {
                        complition(activeUserListModel.data ?? [])
                    } else {
                        complition([])
                    }
                    
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition([])
                }
            }
        }
    }
    
    func getTrackDetails(trackId:String, isLoader:Bool = true, target: BaseViewControler? = nil, complition:@escaping ([ActiveUserListModel.Datum]) -> Void){
        if isLoader {
            target?.showLoader()
        }
        
        let param:[String:Any] = [
            "contractor": [
                [
                    "_id": trackId
                ]
            ]
        ]
        super.startService(with: .POST, path: Config.getUserTracking, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                if isLoader {
                    target?.hideLoader()
                }
                switch result {
                case .Success(let response):
                    // #parse response here
                    let decoder = JSONDecoder()
                    if let jsonData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),  let activeUserListModel = try? decoder.decode(ActiveUserListModel.self, from: jsonData) {
                        complition(activeUserListModel.data ?? [])
                    } else {
                        complition([])
                    }
                    
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition([])
                }
            }
        }
    }
}
