//
//  Client.swift
//  open-mkr
//
//  Created by Makara on 2/2/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation
import SwiftyJSON

class ClientTemplate {
    var clientId: Int
    var firstName: String
    var middleName: String
    var lastName: String
    var displayName: String
    var mobileNo: String
    var externalId: String
    var genderId: Int
    var dob: String
    var clientTypeId: Int
    var clientClassificationId: Int
    var officeId: Int
    var staffId: Int
    var activationDate: String
    
    init(_ data: JSON) {
        self.officeId = data["officeId"].intValue
        self.clientId = data["clientId"].intValue
        self.firstName = ""
        self.middleName = ""
        self.lastName = ""
        self.displayName = ""
        self.mobileNo = ""
        self.externalId = ""
        self.genderId = 0
        self.dob = ""
        self.clientTypeId = 0
        self.clientClassificationId = 0
        self.staffId = 0
        self.activationDate = ""
        
    }
    
    init(clientId: Int, firstName: String, middleName: String, lastName: String, displayName: String, mobileNo: String, externalId: String, genderId: Int, dob: String, clientTypeId: Int, clientClassificationId: Int, officeId: Int, staffId: Int, activationDate: String) {
        self.clientId = clientId
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.displayName = displayName
        self.mobileNo = mobileNo
        self.externalId = externalId
        self.genderId = genderId
        self.dob = dob
        self.clientTypeId = clientTypeId
        self.clientClassificationId = clientClassificationId
        self.officeId = officeId
        self.staffId = staffId
        self.activationDate = activationDate
    }
}
