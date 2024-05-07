
//
//  Constant.swift
//  Inchora App
//
//  Created by Subhash Kumar on 09/10/18.
//  Copyright © 2018 smartData. All rights reserved.

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class User: NSObject, NSCoding {
    public var userid       : String?
    public var updatedat    : String?
	public var email        : String?
	public var username     : String?
	public var profileimage : String?
	public var firstname    : String?
	public var lastname     : String?
    public var token        : String?
    var role                : String?

    public func encode(with aCoder: NSCoder) {
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
    }

    public class func modelsFromDictionaryArray(array:Array<Dictionary<String,Any>>) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item )!)
        }
        return models
    }
    
    public override init() {
        email               = ""
        username            = ""
        profileimage        = ""
        firstname           = ""
        lastname            = ""
        token               = ""
        updatedat           = ""
        userid              = ""
        role                = ""
    }

	required public init?(dictionary: Dictionary<String, Any>) {

		email           = dictionary["email"]           as? String ?? ""
		username        = dictionary["username"]        as? String ?? ""
		profileimage    = dictionary["profile_image"]   as? String ?? ""
		firstname       = dictionary["firstname"]       as? String ?? ""
        lastname        = dictionary["lastname"]        as? String ?? ""
        token           = dictionary["token"]           as? String ?? ""
        updatedat       = dictionary["updatedAt"]       as? String ?? ""
        userid          = dictionary["_id"]             as? String ?? ""
        role            = dictionary["role"]            as? String ?? ""

	}

	public func dictionaryRepresentation() -> Dictionary<String, Any> {
        var dictionary = Dictionary<String,Any>()
        dictionary["email"]         = self.email
        dictionary["username"]      = self.username
        dictionary["profile_image"] = self.profileimage
        dictionary["firstname"]     = self.firstname
        dictionary["lastname"]      = self.lastname
        dictionary["role"]          = self.role
        dictionary["token"]         = self.token
        dictionary["_id"]           = self.userid
        dictionary["updatedAt"]     = self.updatedat
        return dictionary
	}

}
