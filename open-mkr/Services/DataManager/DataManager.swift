//
//  DataManager.swift
//  open-mkr
//
//  Created by Makara on 2/1/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation

struct DataManager {
    struct URL {
        // Define url
        static let BASE = "https://demo.openmf.org/fineract-provider/api/v1/"
        static let AUTH = BASE + "authentication"
        static let CLIENT = BASE + "clients"
        static let SUFFIX = ""
        static let CLIENTOPTION = "?fields=id,displayName,officeName,accountNo,mobileNo&orderBy=accountNo&sortOrder=ASC" + SUFFIX
        static let CLIENTIMAGE = "https://demo.openmf.org/fineract-provider/api/v1/clients/"
        static let CLIENTIMAGESUFFIX = "/images?tenantIdentifier=default&pretty=true&maxHeight=120&maxWidth=120"
        static let CLIENTSEARCH = "&sqlSearch=display_name like "
        static let CLIENTOVERVIEW = "https://demo.openmf.org/fineract-provider/api/v1/clients/"
        static let CLIENTOVERVIEWSUFFIX = "/accounts?tenantIdentifier=default&pretty=true"
        static let CLIENTTEMPLATE =  "https://demo.openmf.org/fineract-provider/api/v1/clients/template"
        
        static let CREATECLIENT = "https://demo.openmf.org/fineract-provider/api/v1/clients"
    }
    
    static let HEADER = ["Authorization": "Basic bWlmb3M6cGFzc3dvcmQ=", "Fineract-Platform-TenantId": "default"]
    static let IMAGEHEADER = ["Authorization": "Basic bWlmb3M6cGFzc3dvcmQ=","Accept": "application/octet-stream"]
    
    
}
