//
//  Pagination.swift
//  ServerCommunicationDemo
//
//  Created by KSHRD on 12/21/17.
//  Copyright © 2017 KSHRD. All rights reserved.
//

import Foundation
import SwiftyJSON

class Pagination {
    var page: Int
    var limit: Int
    var totalCount: Int
    var totalPages: Int
    
    init(page: Int, limit: Int, totalCount: Int) {
        self.page = page
        self.limit = limit
        self.totalCount = totalCount
        self.totalPages = totalCount/limit
    }
    
    init() {
        self.page = 0
        self.limit = 0
        self.totalCount = 0
        self.totalPages = 0
    }
    
    
}



