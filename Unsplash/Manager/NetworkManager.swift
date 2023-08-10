//
//  NetworkManager.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/14.
//

import Foundation
import Alamofire

class NetworkManager {
    private let key = "oqnMOq60UFw7nPf-1c2UDXVw0woMt00hVPQqZbmVvO0"
    
    func fetchUnsplash(keyword: String, page: Int) async -> Result<Unsplash, AFError> {
        let urlString = "https://api.unsplash.com/search/photos/?client_id=\(key)"
        let url = urlString + "&query=\(keyword)&page=\(page)"
        
        let result = await AF.request(url, method: .get)
            .serializingDecodable(Unsplash.self).result
        return result
    }
}
