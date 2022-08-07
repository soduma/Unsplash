//
//  NetworkManager.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/14.
//

import Foundation
import Alamofire

class NetworkManager {
    let urlString = "https://api.unsplash.com/search/photos/?client_id=oqnMOq60UFw7nPf-1c2UDXVw0woMt00hVPQqZbmVvO0"
    
    // MARK: - with Async
    func fetchWithAsync(keyword: String, page: Int) async -> Result<Unsplash, AFError> {
        let keyword = keyword.replacingOccurrences(of: " ", with: "")
        let url = urlString + "&query=\(keyword)&page=\(page)"
        let data = await AF.request(url, method: .get).serializingDecodable(Unsplash.self).result
        return data
    }
    
    // MARK: - ordinary
    func fetchImage(keyword: String, page: Int, completion: @escaping (Result<Unsplash, AFError>) -> Void) {
        let url = urlString + "&query=\(keyword)&page=\(page)"
        
        AF.request(url, method: .get)
            .responseDecodable(of: Unsplash.self) { response in
                let data = response.result
                completion(data)
                return
            }
            .resume()
    }
}
