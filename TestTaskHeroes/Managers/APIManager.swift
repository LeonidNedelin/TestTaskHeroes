//
//  APIManager.swift
//  TestTaskHeroes
//
//  Created by leanid niadzelin on 11/23/18.
//  Copyright © 2018 Leanid Niadzelin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class APIManager {
    
    static let shared = APIManager()
    let manager = Alamofire.SessionManager.default

    private init() {
        manager.session.configuration.timeoutIntervalForRequest = 10
    }
    
    let baseURL = "https://gateway.marvel.com"
    let ts = "1"
    let apikey = "19cdc442b980ee765506549a673e232a"
    let hash = "9f6d7bbf92a066d25268550d8802e3f0"
    
    func getHeroes(offset: String="0", limit: String, completionHandler: @escaping ([Hero]) -> ()) {
        let parameters: Parameters = [
            "ts": ts,
            "apikey": apikey,
            "hash": hash,
            "limit": limit,
            "offset": offset
        ]
        
        guard let url = URL(string: "https://gateway.marvel.com/v1/public/characters") else { return }
        manager.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).validate().responseJSON { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                var heroes = [Hero]()
                do {
                    let json = try JSON(data: data)
                    let results = json["data"]["results"].array
                    results?.forEach({ (json) in
                        let hero = Hero(json: json)
                        heroes.append(hero)
                    })
                    completionHandler(heroes)
                } catch let error {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
