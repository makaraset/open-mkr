//
//  ClientTemplateService.swift
//  open-mkr
//
//  Created by Makara on 2/20/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol ClientTemplateServiceDelegate {

    func didRecievedClientTemplate( genderOtions: [GenderOption]?,
                                    clientTypes: [ClientType]?,
                                    clientClassfications: [ClientClassification]?,
                                    staffs: [Staff]?,
                                    branches: [Branch]?,
                                    error: Error?)
}

extension ClientTemplateServiceDelegate{
    
    func didRecievedClientTemplate( genderOtions: [GenderOption]?,
                                    clientTypes: [ClientType]?,
                                    clientClassfications: [ClientClassification]?,
                                    staffs: [Staff]?,
                                    branches: [Branch]?,
                                    error: Error?){}
}

class ClientTemplateService{
    
    var delegate: ClientTemplateServiceDelegate?
    
    func getData() {
        let url = DataManager.URL.CLIENTTEMPLATE
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: URLEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    let genders = json["genderOptions"].arrayValue.map{GenderOption($0)}
                    let clientTypes = json["clientTypeOptions"].arrayValue.map{ClientType($0)}
                    let clientClassifications = json["clientClassificationOptions"].arrayValue.map{ClientClassification($0)}
                    let staffs = json["staffOptions"].arrayValue.map{Staff($0)}
                    let branches = json["officeOptions"].arrayValue.map{Branch($0)}
                    
                    self.delegate?.didRecievedClientTemplate(genderOtions: genders, clientTypes: clientTypes, clientClassfications: clientClassifications, staffs: staffs, branches: branches, error: nil)
                case .failure(let error):
                    
                    self.delegate?.didRecievedClientTemplate(genderOtions: nil, clientTypes: nil, clientClassfications: nil, staffs: nil, branches: nil, error: error)
                    
                }
        }
    }
}
