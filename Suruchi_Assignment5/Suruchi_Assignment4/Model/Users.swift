//
//  Users.swift
//  Suruchi_Assignment4
//
//  Created by Suruchi Singh on 4/6/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

class UsersModel: NSObject {
    
    var id: String?
    var userName: String?
    var email: String?
    var fullName: String?
    var birthday: String?
    var contact: String?
    var location: String?
    var university: String?
    var profilePicUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.userName = dictionary["userName"] as? String
        self.email = dictionary["email"] as? String
        self.fullName = dictionary["fullName"] as? String
        self.birthday = dictionary["birthday"] as? String
        self.contact = dictionary["contact"] as? String
        self.location = dictionary["location"] as? String
        self.university = dictionary["university"] as? String
        self.profilePicUrl = dictionary["profilePicUrl"] as? String
    }
    
}
