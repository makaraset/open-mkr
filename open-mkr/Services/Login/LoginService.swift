//
//  LoginService.swift
//  open-mkr
//
//  Created by Makara on 2/1/18.
//  Copyright © 2018 Makara. All rights reserved.
//

import Foundation
import Alamofire

class LoginService{
    
    private init() {}
    static let shared: LoginService = LoginService() // Create Singleton instance
    
    func login(user: String, password: String, completion: @escaping (DataResponse<Any>?, Error?)->() ) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let url = DataManager.URL.AUTH + "?username=" + user + "&password=" + password + DataManager.URL.SUFFIX
        
        Alamofire.request(
            url,
            method: .post,
            encoding: JSONEncoding.default,
            headers:headers
            
            ).responseJSON{ response in
            
            switch response.result {
            case .success: 
                completion(response,nil)
            case .failure(let error):
                completion(nil, error)
            }}
    }
    
}
