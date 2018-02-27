//
//  ClientService.swift
//  ServerCommunicationDemo
//
//  Created by Kokpheng on 12/15/17
//  Copyright © 2017 Kokpheng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Kingfisher
import AlamofireImage

protocol ClientServiceDelegate {
    func didRecievedClient(with clients: [Client]?, pagination: Pagination?, error: Error?)
    func didRecievedClient(with clients: Client?, error: Error?)
    
    func didAddedClient(error: Error?)
    func didUpdatedClient(error: Error?)
    func didDeletedClient(error: Error?)
}

extension ClientServiceDelegate {
    func didRecievedClient(with clients: [Client]?, pagination: Pagination?, error: Error?) {}
    func didRecievedClient(with clients: Client?, error: Error?) {}
    
    func didAddedClient(error: Error?) {}
    func didUpdatedClient(error: Error?) {}
    func didDeletedClient(error: Error?){}
}



class ClientService {
    
    var delegate: ClientServiceDelegate?
    
    // Get Client by page number and limit
    func getData(pageNumber: Int, url: String) {
        
        let offset = (pageNumber - 1) * 15 //+ 1
        print("page number: \(pageNumber) => offsset: \(offset)")
        
        Alamofire.request(url,
                          method: .get,
                          parameters: ["offset": offset, "limit": 15],
                          encoding: URLEncoding.default, // JSONEncoding.default
            headers: DataManager.HEADER)
            .responseJSON { (response) in
                //print(response)
                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    // get pagination value
                    let pagination = Pagination(page: pageNumber, limit: 15, totalCount: json["totalFilteredRecords"].intValue)

                    let clients =  json["pageItems"].arrayValue.map{ Client($0) }
                    
                    self.delegate?.didRecievedClient(with: clients, pagination: pagination, error: nil)
                    
                    
                case .failure(let error):
                    self.delegate?.didRecievedClient(with: nil, pagination: nil, error: error)
                }
        }
    }
    
    
    func createClient(client: ClientTemplate) {
        
        let params: [String: Any] = ["officeId": client.officeId,
                      "firstname": client.firstName,
                      "lastname": client.lastName,
                      "externalId": client.externalId,
                      "dateFormat": "dd MMM yyyy",
                      "dateOfBirth": client.dob,
                      "locale": "en",
                      //"active": true          ,
                      //"activationDate": client.activationDate,
                      "mobileNo": client.mobileNo,
                      "genderId": client.genderId,
                      "clientTypeId": client.clientTypeId,
                      "clientClassificationId": client.clientClassificationId,
                      "staffId": client.staffId ]
        
        Alamofire.request(DataManager.URL.CREATECLIENT,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
               
                print(params)
                 print(response)
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    guard let clientId = json["clientId"].int, clientId > 0 else {
                        // Report any error we got.
                        let dict =  [NSLocalizedDescriptionKey : "Failed to create client"]
                        let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                        // Error
                        self.delegate?.didAddedClient(error: error)
                        
                        return
                    }
                    // Success
                    self.delegate?.didAddedClient(error: nil)
                    
                case .failure(let error):
                    self.delegate?.didAddedClient(error: error)
                }
        }

    }
    
    func deleteClient(by id: Int) {
        let url = "\(DataManager.URL.CLIENT)/\(id)"
        print(url)
        Alamofire.request(url,
                          method: .delete,
                          //parameters: [""],
                          encoding: JSONEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
                print(response)
                
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    guard let clientId = json["clientId"].int, clientId > 0 else {
                        // Report any error we got.
                        let dict =  [NSLocalizedDescriptionKey : "Failed to delete client"]
                        let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                        // Error
                        self.delegate?.didDeletedClient(error: error)
                        
                        return
                    }
                    // Success
                    self.delegate?.didDeletedClient(error: nil)
                    
                case .failure(let error):
                    self.delegate?.didDeletedClient(error: error)
                }
        }
    }
    
    func getClientImage(id: Int, completion: @escaping (DataResponse<UIImage>?, Error?)->()) {
        let url = DataManager.URL.CLIENTIMAGE + "\(id)" + DataManager.URL.CLIENTIMAGESUFFIX
       
        Alamofire.request(url,headers: DataManager.IMAGEHEADER)
            .responseImage { (response) in
//                print(response)
                switch response.result {
                case .success:
                    completion(response, nil)
                case .failure(let error):
                    //print(error.localizedDescription)
                    completion(nil, error)
                }
        }
    }
    
    /*func getClient(by id: String) {
        Alamofire.request("\(DataManager.URL.Client)/\(id)",
                          method: .get,
                          encoding: URLEncoding.default, // JSONEncoding.default
                          headers: DataManager.HEADER)
            .responseJSON { (response) in

                switch response.result {
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    guard let code = json["code"].int, code == 2222 else {
                        // Report any error
                        let dictionary = [NSLocalizedDescriptionKey: json["message"].string ?? "unknown"]
                        let host = response.request?.url?.host ?? "unknown"
                        let error = NSError(domain: host, code: 9999, userInfo: dictionary)
                        self.delegate?.didRecievedClient(with: nil, pagination: nil, error: error)
                        return
                    }
                   
                    // Get Client
                    let Clients = Client(json["data"])
                    
                    // Call delegate with success
                    self.delegate?.didRecievedClient(with: Clients, error: nil)
                    
                case .failure(let error):
                    // Call delegate with error
                    self.delegate?.didRecievedClient(with: nil, error: error)
                }
        }
    }
    
    func addClient(paramaters: [String: Any]) {
        Alamofire.request(DataManager.URL.Client,
                          method: .post,
                          parameters: paramaters,
                          encoding: JSONEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    guard let code = json["code"].int, code == 2222 else {
                        // Report any error we got.
                        let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                        let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                       // Error
                        self.delegate?.didAddedClient(error: error)
                        
                        return
                    }
                    // Success
                    self.delegate?.didAddedClient(error: nil)
                    
                case .failure(let error):
                    self.delegate?.didAddedClient(error: error)
                }
        }
    }
    
    func updateClient(with id: String, paramaters: [String: Any]) {
        Alamofire.request("\(DataManager.URL.Client)/\(id)",
                          method: .put,
                          parameters: paramaters,
                          encoding: JSONEncoding.default,
                          headers: DataManager.HEADER)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    guard let code = json["code"].int, code == 2222 else {
                        // Report any error we got.
                        let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                        let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                        // Error
                        self.delegate?.didUpdatedClient(error: error)
                        
                        return
                    }
                    // Success
                    self.delegate?.didUpdatedClient(error: nil)
                    
                case .failure(let error):
                    self.delegate?.didUpdatedClient(error: error)
                }
        }
    }
    
    func deleteClient(with id: String, completion: @escaping (Error?) -> ()) {
        Alamofire.request("\(DataManager.URL.Client)/\(id)",
            method: .delete,
            headers: DataManager.HEADER)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    guard let code = json["code"].int, code == 2222 else {
                        // Report any error we got.
                        let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                        let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                        // Error
                        completion(error)
                        
                        return
                    }
                    // Success
                    completion(nil)
                    
                case .failure(let error):
                    completion(error)
                }
        }
    }
    
    func uploadFile(file : Data, completion: @escaping (String?, Error?) -> ()) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(file, withName: "file", fileName: ".jpg", mimeType: "image/jpeg") // append image
            
        }, to: DataManager.URL.FILE,
           method: .post,
           headers: DataManager.HEADER,
           encodingCompletion: { (encodingResult) in
            switch encodingResult {
               
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        guard let code = json["code"].int, code == 2222 else {
                            // Report any error we got.
                            let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                            let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                            completion(nil, error)
                            return
                        }
                        
                        guard let url = json["data"].string else {
                            // Report any error we got.
                            let dict =  [NSLocalizedDescriptionKey : json["message"].string ?? "unknown"]
                            let error = NSError(domain: response.request?.url?.host ?? "unknown", code: 9999, userInfo: dict)
                            completion(nil, error)
                            return
                        }
                        
                        completion(url, nil)
                    }
                }
            case .failure(let error):
                completion(nil, error)
            }
        })
    }*/
}











