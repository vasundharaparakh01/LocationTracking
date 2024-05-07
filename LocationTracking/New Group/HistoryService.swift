//
//  HistoryService.swift
//  AdTrak
//
//  Created by sdnmacmini32 on 12/24/18.
//  Copyright © 2018 sdnmacmini32. All rights reserved.
//

import UIKit

class HistoryService: APIService {
    // #show and hide loader in this class depending on your needs.
    // #you can make service class according to module
    // #show errors in this class, if you have any need where you want to show in controller class, then just by-pass error method.
    
    func getHistoryData(with page: Int, limit: Int, startdate: String, enddate: String, jobid: String, target: BaseViewControler? = nil, complition: @escaping ((Array<History>?), Int) -> Void) {
        let param = ["userId": AppInstance.shared.userid, "page": page, "limit": limit, "startDate": startdate, "jobId": jobid, "endDate": enddate] as [String : Any]
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.history, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    // #parse response here
                    print(response)
                    if let data = response["data"] as? Array<Dictionary<String,Any>> {
                        let history = History.modelsFromDictionaryArray(array: data)//5c4944259799cd7341c3e19d
                        let totalcount = response["count"] as? Int ?? 0
                        complition(history, totalcount)
                    } else {
                        complition(nil, 0)
                    }
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition(nil, 0)
                }
            }
        }
    }
    // MARK: -- Get Associate track history..
    func getAssociateHistoryData(with page: Int,
                                 limit: Int,
                                 startdate: String,
                                 enddate: String,
                                 jobid: String,
                                 target: BaseViewControler? = nil,
                                 associates:[[String:Any]],
                                 complition: @escaping ((Array<History>?), Int) -> Void) {
       
        let param = [//"userId": AppInstance.shared.userid,
                     "page": page,
                     "limit": limit,
                     "startDate": startdate,
                     "jobId": jobid,
                     "endDate": enddate,
                     "associates" : associates] as [String : Any]
        
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.associateHistory, parameters: param, files: []) { (result) in
            DispatchQueue.main.async {
                target?.hideLoader()
                switch result {
                case .Success(let response):
                    // #parse response here
                    print(response)
                    if let data = response["data"] as? Array<Dictionary<String,Any>> {
                        let history = History.modelsFromDictionaryArray(array: data)//5c4944259799cd7341c3e19d
                        let totalcount = response["count"] as? Int ?? 0
                        complition(history, totalcount)
                    } else {
                        complition(nil, 0)
                    }
                case .Error(let error):
                    // #display error message here
                    target?.showAlertmsg(with: error)
                    complition(nil, 0)
                }
            }
        }
    }
    func submitComment(with image: String, trackid: String, commenttxt: String, target: BaseViewControler? = nil, complition: @escaping (String?) -> Void) {
        let param = ["comment_image": image, "trackId": trackid, "comment": commenttxt]
        print(param)
        target?.showLoader()
        super.startService(with: .POST, path: Config.comment, parameters: param, files: []) { (result) in
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
    
    func editJobID(with id: String, jobid: String, target: BaseViewControler? = nil, complition:@escaping (String?) -> Void) {
        let param = ["Id": id, "jobId": jobid]
        target?.showLoader()
        super.startService(with: .POST, path: Config.editjob, parameters: param, files: []) { (result) in
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
  
}
