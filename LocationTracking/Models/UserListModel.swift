//
//  UserListModel.swift
//  AdTrak
//
//  Created by Janesh Suthar on 25/11/21.
//  Copyright © 2021 sdnmacmini32. All rights reserved.
//

import UIKit

struct ActiveUserListModel: Codable {
    var code: Int?
    var status, message: String?
    var data: [Datum]?
    struct Datum: Codable {
        var trackername, jobID, firstname, lastname,userid: String?
        var color, startDateTime, encodedCords: String?

        enum CodingKeys: String, CodingKey {
            case trackername
            case jobID = "jobId"
            case firstname, lastname, color, startDateTime, encodedCords,userid
        }
    }
}
