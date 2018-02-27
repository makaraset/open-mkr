//
//  Staff.swift
//  open-mkr
//
//  Created by Makara on 2/20/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation
import SwiftyJSON

class Staff {
    
    var id: Int
    var firstName: String
    var lastName: String
    var displayName: String
    var isLoanOfficer: Bool
    var isActive: Bool
    
    init(_ data: JSON) {
        
        self.id = data["id"].intValue
        self.firstName = data["firstname"].stringValue
        self.lastName = data["lastname"].stringValue
        self.displayName = data["displayName"].stringValue
        self.isLoanOfficer = data["isLoanOfficer"].boolValue
        self.isActive = data["isActive"].boolValue
    
    }
    
    init() {
        id = 0
        firstName = ""
        lastName = ""
        displayName = ""
        isLoanOfficer = false
        isActive = true
    }
    
}
