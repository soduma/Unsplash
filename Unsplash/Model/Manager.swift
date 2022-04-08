//
//  Manager.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/14.
//

import Foundation
import Alamofire

class Manager {
    func fetchWithAsync(keyword: String, page: Int) async -> Result<UnsplashAPI, AFError> {
        let url = "https://api.unsplash.com/search/photos/?client_id=oqnMOq60UFw7nPf-1c2UDXVw0woMt00hVPQqZbmVvO0&query=\(keyword)&page=\(page)"
        
        let data = await AF.request(url, method: .get).serializingDecodable(UnsplashAPI.self).result
        return data
    }
}
